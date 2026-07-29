# Ghostty

## Role

The only terminal in the stack. Installed manually (not Homebrew). Its job is to be a fast,
transparent host for Zellij — draw pixels, get out of the way. 12-line config:
`home/dot_config/ghostty/config`.

## Keybind philosophy

Ghostty owns almost nothing. Zellij is started manually (no shell autostart; `Ctrl+f` runs
`~/bin/zellij-sessionizer`) and owns panes/tabs/sessions; OmniWM owns window placement
(appRule for `com.mitchellh.ghostty`, `home/dot_config/omniwm/settings.toml:222`);
Karabiner owns launching (`⌥⏎` → `open -na Ghostty`, Hyper-3 G → `open -a Ghostty`).

So the only custom keybinds are two **unbinds** — Ghostty subtracts keys rather than adding
them. Everything else used daily is a stock macOS-shaped default (`⌘N`, `⌘W`, `⌘C`/`⌘V`,
`⌘K`, `⌘⇧,`). Its `⌘T` (`new_tab`) and `⌘D` (`new_split:right`) work but are deliberately
unused and *not* unbound, so they're latent duplicates of Zellij's layer.

## Option-as-alt behavior

`macos-option-as-alt = true` is the load-bearing setting. Option sends a real Alt modifier
(ESC prefix / CSI) instead of composing macOS special characters — that's what lets
Alt+arrow reach Zellij's vim-zellij-navigator and, through it, Neovim's smart-splits.

That alone isn't enough: Ghostty ships default `alt+arrow_left=esc:b` /
`alt+arrow_right=esc:f` word-motion bindings that swallow the keys. Hence
`keybind = option+left=unbind` (and `right`). These are the *only* `alt+`-prefixed defaults
in 1.3.1 — Option+up/down and Option+Backspace are unbound already and pass through.

## Quirks

- `option+` and `left` are just **aliases**: 1.3.1 normalizes `option+left` to
  `alt+arrow_left`, and `alt+left`, `alt+arrow_left` and `option+arrow_left` all unbind
  identically (verified via `ghostty +list-keybinds`). The config comment that claimed
  `option+` is *required* was corrected 2026-07-29.
- `quit-after-last-window-closed = true` — exiting the last shell quits the app (no
  windowless zombie in dock/⌘-Tab), so `⌘W` on a lone window is an app quit and Hyper-3 G
  cold-starts rather than raising.
- `macos-titlebar-style = hidden` — no titlebar chrome; geometry comes from OmniWM.
- Theme is **Catppuccin Macchiato**, not Gruvbox Material. Known drift (same as Zellij).
- Defaults here were verified against **Ghostty 1.3.1** via `ghostty +list-keybinds
  --default`. Ghostty spells Command as `super+`, so `⌘⇧,` is `super+shift+,=reload_config`.
