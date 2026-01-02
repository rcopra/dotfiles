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

## Architecture

- **External repos** (`.chezmoiexternal.toml`): nvim config and TPM are cloned as external git repos
- **Platform conditionals** (`.chezmoiignore`): macOS-only files (aerospace, karabiner, VS Code settings) are ignored on Linux; GUI apps are ignored on "server" machines
- **Package installation** (`run_onchange_install-packages.sh.tmpl`): Installs Homebrew packages on macOS, apt/pacman packages on Linux
- **Version managers**: rbenv, pyenv, nvm are installed and configured in zshrc
