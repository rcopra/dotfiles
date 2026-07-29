# Neovim

Primary editor. Config lives at `~/.config/nvim` and is **intentionally not chezmoi-managed** — a
separate kickstart.nvim clone with its own git history and `CLAUDE.md`. Running nvim 0.12.4.

## Structure

- `init.lua` (1245 lines) — options, basic keymaps, and the whole `lazy.setup{}` list inline:
  gitsigns, which-key, telescope (+fzf-native, ui-select), lspconfig/mason, conform, blink.cmp,
  tokyonight, todo-comments, mini.nvim, treesitter.
- `lua/kickstart/plugins/` — `debug.lua`, `indent_line.lua`, `autopairs.lua`, `neo-tree.lua` are
  live; the `kickstart.plugins.lint` and `kickstart.plugins.gitsigns` requires are **commented out**
  (`init.lua:1215`, `init.lua:1218`), so `lua/kickstart/plugins/gitsigns.lua` is dead code — the live
  hunk maps are the inline `opts.on_attach` copy at `init.lua:397-429`.
- `lua/custom/plugins/` — auto-imported: smart-splits, diffview, fugitive, octo, vim-test,
  vim-visual-multi, lint (empty `linters_by_ft`), leetcode, markdown-preview, rainbow-csv,
  highlight-colors, colorschemes, vim-be-good.
- 44 plugins in `lazy-lock.json`; `nvim-surround` is pinned but has **no spec** (stale lock entry),
  so mini.surround owns `s*` uncontested.

## Leader

`<Space>` for both leaders (`init.lua:90`). which-key (`delay = 0`) documents four prefixes at
`init.lua:496-499`: `<leader>s`, `<leader>t`, `<leader>h`, `gr`. Group *labels* only — not bindings,
so not listed in `neovim.json`.

## Keymap clusters (108 total)

- **Git (26)** — gitsigns `<leader>h*` hunks, diffview `<leader>g{d,f,h,m,c}` (PR-oriented
  `main...HEAD` presets), fugitive `<leader>g{g,b}`, octo `<leader>o{i,p,d,n,s}`.
- **Search (17)** — all Telescope; `<leader>s.` is a tuned `fd` with a Rails/JS noise exclude list.
- **LSP (14)** — Neovim 0.11+ stock `gr*` namespace, `grr/gri/grd/grt/gO/gW` re-pointed at Telescope
  on `LspAttach`. Servers: gopls, pyright, jdtls, ts_ls, eslint, lua_ls, hand-rolled `ruby_lsp`.
- **Editing (12)** mini.surround `s*`, mini.ai textobjects, conform `<leader>f`, visual-multi.
- **Completion (12)** — blink.cmp `default` preset (`<C-y>` accept). Docs (`init.lua:1053`) and the
  signature window (`init.lua:1072`) are both off: `<C-space>` is required for docs, `<C-k>` no-ops
  through to Vim's digraph insert, and signature help is Neovim's own stock `<C-S>`.
- **Debug (7)** F-keys + `<leader>b/B`; **Test (5)** vim-test `<leader>t{n,f,s,l,v}`.

## Zellij navigator integration

The nvim side is **smart-splits.nvim**, not vim-zellij-navigator (that's the Zellij-side wasm
plugin). `smart-splits.lua` binds `<M-Left/Down/Up/Right>` to `move_cursor_*`; at a split edge it
shells out to `zellij action move-focus`. `zellij_move_focus_or_tab` (plugin default `false`, set
`true` at `smart-splits.lua:10`) upgrades that to `move-focus-or-tab` for **left/right only** —
verified in the plugin's `mux/zellij.lua:79-81` — mirroring the `MoveFocusOrTab` binds in
`config.kdl`. Kickstart's `<C-hjkl>` maps stay (`init.lua:266-269`); the comment there claims
Zellij shadows `<C-h>`, but `config.kdl` binds `Ctrl h` -> move mode under
`shared_except "locked" "move"`, so with Zellij locked-by-default `<C-h>` reaches nvim.

## Quirks

- `<leader>t` is labeled "Toggle" but vim-test squats five keys there; `<leader>o` has no group.
- `<leader>hu` ("undo stage hunk") is wired to `stage_hunk` — upstream kickstart bug, still present.
- `<leader>tD` ("toggle show deleted") is `preview_hunk_inline`, not `toggle_deleted`.
- Two blame bindings (`<leader>hb` gitsigns, `<leader>gb` fugitive).
- netrw disabled; `\` is the only file-tree entry (and toggles closed from inside Neo-tree).
- `vim.o.exrc = true` — project `.nvim.lua` can set `vim.g.disable_autoformat`.
- Colorscheme is **catppuccin macchiato** (`colorschemes.lua`), not gruvbox — same drift as
  Ghostty/Zellij.
