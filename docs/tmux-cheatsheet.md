# tmux

Open a fresh Ghostty shell and run `tms` to pick a project. Each project gets a
session; windows hold tasks, and panes hold editors, shells, or agents. Detaching
keeps processes running. Sessions do not restore automatically after a reboot.

The prefix is **Ctrl+a**. Press it, release it, then press the listed key.

| Action | Shortcut |
| --- | --- |
| Project picker at the shell prompt | Ctrl+f or `tms` |
| Project picker inside tmux | Alt+Shift+s or prefix, f |
| Session/window picker | Alt+s or prefix, w |
| Session picker | prefix, s |
| Previous/next session | Cmd+Alt+Up/Down or Ctrl+Alt+Up/Down |
| New window | Alt+t or prefix, c |
| Rename window | Alt+Shift+t or prefix, comma |
| Previous/next window | Alt+Shift+Left/Right or prefix, p/n |
| Select window 1–9 | Alt+1–9 or prefix, 1–9 |
| Move window left/right | Alt+i/o |
| Split right | Cmd+d or prefix, \| |
| Split down | Cmd+Shift+d or prefix, - |
| Navigate panes and Neovim splits | Alt+arrows |
| Resize pane | prefix, arrows |
| Zoom/unzoom pane | Alt+z or prefix, m/z |
| Close pane (confirmation) | Alt+Shift+w or prefix, x |
| Join/send pane to another window | prefix, J/S |
| Swap windows using picker | prefix, W |
| Copy mode | prefix, [; v to select, y or Enter to copy |
| Detach | Alt+q or prefix, d/q |
| Reload tmux config | prefix, r |

Shell aliases: `tmd` opens dotfiles, `tmv` Neovim config, `tmw` the work root,
and `tmp` the personal root. The project picker lists immediate subdirectories
of `~/work` and `~/personal`, plus Neovim config and the chezmoi repo. Session
names include a short path hash to distinguish same-named projects; symlinked
paths reuse the same session.

Ghostty's Cmd split/session shortcuts send tmux key sequences, so use those
inside tmux. Reload Ghostty configuration with Cmd+Shift+comma after changing
its config. Alt+arrows use Neovim's separately managed `smart-splits.nvim`
configuration; tmux needs no plugin manager.
