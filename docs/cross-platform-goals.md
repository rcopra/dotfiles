# Cross-Platform Goals

Goal: Minimal context-switching friction between macOS, Omarchy, and headless Pis.

## Should Be Identical

<!-- Things that must work exactly the same everywhere -->
- Shell aliases and functions
- Git config
- Neovim setup
- Terminal colors/theme

## Should Be Similar

<!-- Things with platform-specific implementations but same mental model -->
- Window management shortcuts (Aerospace on macOS, ??? on Omarchy)
- Keyboard shortcuts (adapted for Cmd vs Super key)

## Platform-Specific

<!-- Things that are intentionally different per platform -->
- macOS: Karabiner for keyboard remapping
- Linux: (alternative if needed)
- Server: Minimal config, no GUI tools

## Keyboard Unification Strategy

<!--
How your ZMK keyboard config helps bridge platforms:
- Do you use a custom layer for OS-switching?
- Are certain shortcuts handled at keyboard level vs OS level?
-->

## Open Questions

<!-- Things you haven't decided yet -->
