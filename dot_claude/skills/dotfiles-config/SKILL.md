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

Gruvbox Material Mix (Hard) (`sainnhe/gruvbox-material`) is hardcoded across all tools. There is no centralized theme switching system.

### How themes are configured per tool

- **WezTerm** (`dot_wezterm.lua`) — custom `config.colors` table with mix(hard) hex values
- **tmux** (`dot_tmux.conf`) — sainnhe-style status line with manual hex values, diagonal powerline separators (E0BC/E0BA), plus `tmux-cpu`, `tmux-net-speed`, and `tmux-prefix-highlight` plugins
- **FZF** (`dot_fzf.zsh.tmpl`) — gruvbox-material mix(hard) hex values in `FZF_DEFAULT_OPTS`
- **Starship** (`dot_config/starship.toml`) — gruvbox-rainbow preset with mix(hard) palette overrides
- **Neovim** (`~/.config/nvim/lua/custom/plugins/colorschemes.lua`) — `sainnhe/gruvbox-material` with `background='hard'`, `foreground='mix'`

### Switching themes (manual per-tool)

To change to a different theme, edit each config file individually:
1. WezTerm: update `config.colors` table hex values
2. tmux: update hex values in the theme section
3. FZF: update hex values in `FZF_DEFAULT_OPTS`
4. Starship: update palette in `dot_config/starship.toml`
5. Neovim: change colorscheme plugin + `vim.cmd.colorscheme` (commit separately in nvim repo)

## Config File Map

| Source path | Target | Purpose |
|---|---|---|
| `.chezmoi.toml.tmpl` | `~/.config/chezmoi/chezmoi.toml` | Chezmoi config |
| `dot_zshrc.tmpl` | `~/.zshrc` | Shell config, aliases, PATH |
| `dot_tmux.conf` | `~/.tmux.conf` | Tmux config, plugins, keybinds, theme |
| `dot_wezterm.lua` | `~/.wezterm.lua` | WezTerm terminal config |
| `dot_fzf.zsh.tmpl` | `~/.fzf.zsh` | FZF setup and theme colors |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Starship prompt |
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
