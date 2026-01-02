# Aerospace Config (macOS)

Aerospace docs: https://nikitabobko.github.io/AeroSpace/guide

## Overview

Aerospace is a tiling window manager for macOS using **Alt as primary modifier** to match Omarchy/Hyprland.

Config file: `~/.aerospace.toml` (managed via chezmoi as `dot_aerospace.toml`)

## Karabiner Integration

Karabiner is configured to make both Option (Alt) keys "pure modifiers" - they no longer produce special characters (é, ñ, etc.). Special characters are handled via ZMK keyboard leader key.

## Current Keybindings

### Window Focus
| Shortcut | Action |
|----------|--------|
| `Alt + arrows` | Focus window in direction |

### Window Movement
| Shortcut | Action |
|----------|--------|
| `Alt + Shift + arrows` | Move/swap window in direction |

### Workspaces
| Shortcut | Action |
|----------|--------|
| `Alt + 1-9` | Switch to workspace |
| `Alt + Shift + 1-9` | Move window to workspace AND follow |
| `Alt + Shift + Cmd + 1-9` | Move window silently (no follow) |
| `Alt + Backtick` | Toggle previous workspace |

### Window Cycling
| Shortcut | Action |
|----------|--------|
| `Alt + Tab` | Next window in workspace |
| `Alt + Shift + Tab` | Previous window in workspace |

### Monitor Navigation
| Shortcut | Action |
|----------|--------|
| `Alt + M` | Focus next monitor |
| `Alt + Shift + M` | Move window to next monitor |
| `Alt + Ctrl + M` | Move workspace to next monitor |

### App Launchers
| Shortcut | Action |
|----------|--------|
| `Alt + Enter` | WezTerm |
| `Alt + Shift + B` | Firefox (new window) |
| `Alt + Ctrl + B` | Firefox (private window) |
| `Alt + Shift + F` | Finder |
| `Alt + Shift + G` | Discord |
| `Alt + Shift + O` | Obsidian |
| `Alt + Shift + S` | Slack |

### Layout Controls
| Shortcut | Action |
|----------|--------|
| `Cmd + /` | Toggle tiles horizontal/vertical |
| `Cmd + ,` | Toggle accordion horizontal/vertical |
| `Cmd + -` | Resize smaller |
| `Cmd + =` | Resize larger |

### Service Mode
Enter with `Cmd + Shift + ;`

| Shortcut | Action |
|----------|--------|
| `Esc` | Reload config & exit |
| `R` | Reset/flatten workspace layout |
| `F` | Toggle floating/tiling |
| `Backspace` | Close all windows but current |
| `Alt + Shift + H/J/K/L` | Join window with direction |

## Workspace Layout

```
Main Monitor (1-5):
├── 1: Terminal / Development
├── 2: Browser
├── 3: Code editor
├── 4: Docs / Reference
└── 5: Misc

Secondary Monitor (6-9):
├── 6: Communication (Slack/Discord)
├── 7: Music / Media
├── 8: Notes (Obsidian)
└── 9: Misc
```

## Visual Settings

- **Gaps**: 5px inner and outer (matches Hyprland)
- **Layout**: Tiles (binary split, auto orientation)
- **Mouse**: Follows focus on monitor change

## Cross-Platform Parity with Omarchy

| Action | macOS (Aerospace) | Omarchy (Hyprland) |
|--------|-------------------|---------------------|
| Focus window | `Alt + arrows` | `ALT + arrows` |
| Move window | `Alt + Shift + arrows` | `ALT + SHIFT + arrows` |
| Switch workspace | `Alt + 1-9` | `ALT + 1-9` |
| Move + follow | `Alt + Shift + 1-9` | `ALT + SHIFT + 1-9` |
| Move silent | `Alt + Shift + Cmd + 1-9` | `ALT + SHIFT + CTRL + 1-9` |
| Window cycle | `Alt + Tab` | `ALT + TAB` |
| Back-and-forth | `Alt + Backtick` | `ALT + grave` |
| Terminal | `Alt + Enter` | `ALT + Return` |
| Monitor focus | `Alt + M` | (configure in Hyprland) |

## Firefox Launcher Note

Firefox is launched via CLI (`/Applications/Firefox.app/Contents/MacOS/firefox --new-window`) instead of `open -na` to ensure new windows open in the current workspace rather than grouping with existing Firefox windows.
