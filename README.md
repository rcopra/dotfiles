# Dotfiles (chezmoi)

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io).

## Import dotfiles

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:rcopra/chez-dotfiles.git
```

After setup:

```bash
exec zsh                    # Reload shell
tmux                        # Then prefix+I to install plugins
nvim                        # Let lazy.nvim install plugins
```

## Cheat Sheet

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
