---
name: dotfiles-config
description: >
  Trigger when user asks to switch themes, change dotfiles config, add tools/plugins,
  modify keybinds across managed configs, or asks about chezmoi-managed files.
  Also trigger when user mentions color themes, terminal appearance, or "dotfiles".
---

# Dotfiles Config Skill

You are editing a chezmoi-managed dotfiles repo at `~/.local/share/chezmoi/`.

## Critical Rules

- **NEVER use Bash/sed/awk to edit files.** Always use the Edit tool. sed has destroyed config files before.
- **NEVER edit target files in `~/` directly** — always edit the chezmoi source in `~/.local/share/chezmoi/`
- **Exception: `~/.config/chezmoi/chezmoi.toml`** — this IS the live config, edit it directly with the Edit tool
- **Neovim config is a SEPARATE git repo** at `~/.config/nvim/` (rcopra/kickstart.nvim, cloned via `.chezmoiexternal.toml`). You CAN edit it directly, but treat it as its own project: edit files in `~/.config/nvim/`, commit there separately (`git -C ~/.config/nvim commit ...`), and do NOT use `chezmoi apply` for nvim changes — chezmoi would overwrite them.

## Safe Editing Workflow

1. **Read** the source file in `~/.local/share/chezmoi/`
2. **Edit** with the Edit tool (never Bash/sed)
3. **Preview** with `chezmoi diff` — verify rendered output is correct
4. **Apply** with `chezmoi apply`
5. **Explain** what changed and how to verify

## Theme

Rose Pine Moon is hardcoded across all tools. There is no centralized theme switching system.

### How themes are configured per tool

- **WezTerm** (`dot_wezterm.lua`) — `neapsix/wezterm` plugin, moon variant
- **tmux** (`dot_tmux.conf`) — `rose-pine/tmux` TPM plugin with `@rose_pine_variant 'moon'`
- **FZF** (`dot_fzf.zsh.tmpl`) — official `rose-pine/fzf` hex values in `FZF_DEFAULT_OPTS`
- **oh-my-posh** (`dot_config/ohmyposh/config.json`, `config.toml`) — hardcoded hex in `palette`
- **Neovim** (`~/.config/nvim/lua/custom/plugins/colorschemes.lua`) — `vim.cmd.colorscheme 'rose-pine-moon'`

### Switching themes (manual per-tool)

To change to a different theme, edit each config file individually:
1. WezTerm: change `config.color_scheme`
2. tmux: swap the rose-pine plugin or add manual color lines
3. FZF: update hex values in `FZF_DEFAULT_OPTS`
4. oh-my-posh: update hex values in `palette` section (both JSON and TOML)
5. Neovim: change `vim.cmd.colorscheme` (commit separately in nvim repo)

## Config File Map

| Source path | Target | Purpose |
|---|---|---|
| `.chezmoi.toml.tmpl` | `~/.config/chezmoi/chezmoi.toml` | Chezmoi config |
| `dot_zshrc.tmpl` | `~/.zshrc` | Shell config, aliases, PATH |
| `dot_tmux.conf` | `~/.tmux.conf` | Tmux config, plugins, keybinds, theme |
| `dot_wezterm.lua` | `~/.wezterm.lua` | WezTerm terminal config |
| `dot_fzf.zsh.tmpl` | `~/.fzf.zsh` | FZF setup and theme colors |
| `dot_config/ohmyposh/config.json` | `~/.config/ohmyposh/config.json` | Oh-my-posh prompt (JSON) |
| `dot_config/ohmyposh/config.toml` | `~/.config/ohmyposh/config.toml` | Oh-my-posh prompt (TOML) |
| `dot_aerospace.toml` | `~/.aerospace.toml` | macOS window manager |
| `~/.config/nvim/` | `~/.config/nvim/` | Neovim config (separate git repo — rcopra/kickstart.nvim) |
| `.chezmoiexternal.toml` | (chezmoi) | External repo declarations (nvim, TPM) |
| `.chezmoiignore` | (chezmoi) | Platform-conditional file exclusions |

## Discovery Commands

```bash
chezmoi managed          # List all managed files
chezmoi data             # Show all template data (theme, machine type, etc.)
chezmoi source-path      # Show source directory path
chezmoi source-path ~/.tmux.conf   # Find source for a specific target
chezmoi diff             # Preview pending changes
chezmoi cat-config       # Show active chezmoi config
```

## Common Tasks

### Add a tmux plugin
1. Add `set -g @plugin 'author/plugin-name'` to `dot_tmux.conf` (above the TPM init line)
2. Add any plugin config options
3. `chezmoi apply` then `prefix + I` in tmux to install

### Add a zsh alias or function
1. Edit `dot_zshrc.tmpl`
2. `chezmoi diff` then `chezmoi apply`

### Modify keybinds
- **tmux**: `dot_tmux.conf` — use `bind-key` / `bind`
- **WezTerm**: `dot_wezterm.lua` — add to `config.keys` table
- **Aerospace**: `dot_aerospace.toml` — uses TOML keybind format
