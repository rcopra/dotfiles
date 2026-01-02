# Dotfiles (chezmoi)

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io).

## Quick Reference

| Scenario | Command |
|----------|---------|
| New machine setup | `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:rcopra/chez-dotfiles.git` |
| Pull & apply latest changes | `chezmoi update` |
| Edit a dotfile | `chezmoi edit ~/.zshrc` |
| Preview changes | `chezmoi diff` |
| Push your changes | `chezmoi cd && git add -A && git commit -m "msg" && git push` |

## New Machine Setup

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:rcopra/chez-dotfiles.git
```

You'll be prompted for:
- Git email
- Git name
- Machine type: `personal`, `work`, or `server` (server skips GUI apps)

After setup:
```bash
exec zsh                    # Reload shell
tmux                        # Then prefix+I to install plugins
nvim                        # Let lazy.nvim install plugins
```

## Switching Between Machines (IMPORTANT)

When you make changes on one machine and want to sync to another:

1. **On the machine where you made changes:**
   ```bash
   chezmoi cd
   git add -A && git commit -m "Your changes"
   git push
   ```

2. **On other machines:**
   ```bash
   chezmoi update    # Pull latest changes AND apply them
   ```

**Common Mistake**: Don't run `chezmoi init --apply` on an already-configured machine. Use `chezmoi update` instead!

**What `chezmoi update` does:**
- Pulls latest changes from git
- Automatically applies them to your home directory
- This is your **one-command workflow** for staying in sync

## Migrating from Old Dotfiles

If you have the old symlink-based dotfiles installed:

```bash
# 1. Remove old symlinks (they point to the old repo)
rm ~/.zshrc ~/.zprofile ~/.aliases ~/.gitconfig ~/.tmux.conf ~/.fzf.zsh
rm ~/.wezterm.lua ~/.irbrc ~/.pryrc ~/.rspec
rm ~/.config/karabiner/karabiner.json
rm ~/.ssh/config
rm ~/Library/Application\ Support/Code/User/settings.json
rm ~/Library/Application\ Support/Code/User/keybindings.json

# 2. Install chezmoi and apply
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:rcopra/chez-dotfiles.git
```

## Daily Usage

```bash
chezmoi edit ~/.zshrc       # Edit a file
chezmoi apply               # Apply changes
chezmoi diff                # Preview changes
chezmoi update              # Pull and apply latest
chezmoi cd                  # Jump to source directory
```

## Updating the Repo

```bash
chezmoi cd
git add -A && git commit -m "message" && git push
```
