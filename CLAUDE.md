# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

macOS dotfiles managed with [chezmoi](https://chezmoi.io). Targets Apple Silicon Macs only — no templates, no cross-platform conditionals.

## Chezmoi Commands

```bash
chezmoi apply              # Apply changes to home directory
chezmoi diff               # Preview what changes will be applied
chezmoi edit <file>        # Edit a managed file (e.g., chezmoi edit ~/.zshrc)
chezmoi cd                 # Jump to source directory
chezmoi update             # Pull latest and apply
```

After making changes in this repo:
```bash
chezmoi apply              # Test changes locally
```

## File Naming Conventions

Chezmoi uses special prefixes:
- `dot_` → `.` (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_` → 0600 permissions (e.g., `private_dot_ssh/`)
- `run_once_` → Script runs once per machine
- `run_onchange_` → Script re-runs when its content hash changes
- `symlink_` → Creates a symlink (target path is the file content)

No `.tmpl` files are used — all configs are static with hardcoded values.

## Theme

Gruvbox Material Mix (Hard) (`sainnhe/gruvbox-material`) is hardcoded across all tools. There is no centralized theme switching system — each tool uses either a built-in theme, plugin, or hardcoded hex values from the mix(hard) palette. To change themes, edit each config file individually.

## Architecture

- **External repos** (`home/.chezmoiexternal.toml`): only TPM is cloned as an external git repo
- **Neovim separation**: `~/.config/nvim` is intentionally unmanaged by chezmoi and is maintained as a separate kickstart clone
- **Package installation** (`home/.chezmoiscripts/run_onchange_install-packages.sh`): Homebrew-based, runs on content change
- **VS Code settings**: Symlinked from `~/Library/Application Support/Code/User/` to `home/vscode/` using relative paths
- **Version managers**: rbenv, pyenv, nvm are installed and configured in shell configs

## Machine Context

- **macOS**: Personal & work MacBooks (Aerospace WM, Karabiner)
- **Keyboard**: Custom split keyboard with ZMK firmware ([zmk-config](https://github.com/rcopra/zmk-config))

## Planning Config Changes

For detailed planning sessions (keyboard layouts, window management, cross-platform consistency), reference files in `docs/` are available:
- `docs/keyboard-planning.md` - ZMK keymap design, layer notes
- `docs/aerospace-config.md` - macOS window management
- `docs/omarchy-notes.md` - Arch/Omarchy customization
- `docs/cross-platform-goals.md` - What should be consistent

These are only loaded on-demand to save tokens. Ask Claude to read them when planning.

## Gotchas

- **`~/.config/chezmoi/chezmoi.toml` is the live config** — edit directly with Edit tool, never use sed/Bash (sed has corrupted this file before)
- **Local drift resolution**: if chezmoi reports `has changed since chezmoi last wrote it` and you want to keep local changes, run `chezmoi re-add <path>` (example: `chezmoi re-add ~/.config/opencode/opencode.json`)
- **Claude Code's Edit/Write tools strip powerline glyphs** (U+E0B0 , U+E0BC , etc.) — use Python to inject these characters, or use CLI tools (`starship preset`) that write them natively
- **Starship preset**: Use `starship preset gruvbox-rainbow -o ~/.config/starship.toml` as the base, then update the palette. Don't manually write the TOML — the CLI preserves glyphs correctly. After editing, `chezmoi re-add ~/.config/starship.toml`
- **tmux-gruvbox palette override**: The mix/hard palette lives at `~/.tmux/plugins/tmux-gruvbox/src/palette_gruvbox_dark.sh` — TPM updates will overwrite it
