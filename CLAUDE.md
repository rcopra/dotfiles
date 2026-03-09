# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io). Supports macOS (Apple Silicon), Debian/Ubuntu, and Arch Linux.

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
- `dot_` → `.` (e.g., `dot_zshrc.tmpl` → `~/.zshrc`)
- `.tmpl` suffix → Go template, processed with chezmoi data
- `private_` → 0600 permissions (e.g., `private_dot_ssh/`)
- `run_once_` → Script runs once per machine
- `run_onchange_` → Script re-runs when its content hash changes

## Template Variables

Defined in `.chezmoi.toml.tmpl` and available in all `.tmpl` files:
- `.chezmoi.os` - "darwin" or "linux"
- `.chezmoi.arch` - "amd64" or "arm64"
- `.email` - Git email (prompted during init)
- `.name` - Git name (prompted during init)
- `.machineType` - "personal", "work", or "server" (controls which files are installed)

## Theme

Gruvbox Material Mix (Hard) (`sainnhe/gruvbox-material`) is hardcoded across all tools. There is no centralized theme switching system — each tool uses either a built-in theme, plugin, or hardcoded hex values from the mix(hard) palette. To change themes, edit each config file individually.

## Architecture

- **External repos** (`.chezmoiexternal.toml`): nvim config and TPM are cloned as external git repos
  - Neovim config (`~/.config/nvim/`) is rcopra/kickstart.nvim — edit directly, commit separately with `git -C ~/.config/nvim`
  - `chezmoi apply` will overwrite nvim changes — do NOT use chezmoi for nvim edits
- **Platform conditionals** (`.chezmoiignore`): macOS-only files (aerospace, karabiner, VS Code settings) are ignored on Linux; GUI apps are ignored on "server" machines
- **Package installation** (`run_onchange_install-packages.sh.tmpl`): Installs Homebrew packages on macOS, apt/pacman packages on Linux
- **Version managers**: rbenv, pyenv, nvm are installed and configured in zshrc

## Machine Context

- **macOS**: Personal & work MacBooks (Aerospace WM, Karabiner)
- **Linux**: Omarchy (Arch) desktop, headless Pis (server machineType)
- **Keyboard**: Custom split keyboard with ZMK firmware ([zmk-config](https://github.com/rcopra/zmk-config))

Goal: Consistent experience across all devices with minimal context-switching friction.

## Planning Config Changes

For detailed planning sessions (keyboard layouts, window management, cross-platform consistency), reference files in `docs/` are available:
- `docs/keyboard-planning.md` - ZMK keymap design, layer notes
- `docs/aerospace-config.md` - macOS window management
- `docs/omarchy-notes.md` - Arch/Omarchy customization
- `docs/cross-platform-goals.md` - What should be consistent

These are only loaded on-demand to save tokens. Ask Claude to read them when planning.

## Gotchas

- **`~/.config/chezmoi/chezmoi.toml` is the live config** — edit directly with Edit tool, never use sed/Bash (sed has corrupted this file before)
- **Claude Code's Edit/Write tools strip powerline glyphs** (U+E0B0 , U+E0BC , etc.) — use Python to inject these characters, or use CLI tools (`starship preset`) that write them natively
- **Starship preset**: Use `starship preset gruvbox-rainbow -o ~/.config/starship.toml` as the base, then update the palette. Don't manually write the TOML — the CLI preserves glyphs correctly. After editing, `chezmoi re-add ~/.config/starship.toml`
- **tmux-gruvbox palette override**: The mix/hard palette lives at `~/.tmux/plugins/tmux-gruvbox/src/palette_gruvbox_dark.sh` — TPM updates will overwrite it
