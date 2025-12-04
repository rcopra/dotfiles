# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository based on Le Wagon's setup, containing configuration files for:
- **Zsh shell** (oh-my-zsh with custom plugins)
- **VS Code** (settings and keybindings)
- **Git** (aliases and configuration)
- **Ruby** (IRB and Pry)
- **Python** (RSpec)
- **SSH** (macOS keychain integration)

## Installation and Setup

### Initial Setup
```bash
# Install dotfiles (symlinks config files to HOME directory)
./install.sh

# Configure git identity (prompts for name and email)
./git_setup.sh
```

The `install.sh` script:
- Backs up existing config files to `*.backup`
- Symlinks dotfiles to `~/.*` (aliases, gitconfig, irbrc, pryrc, rspec, zprofile, zshrc)
- Installs zsh plugins (zsh-autosuggestions, zsh-syntax-highlighting)
- Symlinks VS Code settings to the correct platform-specific location (macOS/Linux/WSL)
- Configures SSH keychain (macOS only)

## Repository Structure

### Core Configuration Files
- **zshrc**: Shell configuration with oh-my-zsh, version managers (rbenv, pyenv, nvm), and custom settings
- **gitconfig**: Git aliases (co, st, br, sweep, lg, m) and configuration
- **aliases**: Custom shell aliases (myip, speedtest, serve)
- **settings.json**: VS Code editor settings (2-space tabs, rulers at 80/120, Python/Ruby config)
- **keybindings.json**: VS Code keybindings (Ctrl+Tab for sequential tab cycling)
- **config**: SSH configuration with keychain integration
- **irbrc**: Ruby IRB configuration (launches Pry if available)
- **pryrc**: Pry prompt customization for Rails apps and standalone usage
- **rspec**: RSpec formatting options
- **zprofile**: Pyenv and Homebrew PATH setup

### Important Git Details
- Main branch: `master`
- Remotes: `origin` (user's fork), `upstream` (lewagon/dotfiles)
- Editor: VS Code (`code --wait`)

## Version Managers in Use

The zshrc configures multiple version managers:
- **rbenv**: Ruby version management
- **pyenv**: Python version management (default debugger: ipdb)
- **nvm**: Node.js version management (auto-switches with `.nvmrc` files)
- **asdf**: Additional shim support

## Key Custom Aliases

Git (from gitconfig):
- `sweep`: Clean merged branches and prune remote
- `m`: Checkout default branch
- `lg`: Pretty git log with graph
- `defaultBranch`: Get default branch name
- `remoteSetHead`: Set remotes/origin/HEAD

Shell (from aliases):
- `myip`: Show external IP via ipinfo.io
- `speedtest`: Run speedtest via curl
- `serve`: Start HTTP server on port 8000
- `stt`: Launch VS Code (replaces Sublime Text)

## Platform-Specific Behavior

macOS:
- VS Code settings path: `~/Library/Application Support/Code/User`
- SSH config with keychain integration enabled
- Homebrew analytics disabled

Linux/WSL:
- VS Code settings path: `~/.config/Code/User` or `~/.vscode-server/data/Machine`
- No SSH keychain integration
