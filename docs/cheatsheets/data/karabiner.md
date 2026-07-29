# Karabiner-Elements

**Role:** the lowest layer of the keyboard stack. It manufactures the Hyper-3 (⌃⌥⌘) modifier every other
tool binds against, launches five apps, and rewrites ⌘⇧n into a two-event sequence OmniWM cannot express
on its own. Plumbing, not a feature the user thinks about.

Config: `home/dot_config/private_karabiner/karabiner.json` (28 hotkey entries); byte-identical to the
live `~/.config/karabiner/karabiner.json`.

## Structure

Single profile ("Default profile"), four `complex_modifications` rules, **no `simple_modifications`**:

1. **Caps Lock → Hyper-3 / Escape** — 1 manipulator, `to` = left_command + {control, option},
   `to_if_alone` = escape. The keystone: Caps is the only laptop-side source of ⌃⌥⌘.
2. **Workspace move synthesis** — 18 manipulators, two per digit 1-9: `⌘⇧n` → `⌘⇧n` then `⌘n`
   (move, then follow); `⌘⇧⌥n` → only `⌘⇧n` (move silently).
3. **App launchers** — 6 `shell_command` manipulators: ⌃⌥⌘ G/W/B/S/D for Ghostty / Safari / Firefox /
   Slack / Discord, plus ⌥⏎ for a new Ghostty window.
4. **Option keys as pure modifiers** — left/right Option self-remapped with `lazy: true`.

Not hotkeys: `disable_built_in_keyboard_if_exists` for vendor 7504 (0x1D50) / product 24926 (0x615E),
matched only when the device reports as *both* `is_keyboard` and `is_pointing_device`; plus
`keyboard_type_v2 = "ansi"`. Presumably the D50, but that ID pair appears nowhere in the repo —
unconfirmed.

## Quirks and conflicts

- **⌘⇧3/4/5 shadow macOS screenshots** system-wide — **intentional** (owner confirmed 2026-07-29:
  workspace move+follow is the desired behavior on those keys). ⌘⇧⌥n does not recover screenshots
  (it also emits ⌘⇧n); `run_onchange_after_darwin-defaults.sh:28-30` still configures screenshot
  output for other capture paths.
- **⌥⏎ sits in the "Hyper-3 app launchers" rule but isn't Hyper-3.** Plain Option+Return, *added* in
  5746f73 when the quake terminal was dropped — not a leftover. `mandatory: ["option"]` with no optional
  list means ⌃⌥⌘⏎ won't trigger it. The rule `description` lists only G/W/B/S/D, hiding it from skims.
- **`open -na` vs `open -a` is inconsistent.** ⌥⏎ (Ghostty) and ⌃⌥⌘B (Firefox) spawn *new instances*;
  G/W/S/D merely activate. Ghostty gets both a focus key and a new-window key; Firefox gets no
  focus-only key.
- **The `lazy` Option remap does less than its rule description claims.** Per the Karabiner docs `lazy`
  only withholds the modifier's own key event until another key joins it; it does not suppress the macOS
  layout's Option compositions, so Alt+h still yields `˙` and right-Option still types accents. Alt+arrow
  reaching Zellij/nvim is down to Ghostty's `macos-option-as-alt = true` and the `option+left/right=unbind`
  lines (`ghostty/config:5,11-12`). Cosmetic, not load-bearing.
- **Move+follow only exists here.** OmniWM's bindings (settings.toml:239-309) are just `Command+n` (focus)
  and `Shift+Command+n` (move); "follow" is emergent from Karabiner replaying two chords, so it silently
  breaks if Karabiner is off — and ⌘⇧⌥n exists purely to recover OmniWM's native move.
- Caps Lock's original toggle is unrecoverable; there is no escape-hatch rule.

## Design intent (per docs/keyboard-planning.md:22-31)

The WM tier is deliberately ⌃⌥⌘ with **Shift excluded**, reserving Shift as the "move variant" modifier,
and is keyboard-independent by design: Caps→Hyper on the laptop, plain `&kp LC(LA(LGUI))` on the outer key
of both D50 raised pairs, A+R+S homerow-mod hold on the Temper. A firmware WM layer was built and reverted
for exactly this reason — the user switches to the internal keyboard often, so WM bindings must be plain
hand-pressable chords. Karabiner is the laptop half of that contract and should stay minimal.
