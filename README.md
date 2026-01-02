# Dotfiles (chezmoi)

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io).

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

## Migrating from Old Dotfiles

If you have symlink-based dotfiles from another manager, chezmoi will replace them automatically:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:rcopra/chez-dotfiles.git
```

See [chezmoi's migration guide](https://www.chezmoi.io/migrating-from-another-dotfile-manager/) for details.

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
