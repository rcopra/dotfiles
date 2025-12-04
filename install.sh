#!/bin/zsh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🔧 Installing dotfiles from $DOTFILES_DIR"

# Define a function which renames a `target` file to `target.backup` if the file
# exists and if it's a 'real' file, ie not a symlink
backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinking $link -> $file"
    ln -s "$file" "$link"
  else
    echo "-----> $link already exists, skipping"
  fi
}

# Ensure directories exist
mkdir -p "$HOME/.config/karabiner"
mkdir -p "$HOME/.ssh"

# =====================
# Shell Configuration
# =====================
echo ""
echo "📦 Setting up shell configuration..."

for name in aliases gitconfig irbrc pryrc rspec zprofile zshrc; do
  target="$HOME/.$name"
  backup "$target"
  symlink "$DOTFILES_DIR/$name" "$target"
done

# =====================
# Terminal Tools
# =====================
echo ""
echo "🖥️  Setting up terminal tools..."

# Wezterm
backup "$HOME/.wezterm.lua"
symlink "$DOTFILES_DIR/wezterm.lua" "$HOME/.wezterm.lua"

# Tmux
backup "$HOME/.tmux.conf"
symlink "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"

# Powerlevel10k
backup "$HOME/.p10k.zsh"
symlink "$DOTFILES_DIR/p10k.zsh" "$HOME/.p10k.zsh"

# FZF
backup "$HOME/.fzf.zsh"
symlink "$DOTFILES_DIR/fzf.zsh" "$HOME/.fzf.zsh"

# =====================
# Keyboard (macOS only)
# =====================
if [[ $(uname) == "Darwin" ]]; then
  echo ""
  echo "⌨️  Setting up Karabiner..."
  backup "$HOME/.config/karabiner/karabiner.json"
  symlink "$DOTFILES_DIR/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
fi

# =====================
# Zsh Plugins
# =====================
echo ""
echo "🔌 Installing zsh plugins..."

ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
  echo "-----> Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "-----> Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

# =====================
# VS Code
# =====================
echo ""
echo "💻 Setting up VS Code..."

if [[ $(uname) == "Darwin" ]]; then
  CODE_PATH="$HOME/Library/Application Support/Code/User"
else
  CODE_PATH="$HOME/.config/Code/User"
  # WSL fallback
  if [ ! -d "$CODE_PATH" ]; then
    CODE_PATH="$HOME/.vscode-server/data/Machine"
  fi
fi

mkdir -p "$CODE_PATH"

for name in settings.json keybindings.json; do
  target="$CODE_PATH/$name"
  backup "$target"
  symlink "$DOTFILES_DIR/$name" "$target"
done

# =====================
# SSH (macOS only)
# =====================
if [[ $(uname) == "Darwin" ]]; then
  echo ""
  echo "🔐 Setting up SSH..."
  backup "$HOME/.ssh/config"
  symlink "$DOTFILES_DIR/config" "$HOME/.ssh/config"

  # Add SSH key to keychain if it exists
  if [ -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519" 2>/dev/null || true
  fi
fi

# =====================
# Neovim (separate repo)
# =====================
echo ""
echo "📝 Setting up Neovim..."

NVIM_DIR="$HOME/.config/nvim"
if [ ! -d "$NVIM_DIR" ]; then
  echo "-----> Cloning kickstart.nvim..."
  git clone git@github.com:rcopra/kickstart.nvim.git "$NVIM_DIR"
else
  echo "-----> Neovim config already exists at $NVIM_DIR"
fi

# =====================
# Tmux Plugin Manager
# =====================
echo ""
echo "🔧 Setting up Tmux Plugin Manager..."

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "-----> Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "-----> Run 'prefix + I' in tmux to install plugins"
else
  echo "-----> TPM already installed"
fi

# =====================
# Local secrets file
# =====================
echo ""
echo "🔒 Setting up local secrets file..."

if [ ! -f "$HOME/.zshrc.local" ]; then
  cat > "$HOME/.zshrc.local" << 'EOF'
# Local environment variables - NOT tracked in git
# Add your secrets, tokens, and machine-specific config here

# Example:
# export NPM_AUTH_TOKEN="your-token-here"
# export GITHUB_TOKEN="your-token-here"
# export AWS_ACCESS_KEY_ID="your-key"
# export AWS_SECRET_ACCESS_KEY="your-secret"
EOF
  echo "-----> Created $HOME/.zshrc.local for your secrets"
else
  echo "-----> $HOME/.zshrc.local already exists"
fi

# =====================
# Done
# =====================
echo ""
echo "✅ Dotfiles installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Add your secrets to ~/.zshrc.local"
echo "  2. Run 'git_setup.sh' to configure git identity"
echo "  3. Restart your terminal or run: exec zsh"
echo "  4. In tmux, press 'prefix + I' to install plugins"
echo ""
