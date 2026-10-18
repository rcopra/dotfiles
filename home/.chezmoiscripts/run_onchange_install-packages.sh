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

if ! command -v brew &>/dev/null; then
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
    direnv \
    rainfrog

echo "==> Installing zsh plugins..."
brew install \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    zsh-history-substring-search \
    forgit \
    powerlevel10k

echo "==> Installing language runtimes..."
# node@24: JS/TS runtime, keg-only LTS (PATH-wired in dot_zshrc); uv: python
brew install node@24 uv
# Clojure CLI and Leiningen for CIDER jack-in; clojure-lsp for Doom's (clojure +lsp)
brew install clojure leiningen clojure-lsp
# lein repl fails ("Permission denied ... ~/.lein/repl-port") when this is missing
mkdir -p "$HOME/.lein"

echo "==> Installing applications..."
# NOTE: Ghostty is installed manually (direct .app), not via brew
# OmniWM (tiling WM) from its author's tap
brew install --cask barutsrb/tap/omniwm
# Karabiner: caps->Hyper-3 + option-lazy, built-in keyboard only — must ignore
# the ZMK dongle (it reorders ZMK mod-morph HID reports). Installer needs sudo.
brew install --cask karabiner-elements
# Hammerspoon: hyper app launchers + OmniWM workspace move-follow (~/.hammerspoon)
brew install --cask hammerspoon
# Emacs for Doom (~/.config/doom); Homebrew 7 requires trusting third-party taps
brew tap d12frosted/emacs-plus
brew trust d12frosted/emacs-plus
brew install --cask emacs-plus-app

# Doom core is a plain clone (not chezmoi-managed); its modules are a submodule
if [[ ! -d "$HOME/.config/emacs" ]]; then
    echo "==> Installing Doom Emacs..."
    git clone --depth 1 --recurse-submodules --shallow-submodules \
        https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
    echo "==> After chezmoi applies ~/.config/doom, run: ~/.config/emacs/bin/doom install --no-config --no-env"
    # GUI Emacs doesn't inherit the shell PATH. Doom's envvar file fixes that; deny
    # secret-looking vars so they aren't copied into it (doom sync keeps the rules).
    echo "==> Then: doom env -d KEY -d TOKEN -d SECRET -d PASSWORD -d MCP_URL ~/.config/emacs/.local/etc/init.d/05-doom-env.load.el && doom sync"
fi

echo "==> Installing fonts..."
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-symbols-only-nerd-font

echo "==> Package installation complete!"
