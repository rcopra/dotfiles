# Dotfiles

Personal development environment configuration. Clone once, run install, and you're ready to code.

## Quick Start

```bash
# Clone the repo
git clone git@github.com:rcopra/dotfiles.git ~/code/rcopra/dotfiles
cd ~/code/rcopra/dotfiles

# Install everything
./install.sh

# Configure git identity
./git_setup.sh
```

## What's Included

### Shell
- **zshrc** - Zsh config with oh-my-zsh, version managers (rbenv, pyenv, nvm, asdf), and custom settings
- **zprofile** - Login shell setup for Homebrew and pyenv
- **aliases** - Custom shell aliases
- **p10k.zsh** - Powerlevel10k prompt theme (lean style, 8 colors)
- **fzf.zsh** - Fuzzy finder configuration

### Terminal
- **wezterm.lua** - WezTerm terminal config (MesloLGS font, Kanagawa theme, custom keybindings)
- **tmux.conf** - Tmux config with vim-style navigation, plugins (resurrect, continuum, kanagawa theme)

### Editor
- **settings.json** - VS Code settings
- **keybindings.json** - VS Code keybindings
- **Neovim** - Cloned separately from [rcopra/kickstart.nvim](https://github.com/rcopra/kickstart.nvim)

### Git
- **gitconfig** - Git aliases and configuration
- **config** - SSH config with macOS keychain integration

### Ruby/Python
- **irbrc** - IRB config (launches Pry if available)
- **pryrc** - Pry prompt customization
- **rspec** - RSpec formatting options

### macOS
- **karabiner.json** - Karabiner-Elements keyboard customization

## Prerequisites

Install these before running `install.sh`:

### macOS
```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Essential tools
brew install git zsh eza zoxide fzf

# Terminal & shell
brew install --cask wezterm
brew install tmux powerlevel10k

# Version managers
brew install rbenv pyenv nvm asdf

# Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Fonts (for terminal icons)
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

### Linux
```bash
# Essential tools
sudo apt install git zsh fzf tmux

# Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install eza, zoxide, and other tools via your package manager or cargo
```

## Directory Structure

After installation, your home directory will have:

```
~
├── .zshrc           -> dotfiles/zshrc
├── .zprofile        -> dotfiles/zprofile
├── .aliases         -> dotfiles/aliases
├── .gitconfig       -> dotfiles/gitconfig
├── .p10k.zsh        -> dotfiles/p10k.zsh
├── .fzf.zsh         -> dotfiles/fzf.zsh
├── .wezterm.lua     -> dotfiles/wezterm.lua
├── .tmux.conf       -> dotfiles/tmux.conf
├── .irbrc           -> dotfiles/irbrc
├── .pryrc           -> dotfiles/pryrc
├── .rspec           -> dotfiles/rspec
├── .zshrc.local     # Local secrets (not tracked)
├── .ssh/
│   └── config       -> dotfiles/config
├── .config/
│   ├── nvim/        # Cloned from rcopra/kickstart.nvim
│   └── karabiner/
│       └── karabiner.json -> dotfiles/karabiner.json
└── Library/Application Support/Code/User/  # macOS
    ├── settings.json     -> dotfiles/settings.json
    └── keybindings.json  -> dotfiles/keybindings.json
```

## Secrets & Local Config

Machine-specific settings and secrets go in `~/.zshrc.local` (created by install script):

```bash
# ~/.zshrc.local - NOT tracked in git
export NPM_AUTH_TOKEN="your-token"
export GITHUB_TOKEN="your-token"
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
```

## Key Bindings

### Tmux (prefix: Ctrl+a)
| Key | Action |
|-----|--------|
| `prefix + \|` | Split horizontal |
| `prefix + -` | Split vertical |
| `prefix + r` | Reload config |
| `prefix + m` | Toggle zoom |
| `Alt + arrows` | Navigate panes |
| `prefix + I` | Install plugins |

### WezTerm
| Key | Action |
|-----|--------|
| `Cmd + k` | Clear scrollback |
| `Shift + Enter` | Send escape + return |
| `Shift + Up/Down` | Scroll by line |

### Git Aliases
| Alias | Command |
|-------|---------|
| `git co` | checkout |
| `git st` | status -sb |
| `git br` | branch |
| `git lg` | Pretty log with graph |
| `git m` | Checkout default branch |
| `git sweep` | Clean merged branches |

### Shell Aliases
| Alias | Command |
|-------|---------|
| `ls` | eza with icons |
| `cd` | zoxide (smart cd) |
| `myip` | Show external IP |
| `speedtest` | Run speed test |
| `serve` | HTTP server on :8000 |

## Updating

```bash
cd ~/code/rcopra/dotfiles
git pull

# Re-run install to pick up new configs
./install.sh
```

## New Machine Setup

1. Install prerequisites (see above)
2. Generate SSH key: `ssh-keygen -t ed25519 -C "your@email.com"`
3. Add SSH key to GitHub
4. Clone and install dotfiles
5. Add secrets to `~/.zshrc.local`
6. In tmux, run `prefix + I` to install plugins
7. In neovim, plugins auto-install on first launch
