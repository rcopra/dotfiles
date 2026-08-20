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
    fzf \
    eza \
    zoxide \
    ripgrep \
    fd \
    bat \
    jq \
    direnv \
    rainfrog \
    bun

# bun runs the dan.pane-topic-sync Herdr plugin's event commands.

echo "==> Installing zsh plugins..."
brew install \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    zsh-history-substring-search \
    forgit \
    powerlevel10k

echo "==> Installing version managers..."
# mise: ruby + node (reads .ruby-version/.nvmrc/.node-version); uv: python
brew install mise uv

echo "==> Installing applications..."
# NOTE: Ghostty is installed manually (direct .app), not via brew
# NOTE: Herdr (terminal multiplexer, replaced Zellij) is installed by
# run_onchange_after_install-herdr.sh — it ships its own updater and installs to
# ~/.local/bin, which precedes Homebrew on PATH.
# OmniWM (tiling WM) from its author's tap
brew install --cask barutsrb/tap/omniwm
# Karabiner: caps->Hyper-3 + option-lazy, built-in keyboard only — must ignore
# the ZMK dongle (it reorders ZMK mod-morph HID reports). Installer needs sudo.
brew install --cask karabiner-elements
# Hammerspoon: hyper app launchers + OmniWM workspace move-follow (~/.hammerspoon)
brew install --cask hammerspoon

echo "==> Installing fonts..."
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-symbols-only-nerd-font

echo "==> Package installation complete!"
