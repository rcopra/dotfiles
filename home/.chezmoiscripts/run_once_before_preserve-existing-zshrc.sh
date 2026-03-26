#!/bin/bash
# Preserve existing PATH and environment variables before chezmoi replaces .zshrc
# This script runs ONCE per machine, before any files are applied.

set -e

ZSHRC="$HOME/.zshrc"
ZSHRC_LOCAL="$HOME/.zshrc.local"

# Skip if no existing .zshrc
if [[ ! -f "$ZSHRC" ]]; then
    echo "No existing .zshrc found, skipping preservation"
    exit 0
fi

# Skip if .zshrc.local already exists (don't overwrite user customizations)
if [[ -f "$ZSHRC_LOCAL" ]]; then
    echo ".zshrc.local already exists, skipping preservation"
    exit 0
fi

# Check if .zshrc is already chezmoi-managed (has our marker comment)
if grep -q "chezmoi" "$ZSHRC" 2>/dev/null || grep -q "Zinit Plugin Manager" "$ZSHRC" 2>/dev/null; then
    echo ".zshrc appears to already be chezmoi-managed, skipping preservation"
    exit 0
fi

echo "Extracting existing PATH and environment variables from .zshrc..."

# Create temp file for extracted content
EXTRACTED=$(mktemp)

# Extract export statements and PATH modifications
# Filter out common ones that will be in our managed config
grep -E '^export\s+' "$ZSHRC" 2>/dev/null | \
    grep -v -E '(LANG=|LC_ALL=|EDITOR=|BUNDLER_EDITOR=|HOMEBREW_|DISABLE_SPRING|OBJC_DISABLE|RUBYOPT=|PYENV_|PYTHON|NVM_DIR=|PATH=.*/opt/homebrew|PATH=.*\.rbenv|PATH=.*\.local/bin|PATH=.*node_modules)' \
    >> "$EXTRACTED" || true

# Also grab any PATH exports that might be machine-specific
grep -E '^export\s+PATH=' "$ZSHRC" 2>/dev/null | \
    grep -v -E '(/opt/homebrew|\.rbenv|\.local/bin|node_modules|\.pyenv|linuxbrew)' \
    >> "$EXTRACTED" || true

# Get any source commands for local files (but not common plugin managers)
grep -E '^\s*(source|\.) ' "$ZSHRC" 2>/dev/null | \
    grep -v -E '(zinit|oh-my-zsh|\.aliases|nvm\.sh|bash_completion|zshrc\.local)' \
    >> "$EXTRACTED" || true

# Check if we found anything worth saving
if [[ ! -s "$EXTRACTED" ]]; then
    echo "No machine-specific config found to preserve"
    rm -f "$EXTRACTED"
    exit 0
fi

# Remove duplicates and create .zshrc.local
sort -u "$EXTRACTED" > "$ZSHRC_LOCAL.tmp"

# Add header and write final file
cat > "$ZSHRC_LOCAL" << 'HEADER'
# Machine-specific shell configuration
# Preserved from existing .zshrc by chezmoi on first run
# Add any local PATH additions, secrets, or machine-specific config here
# This file is NOT tracked by chezmoi

HEADER

cat "$ZSHRC_LOCAL.tmp" >> "$ZSHRC_LOCAL"

rm -f "$EXTRACTED" "$ZSHRC_LOCAL.tmp"

echo "Preserved existing config to $ZSHRC_LOCAL"
echo "Contents:"
cat "$ZSHRC_LOCAL"
