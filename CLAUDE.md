# CLAUDE.md

## Repository Overview

macOS dotfiles managed with [chezmoi](https://chezmoi.io). Apple Silicon only — no templates, no cross-platform conditionals, no `.tmpl` files; every config is static with hardcoded values. Headless Pis are managed by hand, not here. Goal: both MacBooks (personal & work) behave identically.

Source dir is `home/`. Chezmoi prefixes: `dot_` → `.`, `private_` → 0600, `run_once_`/`run_onchange_` → scripts, `symlink_` → symlink (target is file content).

Workflow: edit in `home/`, then `chezmoi diff <target>` → `chezmoi apply <target>`.

## Core Stack

- **Terminal**: Ghostty (installed manually, not brew) — `dot_config/ghostty/config`
- **Multiplexer**: Zellij, locked-by-default mode — `dot_config/zellij/config.kdl`; Alt+arrow pane nav via vim-zellij-navigator wasm plugin (works in locked mode; nvim side is smart-splits.nvim). Global pane/tab/session binds live in the `shared` block (applies to every mode incl. locked), not in `locked`. Before taking a new key, check it against `bindkey` (zsh) and nvim — `Alt f`/`Alt d`/`Ctrl n`/`Ctrl o` are deliberately left alone
- **Window manager**: OmniWM (Niri-style columns) — `dot_config/omniwm/settings.toml`; all hotkeys on the Hyper-3 (⌃⌥⌘) tier, workspaces on ⌘1-9
- **Karabiner**: Caps→Hyper-3, app launchers, ⌘⇧ move+follow synthesis — `dot_config/private_karabiner/karabiner.json`
- **Editor**: Neovim — `~/.config/nvim` intentionally unmanaged (separate kickstart clone)
- **Prompt**: Starship, gruvbox-rainbow preset
- **Keyboard**: Hillside D50 (daily) + Temper, ZMK firmware ([zmk-config](https://github.com/rcopra/zmk-config)); Hyper-3 on raised keys

## Theme

Catppuccin Latte/Mocha, following macOS appearance: Ghostty via `theme = light:…,dark:…`, Zellij via `theme_light`/`theme_dark` (Zellij reads the terminal's palette at session start, so it re-themes on new sessions only). Starship is gruvbox — deliberate mismatch, not drift. No centralized switching; each config is edited individually.

## Architecture

- **Externals** (`home/.chezmoiexternal.toml`): vim-zellij-navigator wasm plugin
- **Packages** (`home/.chezmoiscripts/run_onchange_install-packages.sh`): Homebrew, re-runs on content change
- **VS Code**: `~/Library/Application Support/Code/User/` symlinked to `home/vscode/` via relative paths
- **Version managers**: mise for ruby + node (reads `.ruby-version`/`.nvmrc`/`.node-version`; brew node stays as gemini-cli dep), uv for python — no rbenv/pyenv/fnm/nvm
- **Zsh plugins**: brew-installed, sourced directly in `dot_zshrc` — no zinit/OMZ; git aliases are inlined (only the handful history showed in use)
- **Docs**: `docs/keyboard-planning.md` (ZMK keymap + WM modifier plan), `docs/cheatsheets/` — three printable sheets (`hyper`, `zellij`, `ghostty-shell`) sharing `sheet.css`, full text list in `keybinds.md`, PDFs via `make-pdfs.sh`. Each sheet must stay one landscape page; print CSS uses `zoom` to fit, so re-run `make-pdfs.sh` after adding rows

## Gotchas

- **`~/.config/chezmoi/chezmoi.toml` is the live config** — edit directly with Edit tool, never sed/Bash (sed has corrupted it before)
- **Local drift**: on `has changed since chezmoi last wrote it`, keep the local copy with `chezmoi re-add <path>`
- **OmniWM rewrites settings.toml from its GUI** — quit OmniWM, edit, relaunch, then `chezmoi re-add`
- **Edit/Write strip powerline glyphs** (U+E0B0, U+E0BC) — inject via Python, or let a CLI write them. For Starship, regenerate with `starship preset gruvbox-rainbow -o ~/.config/starship.toml`, then patch the palette and `chezmoi re-add`
