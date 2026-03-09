#!/bin/bash
# vim: set ft=bash:

set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
    echo "==> Skipping Zinit install on non-macOS"
    exit 0
fi

# Install Zinit if not present
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    echo "==> Installing Zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    echo "==> Zinit installed successfully"
else
    echo "==> Zinit already installed"
fi
