#!/usr/bin/env python3
"""Recall quiz over the hotkey inventory.

Shows the action, you recall the chord, then self-grade. Results land in
each data/<tool>.json as scoring.known and feed the cheatsheet ranking:
known keys drop out, unknown keys get promoted.

Run score.py first. Resumable: already-quizzed entries are skipped.
Keys: Enter = reveal, y = knew it, n = didn't, u = undo last, q = quit.
"""

import random
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from score import TOOLS, finalize, load, save  # noqa: E402

MIN_USEFULNESS = 0.4


def main() -> None:
    datasets = {tool: load(tool) for tool in TOOLS}
    cards = []
    for tool, data in datasets.items():
        for hk in data["hotkeys"]:
            s = hk.get("scoring")
            if s is None:
                print("No scoring data — run score.py first.")
                return 1
            if s["known"] is None and s["usefulness"] >= MIN_USEFULNESS:
                cards.append((tool, hk))
    if not cards:
        print("Nothing left to quiz.")
        return 0
    random.shuffle(cards)

    print(f"{len(cards)} cards. Recall the chord, Enter to reveal.")
    print("Then: y = knew it, n = didn't, u = undo last, q = quit.\n")

    undo_stack = []
    answered = 0
    i = 0
    while i < len(cards):
        tool, hk = cards[i]
        print(f"[{i + 1}/{len(cards)}] {tool} | {hk['mode']} | {hk['category']}")
        print(f"    {hk['action']}")
        try:
            input("    ... ")
        except (EOFError, KeyboardInterrupt):
            break
        print(f"    => {hk['keys']}   ({hk['keys_raw']})")
        while True:
            try:
                ans = input("    knew it? [y/n/u/q] ").strip().lower()
            except (EOFError, KeyboardInterrupt):
                ans = "q"
            if ans == "q":
                print(f"\n{answered} answered this session. Progress saved.")
                return 0
            if ans == "u" and undo_stack:
                j, (utool, uhk) = undo_stack.pop()
                uhk["scoring"]["known"] = None
                finalize(uhk["scoring"])
                save(utool, datasets[utool])
                answered -= 1
                i = j  # revisit the undone card
                print(f"    undone: {uhk['keys']} ({uhk['action']})\n")
                break
            if ans in ("y", "n"):
                hk["scoring"]["known"] = ans == "y"
                finalize(hk["scoring"])
                save(tool, datasets[tool])
                undo_stack.append((i, (tool, hk)))
                answered += 1
                i += 1
                print()
                break
    print(f"\nDone: {answered} answered this session.")
    print("Re-run score.py to regenerate ranked.json with quiz results.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
