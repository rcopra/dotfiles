# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

macOS dotfiles managed with [chezmoi](https://chezmoi.io). Targets Apple Silicon Macs only — no templates, no cross-platform conditionals, no Linux/server support (headless Pis are managed by hand, not by this repo). Goal: both MacBooks (personal & work) behave identically.

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

## Core Stack

- **Terminal**: Ghostty (installed manually, not brew) — `dot_config/ghostty/config`
- **Multiplexer**: Zellij, locked-by-default mode — `dot_config/zellij/config.kdl`; Alt+arrow pane nav via vim-zellij-navigator wasm plugin (works in locked mode, forwards into nvim)
- **Window manager**: OmniWM (Niri-style columns) — `dot_config/omniwm/settings.toml`; all hotkeys on the Hyper-3 (⌃⌥⌘) tier, workspaces on ⌘1-9
- **Karabiner**: Caps→Hyper-3, app launchers, ⌘⇧ move+follow synthesis — `dot_config/karabiner/karabiner.json`
- **Editor**: Neovim — `~/.config/nvim` intentionally unmanaged (separate kickstart clone)
- **Prompt**: Starship gruvbox-rainbow preset

## Architecture

- **External files** (`home/.chezmoiexternal.toml`): vim-zellij-navigator wasm plugin
- **Package installation** (`home/.chezmoiscripts/run_onchange_install-packages.sh`): Homebrew-based, runs on content change
- **VS Code settings**: Symlinked from `~/Library/Application Support/Code/User/` to `home/vscode/` using relative paths
- **Version managers**: rbenv, pyenv, nvm are installed and configured in shell configs

## Machine Context

- **macOS**: Personal & work MacBooks (OmniWM, Karabiner)
- **Keyboard**: Hillside D50 (daily) + Temper, ZMK firmware ([zmk-config](https://github.com/rcopra/zmk-config)); Hyper-3 on raised keys

## Reference Docs

- `docs/keyboard-planning.md` — ZMK keymap design, WM modifier plan
- `docs/cheatsheets/` — printable Hyper-3 desk reference + `make-pdfs.sh` (headless Chrome → ~/Desktop PDFs)

## Gotchas

- **`~/.config/chezmoi/chezmoi.toml` is the live config** — edit directly with Edit tool, never use sed/Bash (sed has corrupted this file before)
- **Local drift resolution**: if chezmoi reports `has changed since chezmoi last wrote it` and you want to keep local changes, run `chezmoi re-add <path>` (example: `chezmoi re-add ~/.config/omniwm/settings.toml`)
- **OmniWM rewrites settings.toml from its GUI** — quit OmniWM before editing the file, relaunch after, then `chezmoi re-add`
- **Claude Code's Edit/Write tools strip powerline glyphs** (U+E0B0 , U+E0BC , etc.) — use Python to inject these characters, or use CLI tools (`starship preset`) that write them natively
- **Starship preset**: Use `starship preset gruvbox-rainbow -o ~/.config/starship.toml` as the base, then update the palette. Don't manually write the TOML — the CLI preserves glyphs correctly. After editing, `chezmoi re-add ~/.config/starship.toml`
