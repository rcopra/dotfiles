# Keybinds — Zellij + OmniWM

`⌃` Ctrl · `⌥` Alt/Option · `⇧` Shift · `⌘` Cmd · **Caps = ⌃⌥⌘**
Sequences read left → right: `⌃g ⌃p f` = Ctrl+g, then Ctrl+p, then f.

## Zellij

Every `⌥` bind below works in **any mode**, locked included — they live in the
config's `shared` block. `F1` toggles a live tooltip of the real binds in-terminal.

### Panes
| Action | Keys |
|---|---|
| Focus pane | `⌥ ←↓↑→` |
| New pane | `⌥n` |
| New right | `⌥⇧r` |
| New below | `⌥⇧d` |
| Close pane | `⌥w` |
| **Fullscreen** | `⌥z` |
| Floating panes | `⌥⇧f` |
| Float ⇄ embed this pane | `⌥⇧e` |
| Resize ± | `⌥- ⌥=` |
| Rename pane | `⌃g ⌃p c` |

### Tabs
| Action | Keys |
|---|---|
| Go to tab | `⌥ 1-9` |
| Prev / next tab | `⌥⇧ ← →` |
| New tab | `⌥t` |
| **Rename tab** | `⌥⇧t` |
| Move tab | `⌥i ⌥o` |
| Close tab | `⌃g ⌃t x` |
| Last tab | `⌃g ⌃t ⇥` |
| Pane → own tab | `⌃g ⌃t b` |

Close pane (`⌥w`) closes the tab too when it's the tab's last pane — that's the
everyday path. `⌃g ⌃t x` is only for nuking a multi-pane tab in one shot.

### Sessions
| Action | Keys |
|---|---|
| Session manager | `⌥s` |
| Sessionizer (new/switch) | `⌥⇧s` |
| **Detach** | `⌥q` |
| Sessionizer (shell prompt only) | `⌃f` |

### Scroll / scrollback
| Action | Keys |
|---|---|
| **Scroll mode** | `⌃s` then `j k d u` |
| Search scrollback | `⌃s s` → `n`/`p` |
| **Scrollback → nvim** | `⌥e` (or `⌃s e`) |
| Leave scroll mode | `⏎` or `esc` |

Mouse drag-select is capped to one viewport — zellij owns the scrollback, so
Ghostty's own buffer is empty. To copy across scrollback use `⌥e`, then `V`/`y`
in nvim. `⇧`+drag gives Ghostty-native selection of the visible screen.

### Precision resize
| Action | Keys |
|---|---|
| Resize mode | `⌃g ⌃n` then `←↓↑→` |
| Swap layout | `⌃g ⌥[ ⌥]` |

`⌃n` and `⌃o` are deliberately *not* bound in locked mode — they'd shadow nvim's
`<C-n>` and jumplist `<C-o>`. Same reason `⌥f`/`⌥d` are unused: zsh
`forward-word` / `kill-word`.

## OmniWM

### Workspaces
| Action | Keys |
|---|---|
| Go to workspace | `⌘ 1-9` |
| Send window to workspace | `⇧⌘ 1-9` |
| Last workspace | `Caps ⇥` |

### Windows — N E U I = ← ↓ ↑ → 
| Action | Keys |
|---|---|
| Focus | `Caps n e u i` |
| Move window | `⇧ Caps n e u i` |
| Last window | `` Caps ` `` |
| Column in / out | `Caps ← →` |
| Move column | `Caps [ ]` |
| Focus column | `⌃⌥ 1-9` |
| Next monitor | `Caps m` |

### Size / toggles
| Action | Keys |
|---|---|
| Fullscreen | `Caps f` |
| Cycle width | `Caps . ,` |
| Width ± 10% | `Caps - =` |
| Float window | `Caps v` |
| Overview | `Caps o` |
| Command palette | `⌃⌥ Space` |

## Launch
| Action | Keys |
|---|---|
| Ghostty | `⌥ ⏎` |
| Ghostty / Safari / Firefox / Slack / Discord | `Caps g w b s d` |
