# Keyboard Planning

ZMK config repo: https://github.com/rcopra/zmk-config (local: `~/personal/zmk-config/zmk-workspace`)

## Current Setup

- **Boards**: Hillside D50 (daily, 50 keys, raised pairs + 5-key thumb clusters per side), Temper + dongle (secondary, 36 keys). Shared `config/base.keymap` (urob-style, zmk-helpers macros only).
- **Base layout**: Colemak-DH, homerow mods (A/R/S/T = Ctrl/Alt/Cmd/Shift; N/E/I/O mirrored), 2 years stable — do not reshuffle.
- **Constraint (2026-07)**: thumb strain — reduce thumb reliance. 10 thumb keys on D50, only ~4 comfortable. No new thumb holds.

## Layer Design

- Layer 0: DEF (Colemak-DH + HRMs)
- Layer 1: GAME (qwerty-ish)
- Layer 2: NAV (hold Space) — arrows at N/U/E/I cluster, Cmd/Option nav holds, swappers
- Layer 3: FN (hold Return)
- Layer 4: NUM (right thumb, numword) — digits left hand: 7/8/9 top, 0/4/5/6 home, 1/2/3 bottom
- Layer 5: SYS (FN+NUM tri-layer)
- Layer 6: MOUSE
### WM modifier — DECIDED: Hyper-3 (2026-07-27)

WM tier = **⌃⌥⌘ ("Hyper-3")**, Shift excluded (Shift = move-variant modifier). Keyboard-independent by design:
- **Laptop**: Caps Lock → hold ⌃⌥⌘ / tap Escape (Karabiner rule)
- **Hillside D50**: outer key of BOTH raised pairs = plain `&kp LC(LA(LGUI))` — mirrored so either hand holds while the other taps; a modifier key, not a layer
- **Temper**: no dedicated key yet; A+R+S HRM hold produces the same chord
- **OmniWM** binds ⌃⌥⌘+letters; workspaces on ⌘1-9 (⌘⇧ move+follow, ⌘⇧⌥ silent — Karabiner synthesis)
- **Focus/move = ⌃⌥⌘+N/E/U/I (+Shift), NOT arrows** — arrows would need NAV-layer hold on ZMK (left raised + left thumb, bad ergo). N/E/U/I = the NAV cluster positions, so mental map identical; ZMK = raised + one right-hand tap, laptop = caps + home row

### WM layer — SHELVED (2026-07-27)

A firmware WM layer (emitting Ctrl+Alt+Cmd chords, trigger on D50 left raised key) was built, validated, then **reverted**: user frequently switches to the laptop's internal keyboard, so WM bindings must be plain hand-pressable chords that work keyboard-independently. Firmware layer may return later as an optional accelerator emitting the same chords — never as the foundation.

Surviving design facts if revisited:
- Meh (Ctrl+Alt+Shift) hold is emitted by `ldrsh` combo (R+S+T hold, combos.dtsi) — avoid as WM chord
- HRMs already produce any modifier chord today (e.g. A+R hold = Ctrl+Alt) — zero firmware change needed for chord-based WM bindings
- Sticky-layer one-shots don't compose with held-Shift variants (shift keypress consumes the one-shot)

## Laptop Fallback

- Laptop internal keyboard has no layers — Caps-hyper covers WM chords; anything else via OmniWM command palette (Ctrl+Option+Space).

## Planned Changes

- Temper hyper key (when Temper back in rotation; A+R+S HRM hold works meanwhile)
- Programming keys (`=`, `#` — combos tiresome): raised keys are plain hyper now; would need hold-tap (hold=hyper, tap=symbol). Not priority
- `TMUX_PRE` (`LH2` thumb + `F24`/upper-thumb slots, Ctrl+A) — fully dead now that tmux is removed from the stack; free keys for reassignment
- Thumb-cluster rethink (strain) — separate topic, on hold
