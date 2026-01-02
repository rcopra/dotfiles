# Omarchy Notes (Arch Linux)

Omarchy source: https://github.com/basecamp/omarchy

## Current State

Using default Omarchy config with planned modifications below.

## Default Omarchy Components

- **Window Manager**: Hyprland (Wayland compositor with dwindle tiling)
- **Terminal**: Ghostty
- **Shell**: Zsh with omarchy customizations
- **Bar**: Waybar
- **Launcher**: Walker

## Modifier Migration: SUPER → ALT

To match macOS Aerospace config, migrate Hyprland from SUPER to ALT as primary modifier.

### File to Edit
`~/.config/hypr/bindings.conf`

### Complete Binding Changes

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
# Default Hyprland behavior - movetoworkspace follows
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
# movetoworkspacesilent does NOT follow
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
bind = ALT, grave, workspace, previous  # Back-and-forth (backtick)

# --- Close Window ---
bind = ALT, W, killactive

# --- Toggle Floating ---
bind = ALT, T, togglefloating

# --- Fullscreen ---
bind = ALT, F, fullscreen

# --- Toggle Split ---
bind = ALT, J, togglesplit

# --- Terminal ---
bind = ALT, Return, exec, ghostty

# --- App Launcher ---
bind = ALT, Space, exec, walker

# --- Monitor Navigation (match macOS) ---
bind = ALT, M, focusmonitor, +1
bind = ALT SHIFT, M, movewindow, mon:+1
bind = ALT CTRL, M, movecurrentworkspacetomonitor, +1
```

### Unbind Default SUPER Bindings

You may need to unbind the default SUPER bindings first:
```conf
# Add to top of bindings.conf
unbind = SUPER, 1
unbind = SUPER, 2
# ... etc for all SUPER bindings you want to replace
```

### Alternative: Source Order Fix

Per [Issue #685](https://github.com/basecamp/omarchy/issues/685), if your bindings aren't taking effect, check that your user config is sourced AFTER omarchy defaults in `~/.config/hypr/hyprland.conf`.

## Cross-Platform Parity Summary

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
| Close window | (via service mode) | `ALT + W` |
| Monitor focus | `Alt + M` | `ALT + M` |
| Move to monitor | `Alt + Shift + M` | `ALT + SHIFT + M` |
