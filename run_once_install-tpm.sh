#!/bin/bash
# vim: set ft=bash:

set -euo pipefail

# Install TPM if not present (also handled by .chezmoiexternal.toml, but this is a backup)
TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    echo "==> Installing TPM (Tmux Plugin Manager)..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "==> TPM installed. Run 'prefix + I' in tmux to install plugins."
else
    echo "==> TPM already installed"
fi
