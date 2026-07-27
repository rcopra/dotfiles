#!/bin/bash
# vim: set ft=bash:

set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
    echo "==> Skipping macOS package installation (not macOS)"
    exit 0
fi

echo "==> Installing packages for macOS"

# ==============================================================================
# macOS Installation (Homebrew)
# ==============================================================================

if ! command -v brew &> /dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Installing CLI tools..."
brew install \
    git \
    zellij \
    fzf \
    eza \
    zoxide \
    ripgrep \
    fd \
    bat \
    jq \
    starship \
    direnv \
    rainfrog

echo "==> Installing version managers..."
brew install rbenv pyenv nvm

echo "==> Installing applications..."
# NOTE: Ghostty is installed manually (direct .app), not via brew
# OmniWM (tiling WM) from its author's tap
brew install --cask barutsrb/tap/omniwm
# Karabiner: caps->Hyper-3, app launchers, workspace move+follow (installer needs sudo)
brew install --cask karabiner-elements

echo "==> Installing fonts..."
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-symbols-only-nerd-font

echo "==> Package installation complete!"
