---
name: dotfiles-config
description: >
  Trigger when user asks to switch themes, change dotfiles config, add tools/plugins,
  modify keybinds across managed configs, or asks about chezmoi-managed files.
  Also trigger when user mentions color themes, terminal appearance, or "dotfiles".
---

# Dotfiles Config Skill

You are editing a chezmoi-managed dotfiles repo at `~/.local/share/chezmoi/`. macOS only — no templates, no Linux support.

## Critical Rules

- **NEVER use Bash/sed/awk to edit files.** Always use the Edit tool. sed has destroyed config files before.
- **NEVER edit target files in `~/` directly** — always edit the chezmoi source in `~/.local/share/chezmoi/`
- **Exception: `~/.config/chezmoi/chezmoi.toml`** — this IS the live config, edit it directly with the Edit tool
- **Exception: OmniWM** — the app rewrites `~/.config/omniwm/settings.toml` from its GUI. To edit: quit OmniWM, edit the LIVE file, relaunch, then `chezmoi re-add ~/.config/omniwm/settings.toml`
- **Neovim config is a SEPARATE git repo** at `~/.config/nvim/` (rcopra/kickstart.nvim). Edit files there directly, commit there separately (`git -C ~/.config/nvim commit ...`), never `chezmoi apply` for nvim changes.

## Safe Editing Workflow

1. **Read** the source file in `~/.local/share/chezmoi/`
2. **Edit** with the Edit tool (never Bash/sed)
3. **Preview** with `chezmoi diff` — verify rendered output is correct
4. **Apply** with `chezmoi apply`
5. **Explain** what changed and how to verify

## Theme

Gruvbox Material Mix (Hard) (`sainnhe/gruvbox-material`) hardcoded per tool, no central switcher:

- **Ghostty** (`dot_config/ghostty/config`) — theme/palette values
- **FZF** (`dot_fzf.zsh`) — mix(hard) hex values in `FZF_DEFAULT_OPTS`
- **Starship** (`dot_config/starship.toml`) — `starship preset gruvbox-rainbow` base with mix(hard) palette in `[palettes.gruvbox_material_mix]`
- **Neovim** (`~/.config/nvim/lua/custom/plugins/colorschemes.lua`) — `sainnhe/gruvbox-material`, `background='hard'`, `foreground='mix'` (separate repo)
- **Zellij** (`dot_config/zellij/config.kdl`) — `theme` setting (currently catppuccin-macchiato — not yet gruvboxed)

### Powerline glyph gotcha

Claude Code's Edit/Write tools silently strip powerline characters (U+E0B0, U+E0BC, etc.):
- **Starship**: use `starship preset <name> -o <path>` CLI for the base, edit only palette/non-glyph parts, then `chezmoi re-add`
- **Manual injection**: use Python (`open(path, 'w')`), never Edit/Write

## Config File Map

| Source path | Target | Purpose |
|---|---|---|
| `dot_zshrc` | `~/.zshrc` | Shell config, aliases, PATH |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` | Terminal (option-as-alt + alt+arrow unbinds live here) |
| `dot_config/zellij/config.kdl` | `~/.config/zellij/config.kdl` | Multiplexer; locked-by-default; vim-zellij-navigator on Alt+arrows |
| `dot_config/omniwm/settings.toml` | `~/.config/omniwm/settings.toml` | Window manager (Hyper-3 hotkeys, workspaces, app rules) |
| `dot_config/karabiner/karabiner.json` | `~/.config/karabiner/karabiner.json` | Caps→Hyper-3, launchers, move+follow synthesis |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Prompt |
| `dot_fzf.zsh` | `~/.fzf.zsh` | FZF setup + theme |
| `.chezmoiexternal.toml` | (chezmoi) | vim-zellij-navigator wasm |
| `~/.config/nvim/` | `~/.config/nvim/` | Neovim (separate git repo) |

## Discovery Commands

```bash
chezmoi managed          # List all managed files
chezmoi source-path ~/.zshrc   # Find source for a specific target
chezmoi diff             # Preview pending changes
```

## Common Tasks

### Add a zsh alias or function
1. Edit `dot_zshrc`
2. `chezmoi diff` then `chezmoi apply`

### Modify keybinds
- **OmniWM**: quit app → edit live `~/.config/omniwm/settings.toml` (`[[hotkeys]]` binding strings like `"Control+Option+Command+N"`) → relaunch → `chezmoi re-add`
- **Karabiner**: edit live `~/.config/karabiner/karabiner.json` (auto-reloads) → `chezmoi re-add`
- **Zellij**: edit source `dot_config/zellij/config.kdl` → `chezmoi apply` (fresh session for plugin changes)
- **Ghostty**: edit source → `chezmoi apply` → reload config in Ghostty (Cmd+Shift+,)
