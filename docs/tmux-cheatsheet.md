# Tmux Cheat Sheet

## Prefix Key
**Prefix: `Ctrl-a`** (custom, not default `Ctrl-b`)

---

## Session Management

### Session Switcher (tmux-sessionizer)
| Keybind | Action |
|---------|--------|
| `Ctrl-a f` | **Fuzzy search** all projects in ~/work and ~/personal |
| `Ctrl-a Ctrl-d` | **Quick jump** to dotfiles (~/.local/share/chezmoi) |
| `Ctrl-a Ctrl-w` | **Quick jump** to ~/work |
| `Ctrl-a Ctrl-p` | **Quick jump** to ~/personal |

### Session Commands
| Keybind | Action |
|---------|--------|
| `Ctrl-a d` | Detach from current session |
| `Ctrl-a s` | **Interactive session switcher** (tree view) |
| `Ctrl-a $` | Rename current session |

From shell:
```bash
tmux ls                    # List all sessions
tmux attach -t <name>      # Attach to session
tmux kill-session -t <name> # Kill session
```

---

## Window Management

| Keybind | Action |
|---------|--------|
| `Ctrl-a c` | Create new window |
| `Ctrl-a w` | **Window list** (interactive, most useful!) |
| `Ctrl-a n` | Next window |
| `Ctrl-a p` | Previous window |
| `Ctrl-a 0-9` | Jump to window number |
| `Ctrl-a ,` | Rename current window |
| `Ctrl-a &` | Kill current window |

---

## Pane Management

### Creating Panes
| Keybind | Action |
|---------|--------|
| `Ctrl-a \|` | Split vertically (left/right) |
| `Ctrl-a -` | Split horizontally (top/bottom) |

### Navigating Panes
| Keybind | Action |
|---------|--------|
| `Ctrl-Left/Right/Up/Down` | **Navigate panes** (NO PREFIX!) |
| `Ctrl-a o` | Cycle through panes |
| `Ctrl-a ;` | Toggle to last active pane |
| `Ctrl-a m` | **Zoom current pane** (fullscreen toggle) |
| `Ctrl-a x` | Kill current pane |

### Resizing Panes
| Keybind | Action |
|---------|--------|
| `Ctrl-a Up` | Resize up (5 lines) |
| `Ctrl-a Down` | Resize down (5 lines) |
| `Ctrl-a Left` | Resize left (5 columns) |
| `Ctrl-a Right` | Resize right (5 columns) |

*Hold down arrow keys to repeat resize*

---

## Copy Mode (Vi-style)

| Keybind | Action |
|---------|--------|
| `Ctrl-a [` | Enter copy mode |
| `v` | Start selection (in copy mode) |
| `y` | Copy selection to system clipboard |
| `Ctrl-a p` | Paste from system clipboard |
| `q` | Exit copy mode |

Navigation in copy mode: `h/j/k/l`, `/` to search, `n/N` for next/prev

---

## Miscellaneous

| Keybind | Action |
|---------|--------|
| `Ctrl-a r` | **Reload tmux config** |
| `Ctrl-a ?` | List all keybindings |
| `Ctrl-a :` | Enter command mode |

---

## Workflow Tips

### Recommended Hybrid Approach
- **Windows** for different contexts (editor, server, git)
- **Nvim splits** for editing multiple files
- **Tmux panes** only when you need to see editor + running process simultaneously

### Example Layout
```
Window 0: editor    → nvim with splits for multiple files
Window 1: server    → npm run dev (or split with test runner)
Window 2: git       → git commands, general shell
```

### Quick Session Jump
1. `Ctrl-a f` to fuzzy find your project
2. Creates session if doesn't exist, switches if it does
3. All sessions auto-save every 15 minutes (tmux-resurrect)
4. Sessions restore after reboot

---

## Plugins Installed

- **vim-tmux-navigator**: Seamless navigation between vim/nvim and tmux panes
- **tmux-resurrect**: Persist sessions after restart
- **tmux-continuum**: Auto-save sessions every 15 minutes
- **tmux-kanagawa**: Theme

---

## Common Workflow

```bash
# Start working on blog
Ctrl-a f               # Opens fzf
# Type "blog", press Enter
# → Creates session if needed, switches to it

# Inside session
nvim .                 # Edit in window 0
Ctrl-a c               # Create window 1
npm run dev            # Start dev server

# Switch between them
Ctrl-a 0               # Jump to editor
Ctrl-a 1               # Check server logs

# Jump to different project
Ctrl-a f               # Fuzzy find again
# Select different project
```
