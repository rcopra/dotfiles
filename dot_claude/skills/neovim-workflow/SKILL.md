---
name: neovim-workflow
description: Trigger when user asks how to do something in Neovim/Vim/nvim — navigation, search, editing, refactoring, LSP, registers, macros, marks, jumps, quickfix, or plugin usage. Also trigger for keybinding or motion questions, or when context makes it clear they're working in Neovim.
---

## Philosophy

- Hierarchy: native motion → existing keybind → installed plugin feature → last resort: regex/manual approach
- Advisory only — never edit config files, install plugins, or create keybinds
- One good answer fast, not a tutorial
- Always check the user's actual config before answering (keybinds may differ from defaults)
- Prefer Telescope/fuzzy-finding approaches over cycling or manual navigation

## Response Format

- **Recommended approach**: keystrokes on one line
- **Brief "why"**: one sentence explaining when/why this works
- **Alternative**: only if there's a meaningfully different tradeoff (speed vs precision, single file vs project-wide, etc.)

## Discovery

The user can self-discover answers with these tools:

| Method | What it does |
|--------|-------------|
| `<Space>sk` | Search all keymaps (Telescope) |
| `<Space>sh` | Search help tags (Telescope) |
| Press `<Space>` and wait | Which-key popup shows all leader bindings |
| `<Space>ss` | Browse all Telescope pickers |
| `:Lazy` | View installed plugins and their status |
| `:Mason` | View/install LSP servers and tools |
| `:ConformInfo` | Show active formatters for current buffer |
| `:checkhealth` | Diagnose plugin/provider issues |

## Keybind Reference

### Navigation

| Key | Action |
|-----|--------|
| `\\` | Toggle Neo-tree file explorer |
| `<C-h/j/k/l>` | Move focus between splits |
| `<C-d>` / `<C-u>` | Scroll half-page down/up (centered) |
| `<C-t>` | Jump back (after goto definition) |
| `<C-o>` / `<C-i>` | Jump list back/forward |

### Search & Find

| Key | Action |
|-----|--------|
| `<Space>sf` | Search files (Telescope find_files) |
| `<Space>sg` | Live grep across project (Telescope) |
| `<Space>sw` | Search current word under cursor |
| `<Space><Space>` | Search open buffers |
| `<Space>s.` | Search recent files |
| `<Space>sr` | Resume last Telescope search |
| `<Space>s/` | Live grep in open files only |
| `<Space>/` | Fuzzy search in current buffer |
| `<Space>sn` | Search Neovim config files |
| `<Space>sd` | Search diagnostics |

### LSP

| Key | Action |
|-----|--------|
| `grd` | Go to definition |
| `grr` | Find references |
| `grn` | Rename symbol |
| `gra` | Code action (normal and visual) |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grD` | Go to declaration |
| `gO` | Document symbols (Telescope) |
| `gW` | Workspace symbols (Telescope) |
| `<Space>th` | Toggle inlay hints |
| `<Space>q` | Open diagnostic quickfix list |

### Formatting

| Key | Action |
|-----|--------|
| `<Space>f` | Format buffer (conform.nvim) |
| (on save) | Auto-format on save (disable per-project with `vim.g.disable_autoformat = true` in `.nvim.lua`) |

### Git

| Key | Action |
|-----|--------|
| `<Space>gg` | Open Fugitive status (`:Git`) |
| `<Space>gb` | Git blame (Fugitive) |
| `<Space>gs` | Git status (Telescope) |
| `<Space>hs` | Stage hunk (gitsigns, normal + visual) |
| `<Space>hr` | Reset hunk |
| `<Space>hS` | Stage entire buffer |
| `<Space>hR` | Reset entire buffer |
| `<Space>hp` | Preview hunk |
| `<Space>hb` | Blame current line |
| `<Space>hd` | Diff against index |
| `<Space>hD` | Diff against last commit |
| `]c` / `[c` | Next/previous git hunk |
| `<Space>tb` | Toggle inline blame |

### Testing (vim-test)

| Key | Action |
|-----|--------|
| `<Space>tn` | Test nearest |
| `<Space>tf` | Test file |
| `<Space>ts` | Test suite |
| `<Space>tl` | Test last |
| `<Space>tv` | Visit last test file |

### Debugging (nvim-dap)

| Key | Action |
|-----|--------|
| `<F5>` | Start/Continue |
| `<F1>` | Step into |
| `<F2>` | Step over |
| `<F3>` | Step out |
| `<F7>` | Toggle DAP UI |
| `<Space>b` | Toggle breakpoint |
| `<Space>B` | Set conditional breakpoint |

### Other

| Key | Action |
|-----|--------|
| `<Space>cp` | Copy relative file path to clipboard |
| `<Esc>` (normal) | Clear search highlights |
| `<Esc><Esc>` (terminal) | Exit terminal mode |

## Text Objects Quick Reference

### Native

| Object | Meaning |
|--------|---------|
| `iw` / `aw` | Inner/around word |
| `i)` / `a)` | Inner/around parentheses |
| `i]` / `a]` | Inner/around brackets |
| `i}` / `a}` | Inner/around braces |
| `i"` / `a"` | Inner/around double quotes |
| `i'` / `a'` | Inner/around single quotes |
| `it` / `at` | Inner/around HTML tag |
| `ip` / `ap` | Inner/around paragraph |

### mini.ai Enhancements

| Object | Meaning |
|--------|---------|
| `if` / `af` | Inner/around function |
| `ic` / `ac` | Inner/around class |
| `inq` / `anq` | Inner/around next quote |

### nvim-surround

| Command | Action |
|---------|--------|
| `ys{motion}{char}` | Add surround (e.g., `ysiw"` wraps word in quotes) |
| `ds{char}` | Delete surround (e.g., `ds"` removes quotes) |
| `cs{old}{new}` | Change surround (e.g., `cs"'` changes double to single quotes) |

## Common Workflows

| Task | How |
|------|-----|
| Rename a variable across files | `grn` (LSP rename) |
| Find where a function is used | `grr` (LSP references) |
| Project-wide search and replace | `<Space>sg` → select matches → `<C-q>` to send to quickfix → `:cdo s/old/new/gc` |
| Stage specific lines | Visual select lines → `<Space>hs` |
| Explore unfamiliar codebase | `<Space>sf` to find files, `gO` for document symbols, `gW` for workspace symbols, `<Space>sg` to grep |
| Close buffer without closing window | `:bd` |
| Jump to a function definition | `grd` with cursor on the function name, or `<Space>sg` to search by name |
| See what changed in a file | `<Space>hd` (diff vs index) or `<Space>hD` (diff vs last commit) |
| Run the test you're editing | `<Space>tn` (nearest test) |
| Format a file that didn't auto-format | `<Space>f` |
| Browse all available Telescope pickers | `<Space>ss` |
| Multi-cursor editing | `<C-S-Down>` / `<C-S-Up>` to add cursors (vim-visual-multi) |

## Config Locations

```
~/.config/nvim/init.lua                    # Main config (options, keymaps, lazy.nvim setup)
~/.config/nvim/lua/custom/plugins/         # User's custom plugin specs
~/.config/nvim/lua/kickstart/plugins/      # Kickstart built-in plugins (debug, neo-tree, indent)
~/.config/nvim/CLAUDE.md                   # Claude instructions for this config
```
