# OmniWM

**Role**: the window manager — Niri-style scrollable columns on macOS. Owns workspaces,
column layout, floating windows, monitors, overview. Config:
`home/dot_config/omniwm/settings.toml`, rewritten by OmniWM's own GUI (quit the app before
editing by hand, then `chezmoi re-add`).

## Column model

- `defaultLayoutType = "niri"`; all 9 workspaces are niri. `⌃⌥⌘ L` flips one to dwindle.
- A workspace is an infinite horizontal strip of **columns**, each holding a vertical stack
  of windows. `visibleContainerCount = 2`, `infiniteLoop = false`,
  `centerFocusedColumn = "never"`. Width presets 1/3, 1/2, 2/3; default 1/2.
- Keymap rule: **plain Hyper-3 acts on the column, +Shift acts on the window** — `⌃⌥⌘ -/=`
  resizes the column's width (`setContainerPrimarySpan`), `⌃⌥⌘⇧ -/=` the window's height
  (`setWindowSecondarySpan`).
- Workspaces 1-5 pinned to the main monitor, 6-9 to the secondary. Gaps 16px inner / 0
  outer, borders off, workspace bar overlapping the menu bar.

## Hotkey tier design

- **⌃⌥⌘ (Hyper-3)** — the WM tier, from Caps Lock via Karabiner or the D50 raised keys.
  Focus is `N/E/U/I`, not arrows: those are the ZMK NAV-layer arrow positions, so the
  mental map is identical on keyboard and laptop.
- **⌃⌥⌘⇧** — the literal token `Hyper` in the TOML (OmniWM defines `Hyper` as ⌃⌥⇧⌘;
  `systemHyperTrigger = "None"` here, so all four must be typed). The move variant:
  `Hyper+N/E/U/I` move window, `Hyper+-/=` window height, `Hyper+F` toggle full column
  width, `Hyper+B` balance, `Hyper+R` raise floats.
- **⌘1-9** workspaces. `⌘⇧1-9` hits OmniWM's `moveToWorkspace`; Karabiner expands that
  chord to `⌘⇧N` then `⌘N` so focus follows. `⌘⇧⌥1-9` passes through for a silent move.
- **⌃⌥** — a second tier absent from the printed cheatsheet: `⌃⌥1-9` focus column,
  `⌃⌥Home/End` column to first/last, `⌃⌥F` expand to free space, `⌃⌥R` reset height,
  `⌃⌥M` menu-anywhere, `⌃⌥␣` command palette (the laptop escape hatch).

## Quirks

- 80 of 149 action slots are `Unassigned` (all `preselect.*`, `resizeGrow/Shrink.*`,
  `moveColumnToIndex.*`, `focusWindowInColumn.*`, scratchpad). All 69 assigned are inventoried.
- `⌘1-9` shadows in-app tab switching (browsers, Slack) — the WM wins.
- Three F bindings: `⌃⌥⌘F` fullscreen, `⌃⌥⌘⇧F` **toggle** full column width, `⌃⌥F` one-way
  expand to free space. `⌃⌘\`` (last monitor) also sits beside `⌃⌥⌘\`` (previous window).
- Workspace-move exists twice: `⌘⇧1-9` and `⌃⌥⇧ ↑/↓` (plus `⌃⌥⇧ PgUp/PgDn` for columns).
  Vertical window-move too: `⌃⌥⌘⇧ U/E` (`move.up/down`) vs `⌃⌥⌘ ↑/↓` (`moveWindowUp/Down`)
  — OmniWM's docs don't explain the difference, so treat it as unverified.
- `⌃⌥⌘ ←/→` is one directional `consumeOrExpelWindow{Left,Right}` action, not a
  consume-key/expel-key pair; `consumeWindowIntoColumn`/`expelWindowFromColumn` are unbound.
- `quakeTerminal.enabled = false`, `toggleQuakeTerminal` unbound — replaced by `⌥⏎`
  launching a real Ghostty window via Karabiner.
- `ipcEnabled = false`, `followsMouse = false`, `lockModifier = "off"` — keyboard only.
