# Dotfiles (chezmoi)

macOS dotfiles managed with [chezmoi](https://chezmoi.io). Apple Silicon Macs only.

## Import dotfiles

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:rcopra/dotfiles.git
```

After setup:

```bash
exec zsh                    # Reload shell
```

Neovim is intentionally managed outside this repo (separate kickstart clone).

Terminal workflow: Ghostty + tmux. Run `tms` to pick a project; see the
[tmux shortcuts](docs/tmux-cheatsheet.md).

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

## Planning keybinds

See the [keybinding inventory](docs/keybindings.md) for bindings across the
keyboard, desktop, terminal, shell, and Neovim, plus cleanup decisions.

Keyboard and keybinding work require context from a separate ZMK config repo:

- `~/personal/zmk-config` — physical keymap and firmware. Read its `AGENTS.md`
  and `docs/d50-map.md` before proposing keymap changes.

Trace physical key/layer → emitted chord → interceptor → application action
before changing either side, and pick a single owner for the change.
