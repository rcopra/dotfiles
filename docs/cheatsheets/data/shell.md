# Shell (zsh + fzf + CLI tools)

## Setup

No framework — [zinit](https://github.com/zdharma-continuum/zinit) pulls four OMZ *library*
snippets (`key-bindings`, `completion`, `history`, `directories`) + the OMZ `git` plugin, then
turbo-loads `zsh-autosuggestions`, `zsh-history-substring-search`, `zsh-syntax-highlighting`,
`wfxr/forgit`. `dot_zprofile` is minimal (pyenv root, `brew shellenv`, `pyenv init --path`);
`dot_zshrc` does the rest. `~/.aliases` and untracked `~/.zshrc.local` are sourced last.
In the JSON, `origin: default` = built into zsh or fzf; `plugin` = zinit plugin or OMZ snippet.

## fzf integration

`source <(fzf --zsh)` (`dot_zshrc:140`, fzf 0.74.1) installs all four widgets — verified from a
live `bindkey` dump: ⌃R, ⌃T, ⌥C, and ⇥ → `fzf-completion` (with the `**` trigger). ⌥C really is
reachable: Ghostty sets `macos-option-as-alt = true` and Zellij's locked mode only claims Alt+n
and Alt+arrows. `fzf-cd-widget` sets `no_aliases` and emits `builtin cd`, sidestepping the
`cd`→zoxide alias, so ⌥C jumps are never learned by zoxide.

`home/dot_fzf.zsh` was dead code (never sourced, Kanagawa palette) — **deleted 2026-07-29** via
`chezmoi destroy`. `FZF_DEFAULT_OPTS` is unset, so fzf runs with default colors; gruvbox theming
for fzf is still TODO (export belongs in `dot_zshrc` when added).

## Keybindings

Only three `bindkey` calls exist, all in `dot_zshrc`: ↑/↓ → history-substring-search (117-118,
bound before the turbo plugin defines the widgets, which is fine since zsh resolves widget names
at keypress) and ⌃F → sessionizer macro (151). A ⌃S → Zellij `SSH` session macro was removed
2026-07-29 — it was unreachable anyway (eaten as XOFF; `ixon` enabled) and unused.

**⌃F costs less than claimed.** It shadowed `forward-char`, which is in
`ZSH_AUTOSUGGEST_ACCEPT_WIDGETS` — a *full* accept, not a partial one. → and ⌃E are drop-in
replacements; the real partial accept is `forward-word` = ⌥F.

From OMZ: ⌃X⌃E → `edit-command-line` (not a zsh default), plus a stray ⌥L macro that runs `ls`,
shadowing `down-case-word`. ⌃U (`kill-whole-line`) and ⌃W (`backward-kill-word`) are plain zsh
emacs defaults, not OMZ overrides — bash's ⌃U (`backward-kill-line`) is what differs.

## Scripts, aliases, tools

`home/bin/executable_zellij-sessionizer` is the only custom script — fzf over `~/work`,
`~/personal` + pinned `~/.config/nvim` and `~/.local/share/chezmoi`. Bound to ⌃F, aliased as
`tms`/`tmd`/`tmw`/`tmp`/`tmv`. Also `ls`…`lt` → eza, `cd` → zoxide, `myip`, `serve`, `speedtest`;
OMZ git gives `gst`/`gco`/`gp`, forgit adds `ga`/`gd`/`glo` (commands, not hotkeys) via `delta`.
Version managers: rbenv, pyenv (+virtualenv), and **fnm** — CLAUDE.md's nvm claim is stale.
`starship.toml` is prompt-only; `gh-dash/config.yml` sets `keybindings: {}` (built-in keys only).
