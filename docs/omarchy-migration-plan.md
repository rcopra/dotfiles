# Omarchy Migration Plan

**Goal**: Migrate Hyprland from SUPER to ALT as primary modifier to match macOS Aerospace config.

---

## Pre-Migration Checklist

- [ ] Backup current bindings: `cp ~/.config/hypr/bindings.conf ~/.config/hypr/bindings.conf.bak`
- [ ] Note any custom bindings you've already added
- [ ] Have a TTY fallback ready (Ctrl+Alt+F2) in case keybindings break

---

## File to Edit

```
~/.config/hypr/bindings.conf
```

**Important**: Per [Issue #685](https://github.com/basecamp/omarchy/issues/685), ensure your user config is sourced AFTER omarchy defaults in `~/.config/hypr/hyprland.conf`. Otherwise your bindings may be overwritten.

---

## Complete Bindings Configuration

Copy this entire block to your `bindings.conf`:

```conf
# =============================================================================
# ALT as Primary Modifier (matches macOS Aerospace)
# =============================================================================

# --- Window Focus (ALT + arrows) ---
bind = ALT, left, movefocus, l
bind = ALT, right, movefocus, r
bind = ALT, up, movefocus, u
bind = ALT, down, movefocus, d

# --- Move/Swap Window (ALT + SHIFT + arrows) ---
bind = ALT SHIFT, left, swapwindow, l
bind = ALT SHIFT, right, swapwindow, r
bind = ALT SHIFT, up, swapwindow, u
bind = ALT SHIFT, down, swapwindow, d

# --- Workspace Switching (ALT + number) ---
bind = ALT, 1, workspace, 1
bind = ALT, 2, workspace, 2
bind = ALT, 3, workspace, 3
bind = ALT, 4, workspace, 4
bind = ALT, 5, workspace, 5
bind = ALT, 6, workspace, 6
bind = ALT, 7, workspace, 7
bind = ALT, 8, workspace, 8
bind = ALT, 9, workspace, 9
bind = ALT, 0, workspace, 10

# --- Move to Workspace AND Follow (ALT + SHIFT + number) ---
bind = ALT SHIFT, 1, movetoworkspace, 1
bind = ALT SHIFT, 2, movetoworkspace, 2
bind = ALT SHIFT, 3, movetoworkspace, 3
bind = ALT SHIFT, 4, movetoworkspace, 4
bind = ALT SHIFT, 5, movetoworkspace, 5
bind = ALT SHIFT, 6, movetoworkspace, 6
bind = ALT SHIFT, 7, movetoworkspace, 7
bind = ALT SHIFT, 8, movetoworkspace, 8
bind = ALT SHIFT, 9, movetoworkspace, 9
bind = ALT SHIFT, 0, movetoworkspace, 10

# --- Move to Workspace Silently (ALT + SHIFT + CTRL + number) ---
bind = ALT SHIFT CTRL, 1, movetoworkspacesilent, 1
bind = ALT SHIFT CTRL, 2, movetoworkspacesilent, 2
bind = ALT SHIFT CTRL, 3, movetoworkspacesilent, 3
bind = ALT SHIFT CTRL, 4, movetoworkspacesilent, 4
bind = ALT SHIFT CTRL, 5, movetoworkspacesilent, 5
bind = ALT SHIFT CTRL, 6, movetoworkspacesilent, 6
bind = ALT SHIFT CTRL, 7, movetoworkspacesilent, 7
bind = ALT SHIFT CTRL, 8, movetoworkspacesilent, 8
bind = ALT SHIFT CTRL, 9, movetoworkspacesilent, 9
bind = ALT SHIFT CTRL, 0, movetoworkspacesilent, 10

# --- Window Cycling & Workspace Navigation ---
bind = ALT, TAB, cyclenext
bind = ALT SHIFT, TAB, cyclenext, prev
bind = ALT, grave, workspace, previous

# --- Monitor Navigation ---
bind = ALT, M, focusmonitor, +1
bind = ALT SHIFT, M, movewindow, mon:+1
bind = ALT CTRL, M, movecurrentworkspacetomonitor, +1

# --- Window Actions ---
bind = ALT, W, killactive
bind = ALT, T, togglefloating
bind = ALT, F, fullscreen
bind = ALT, J, togglesplit

# --- Terminal ---
bind = ALT, Return, exec, ghostty

# --- App Launcher ---
bind = ALT, Space, exec, walker
```

---

## Unbinding Default SUPER Bindings

If you experience conflicts, add these unbinds at the TOP of your bindings.conf:

```conf
# Unbind default SUPER bindings
unbind = SUPER, 1
unbind = SUPER, 2
unbind = SUPER, 3
unbind = SUPER, 4
unbind = SUPER, 5
unbind = SUPER, 6
unbind = SUPER, 7
unbind = SUPER, 8
unbind = SUPER, 9
unbind = SUPER, 0
unbind = SUPER, left
unbind = SUPER, right
unbind = SUPER, up
unbind = SUPER, down
unbind = SUPER SHIFT, 1
unbind = SUPER SHIFT, 2
unbind = SUPER SHIFT, 3
unbind = SUPER SHIFT, 4
unbind = SUPER SHIFT, 5
unbind = SUPER SHIFT, 6
unbind = SUPER SHIFT, 7
unbind = SUPER SHIFT, 8
unbind = SUPER SHIFT, 9
unbind = SUPER SHIFT, 0
unbind = SUPER, W
unbind = SUPER, T
unbind = SUPER, F
unbind = SUPER, J
unbind = SUPER, Return
unbind = SUPER, Space
unbind = SUPER, TAB
```

---

## Post-Migration Checklist

- [ ] Save bindings.conf
- [ ] Reload Hyprland: `hyprctl reload`
- [ ] Test workspace switching: `Alt + 1-9`
- [ ] Test window focus: `Alt + arrows`
- [ ] Test window movement: `Alt + Shift + arrows`
- [ ] Test move-and-follow: `Alt + Shift + 1-9`
- [ ] Test terminal launch: `Alt + Enter`
- [ ] Test app launcher: `Alt + Space`
- [ ] Test window cycling: `Alt + Tab`

---

## Cross-Platform Parity Reference

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
| Close window | (service mode) | `ALT + W` |
| Monitor focus | `Alt + M` | `ALT + M` |
| Move to monitor | `Alt + Shift + M` | `ALT + SHIFT + M` |

---

## Troubleshooting

**Bindings not working?**
1. Check source order in `~/.config/hypr/hyprland.conf`
2. Your user config should be sourced LAST
3. Try adding explicit `unbind` statements

**Need to recover?**
```bash
cp ~/.config/hypr/bindings.conf.bak ~/.config/hypr/bindings.conf
hyprctl reload
```

**View current bindings:**
```bash
hyprctl binds
```

---

## Future: Managing via Chezmoi

Once stable, consider adding Hyprland config to chezmoi:
```bash
chezmoi add ~/.config/hypr/bindings.conf
```

Then use templates to handle any platform differences if needed.
