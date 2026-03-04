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

## Theme System

Colors are centralized in `.chezmoidata/themes.toml`. 23 themes available. Dark: `kanagawa`, `catppuccin-mocha`, `tokyo-night`, `gruvbox-dark`, `rose-pine`, `nord`, `dracula`, `ethereal`, `everforest`, `miasma`, `hackerman`, `osaka-jade`, `ristretto`, `matte-black`, `vantablack`, `flexoki-dark`, `solarized-dark`, `one-dark-pro`, `monokai`, `eldritch`. Light: `flexoki-light`, `catppuccin-latte`, `white`.

### How themes work

- **Active theme**: `.theme` in `~/.config/chezmoi/chezmoi.toml` under `[data]`
- **Theme palettes**: `.chezmoidata/themes.toml` — semantic color keys per theme: bg, fg, muted, accent, green, red, yellow, orange, purple, teal, wezterm_scheme, delta_theme
- **Template syntax**: `{{ index .themes .theme "accent" }}` resolves to the hex color for the active theme
- **All configs are templated** — every themed config updates automatically with `chezmoi apply`

### Templated configs (auto-update on theme switch)

- **oh-my-posh JSON** (`dot_config/ohmyposh/config.json.tmpl`) — uses OMP `palette` with `p:name` refs, chezmoi `(( ))` delimiters
- **oh-my-posh TOML** (`dot_config/ohmyposh/config.toml.tmpl`) — same approach, TOML format
- **WezTerm** (`dot_wezterm.lua.tmpl`) — `wezterm_scheme` key
- **tmux** (`dot_tmux.conf.tmpl`) — status bar, pane borders, message style
- **FZF** (`dot_fzf.zsh.tmpl`) — `FZF_DEFAULT_OPTS` colors

### Switching themes — step by step

**Goal: minimize user interaction.** Everything is templated, so switching is just one config edit + apply.

1. **Read in parallel**: `~/.config/chezmoi/chezmoi.toml` and `~/.config/nvim/lua/custom/plugins/colorschemes.lua`
2. **Edit** `~/.config/chezmoi/chezmoi.toml` — change `theme = "..."` to the new theme (use Edit tool!)
3. **Run** `chezmoi apply` — this updates ALL themed configs (WezTerm, tmux, FZF, oh-my-posh)
4. **Update Neovim colorscheme** — edit `~/.config/nvim/lua/custom/plugins/colorschemes.lua`:
   - Change the colorscheme plugin and `vim.cmd.colorscheme` call to match the new theme
   - Commit in the nvim repo: `git -C ~/.config/nvim add -A && git -C ~/.config/nvim commit -m "switch colorscheme to <theme>"`
5. **Auto-refresh running sessions**:
   - tmux: `tmux source-file ~/.tmux.conf` (works if inside tmux — always try it)
   - FZF/oh-my-posh: `source ~/.zshrc` (reloads shell config)
6. **Tell user** only manual steps: restart WezTerm, reopen Neovim (plugin installs on first launch if needed)

## Config File Map

| Source path | Target | Purpose |
|---|---|---|
| `.chezmoi.toml.tmpl` | `~/.config/chezmoi/chezmoi.toml` | Chezmoi config, theme selection |
| `.chezmoidata/themes.toml` | (data only) | Color palettes for all themes |
| `dot_zshrc.tmpl` | `~/.zshrc` | Shell config, aliases, PATH |
| `dot_tmux.conf.tmpl` | `~/.tmux.conf` | Tmux config, plugins, keybinds, theme |
| `dot_wezterm.lua.tmpl` | `~/.wezterm.lua` | WezTerm terminal config |
| `dot_fzf.zsh.tmpl` | `~/.fzf.zsh` | FZF setup and theme colors |
| `dot_config/ohmyposh/config.json.tmpl` | `~/.config/ohmyposh/config.json` | Oh-my-posh prompt (JSON) |
| `dot_config/ohmyposh/config.toml.tmpl` | `~/.config/ohmyposh/config.toml` | Oh-my-posh prompt (TOML) |
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
1. Add `set -g @plugin 'author/plugin-name'` to `dot_tmux.conf.tmpl` (above the TPM init line)
2. Add any plugin config options
3. `chezmoi apply` then `prefix + I` in tmux to install

### Add a zsh alias or function
1. Edit `dot_zshrc.tmpl`
2. `chezmoi diff` then `chezmoi apply`

### Modify keybinds
- **tmux**: `dot_tmux.conf.tmpl` — use `bind-key` / `bind`
- **WezTerm**: `dot_wezterm.lua.tmpl` — add to `config.keys` table
- **Aerospace**: `dot_aerospace.toml` — uses TOML keybind format

### Add a new color to the theme palette
1. Add the key to ALL themes in `.chezmoidata/themes.toml`
2. Reference in templates as `{{ index .themes .theme "new_key" }}`
