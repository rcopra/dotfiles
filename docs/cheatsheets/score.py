#!/usr/bin/env python3
"""Score hotkey inventories: usefulness x novelty.

Reads docs/cheatsheets/data/<tool>.json, computes a `scoring` object per
hotkey, writes the files back in place, and emits data/ranked.json.
Idempotent: recomputes heuristics on every run, preserves quiz results
(`scoring.known`).

Novelty is estimated from git line age (how long the binding has existed
under your fingers), platform-convention obviousness, and mnemonic match.
Caveat: line age underestimates familiarity for tools used before their
config entered git (dotfiles repo born 2026-01; the quiz corrects this).
"""

import json
import re
import subprocess
import sys
from datetime import date, datetime
from pathlib import Path

DATA_DIR = Path(__file__).resolve().parent / "data"
CHEZMOI_ROOT = Path.home() / ".local/share/chezmoi"
NVIM_ROOT = Path.home() / ".config/nvim"

TOOLS = ["karabiner", "omniwm", "zellij", "ghostty", "neovim", "shell"]

CAT_WEIGHT = {
    "navigation": 0.90,
    "pane-management": 0.85,
    "window-management": 0.85,
    "workspace": 0.85,
    "session": 0.80,
    "search": 0.80,
    "launcher": 0.80,
    "tab-management": 0.75,
    "lsp": 0.70,
    "git": 0.70,
    "editing": 0.65,
    "completion": 0.60,
    "layout": 0.60,
    "test": 0.55,
    "debug": 0.50,
    "misc": 0.40,
}

# Reachability: how cheap is the context this key lives in.
FULL_MODES = {
    "global", "locked", "normal", "insert", "visual", "select",
    "terminal", "niri", "neo-tree",
}
ZELLIJ_SUBMODES = {
    "pane", "tab", "resize", "move", "scroll", "search", "entersearch",
    "session", "renametab", "renamepane",
}

# Chords everyone with a Mac/terminal already knows: novelty capped.
CONVENTIONS = {
    "cmd+c", "cmd+v", "cmd+x", "cmd+a", "cmd+z", "cmd+s", "cmd+q",
    "cmd+n", "cmd+w", "cmd+t", "cmd+f", "cmd+enter",
    "ctrl+r", "ctrl+c", "tab", "up", "down", "left", "right",
    "enter", "esc", "escape",
}

AGE_BUCKETS = [  # (max age in days, novelty)
    (14, 1.00),
    (60, 0.70),
    (180, 0.45),
    (10**9, 0.20),
]

TIER_BIG, TIER_SMALL = 0.50, 0.25


def mode_factor(mode: str) -> float:
    factors = []
    for tok in (t.strip() for t in mode.split(",")):
        if tok in FULL_MODES:
            factors.append(1.0)
        elif tok == "tmux":
            factors.append(0.05)
        elif tok in ZELLIJ_SUBMODES:
            factors.append(0.60)
        elif tok.startswith("all-except"):
            factors.append(0.85)
        else:
            factors.append(0.70)
    return max(factors)


ORIGIN_FACTOR = {"custom": 1.0, "plugin": 0.9, "default": 0.75}


def usefulness(hk: dict, dup_rank: int) -> float:
    u = CAT_WEIGHT.get(hk["category"], 0.6)
    u *= mode_factor(hk["mode"])
    u *= ORIGIN_FACTOR.get(hk["origin"], 0.8)
    if "UNVERIFIED" in hk.get("notes", ""):
        u *= 0.85
    if dup_rank > 0:  # same tool+action already covered by a cheaper chord
        u *= 0.70
    return round(u, 3)


SOURCE_RE = re.compile(r"([\w./-]+):(\d+)")


def blame_date(tool: str, source: str, cache: dict) -> str | None:
    """git blame the source line; returns ISO date or None."""
    m = SOURCE_RE.search(source)
    if not m:
        return None
    path, line = m.group(1), int(m.group(2))
    root = NVIM_ROOT if tool == "neovim" else CHEZMOI_ROOT
    if not (root / path).is_file():
        return None
    key = (tool, path, line)
    if key not in cache:
        try:
            out = subprocess.run(
                ["git", "-C", str(root), "blame", "-L", f"{line},{line}",
                 "--porcelain", "--", path],
                capture_output=True, text=True, check=True,
            ).stdout
            ts = None
            for ln in out.splitlines():
                if ln.startswith("committer-time "):
                    ts = int(ln.split()[1])
                    break
            cache[key] = date.fromtimestamp(ts).isoformat() if ts else None
        except subprocess.CalledProcessError:
            cache[key] = None
    return cache[key]


def tool_birth(tool: str, config_sources: list, cache: dict) -> str | None:
    """First-commit date of the tool's primary config (fallback age)."""
    if tool in cache:
        return cache[tool]
    if tool == "neovim":
        cmd = ["git", "-C", str(NVIM_ROOT), "log", "--reverse",
               "--format=%ad", "--date=short"]
    else:
        primary = next((s for s in config_sources
                        if (CHEZMOI_ROOT / s).is_file()), None)
        if primary is None:
            cache[tool] = None
            return None
        cmd = ["git", "-C", str(CHEZMOI_ROOT), "log", "--follow",
               "--format=%ad", "--date=short", "--", primary]
    try:
        lines = subprocess.run(cmd, capture_output=True, text=True,
                               check=True).stdout.splitlines()
        cache[tool] = lines[-1] if lines else None
    except subprocess.CalledProcessError:
        cache[tool] = None
    return cache[tool]


def age_novelty(iso: str | None) -> float:
    if iso is None:
        return 0.5  # unknown age
    days = (date.today() - datetime.strptime(iso, "%Y-%m-%d").date()).days
    for max_days, nov in AGE_BUCKETS:
        if days <= max_days:
            return nov
    return 0.2


NON_LETTER_KEYS = {
    "up", "down", "left", "right", "enter", "return", "tab", "esc",
    "escape", "space", "home", "end", "pgup", "pgdn", "pageup", "pagedown",
    "backspace", "del", "delete", "cmd", "ctrl", "alt", "shift", "option",
}


def _final_letter(keys_raw: str) -> str | None:
    tok = keys_raw.split("+")[-1].strip().lower()
    if tok.startswith("<") and tok.endswith(">"):  # <c-h> -> h
        tok = tok[1:-1].split("-")[-1]
    elif ">" in tok:  # <leader>sf -> sf
        tok = tok.split(">")[-1]
    if tok in NON_LETTER_KEYS or not tok.isalpha():
        return None
    return tok[-1]


def mnemonic_match(keys_raw: str, action: str) -> bool:
    last = _final_letter(keys_raw)
    if last is None:
        return False
    return any(w.startswith(last) for w in re.findall(r"[a-z]+", action.lower()))


def novelty_auto(hk: dict, line_date: str | None) -> float:
    n = age_novelty(line_date)
    if hk["keys_raw"].lower() in CONVENTIONS:
        n = min(n, 0.10)
    elif mnemonic_match(hk["keys_raw"], hk["action"]):
        n *= 0.60
    return round(n, 3)


def effective_novelty(scoring: dict) -> float:
    if scoring.get("known") is True:
        return 0.15
    if scoring.get("known") is False:
        return 1.0
    return scoring["novelty_auto"]


def finalize(scoring: dict) -> None:
    """Recompute score + tier from usefulness/novelty/known. Shared with quiz.py."""
    scoring["score"] = round(scoring["usefulness"] * effective_novelty(scoring), 3)
    scoring["tier"] = (1 if scoring["score"] >= TIER_BIG
                       else 2 if scoring["score"] >= TIER_SMALL else 3)


def load(tool: str) -> dict:
    return json.loads((DATA_DIR / f"{tool}.json").read_text())


def save(tool: str, data: dict) -> None:
    (DATA_DIR / f"{tool}.json").write_text(
        json.dumps(data, indent=2, ensure_ascii=False) + "\n")


def score_tool(tool: str, blame_cache: dict, birth_cache: dict) -> dict:
    data = load(tool)
    hotkeys = data["hotkeys"]

    # Duplicate ranking: the most reachable binding per action keeps full
    # weight; other chords for the same action are penalized.
    by_action: dict[str, list] = {}
    for hk in hotkeys:
        by_action.setdefault(hk["action"].lower(), []).append(hk)
    dup_rank = {}
    for group in by_action.values():
        group.sort(key=lambda h: (-usefulness(h, 0), len(h["keys_raw"])))
        for i, hk in enumerate(group):
            dup_rank[id(hk)] = i

    for hk in hotkeys:
        prev = hk.get("scoring", {})
        line_date = blame_date(tool, hk["source"], blame_cache)
        if line_date is None:
            line_date = tool_birth(tool, data.get("config_sources", []),
                                   birth_cache)
        scoring = {
            "usefulness": usefulness(hk, dup_rank[id(hk)]),
            "novelty_auto": novelty_auto(hk, line_date),
            "line_date": line_date,
            "known": prev.get("known"),
        }
        finalize(scoring)
        hk["scoring"] = scoring
    save(tool, data)
    return data


def main() -> None:
    blame_cache: dict = {}
    birth_cache: dict = {}
    ranked = []
    print(f"{'tool':<10} {'keys':>5} {'tier1':>6} {'tier2':>6} {'tier3':>6}")
    for tool in TOOLS:
        data = score_tool(tool, blame_cache, birth_cache)
        tiers = [h["scoring"]["tier"] for h in data["hotkeys"]]
        print(f"{tool:<10} {len(tiers):>5} {tiers.count(1):>6} "
              f"{tiers.count(2):>6} {tiers.count(3):>6}")
        for hk in data["hotkeys"]:
            ranked.append({
                "tool": tool,
                "keys": hk["keys"],
                "keys_raw": hk["keys_raw"],
                "action": hk["action"],
                "category": hk["category"],
                "mode": hk["mode"],
                "source": hk["source"],
                **hk["scoring"],
            })
    ranked.sort(key=lambda r: -r["score"])
    (DATA_DIR / "ranked.json").write_text(
        json.dumps(ranked, indent=2, ensure_ascii=False) + "\n")

    quizzed = sum(1 for r in ranked if r["known"] is not None)
    print(f"\nranked.json written ({len(ranked)} entries, {quizzed} quizzed)")
    print("\nTop 10 (print-worthy):")
    for r in ranked[:10]:
        print(f"  {r['score']:.2f}  {r['tool']:<9} {r['keys']:<14} {r['action']}")
    print("\nBottom 5 (omitted):")
    for r in ranked[-5:]:
        print(f"  {r['score']:.2f}  {r['tool']:<9} {r['keys']:<14} {r['action']}")


if __name__ == "__main__":
    sys.exit(main())
