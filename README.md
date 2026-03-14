# Dotfiles (chezmoi)

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io).

## Import dotfiles

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:rcopra/dotfiles.git
```

After setup:

```bash
exec zsh                    # Reload shell
tmux                        # Then prefix+I to install plugins
```

Neovim is intentionally managed outside this repo (separate kickstart clone).

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

## Adopting Local Changes Into Chezmoi

If a managed file changed locally and you want to keep that local version, re-add it into the source state:

```bash
chezmoi re-add ~/.config/opencode/opencode.json
chezmoi diff
chezmoi apply
```

This resolves errors like: `has changed since chezmoi last wrote it` while preserving your current machine settings.
