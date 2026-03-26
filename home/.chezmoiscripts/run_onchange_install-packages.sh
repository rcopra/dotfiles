#!/bin/bash
# vim: set ft=bash:

set -euo pipefail

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
    tmux \
    fzf \
    eza \
    zoxide \
    ripgrep \
    fd \
    bat \
    jq \
    starship \
    tmux-mem-cpu-load \
    direnv \
    rainfrog

echo "==> Installing version managers..."
brew install rbenv pyenv nvm

echo "==> Installing applications..."
brew install --cask wezterm aerospace

echo "==> Installing fonts..."
brew install --cask font-jetbrains-mono-nerd-font

echo "==> Package installation complete!"
