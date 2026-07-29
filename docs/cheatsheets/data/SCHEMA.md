# Hotkey inventory schema

Each tool gets two files in this directory:

- `<tool>.json` — machine-readable hotkey inventory (schema below)
- `<tool>.md` — short human report: what the tool does in this setup, config quirks, notable design decisions (≤40 lines)

## JSON schema

```json
{
  "tool": "zellij",
  "role": "One-line description of the tool's job in this workspace",
  "config_sources": ["home/dot_config/zellij/config.kdl"],
  "hotkeys": [
    {
      "keys": "⌃⌥⌘ ←",
      "keys_raw": "ctrl+alt+cmd+left",
      "action": "Focus column left",
      "description": "Optional longer explanation; omit if action is self-evident",
      "category": "navigation",
      "mode": "global",
      "origin": "custom",
      "source": "home/dot_config/omniwm/settings.toml:12",
      "notes": ""
    }
  ]
}
```

## Field rules

- `keys`: human/print form. Use macOS symbols: ⌃ ⌥ ⌘ ⇧, arrows ← → ↑ ↓, ⏎ ⇥ ␣ ⎋. Hyper-3 (⌃⌥⌘, from Caps Lock via Karabiner) written as `⌃⌥⌘ X`.
- `keys_raw`: lowercase ascii, `+`-joined, e.g. `ctrl+alt+cmd+left`, `alt+h`, `<leader>sf` (vim notation OK for nvim).
- `action`: imperative, ≤6 words.
- `category`: lowercase-kebab, reuse across tools where sensible: `navigation`, `window-management`, `pane-management`, `tab-management`, `workspace`, `launcher`, `editing`, `search`, `lsp`, `git`, `session`, `misc`.
- `mode`: context where the key works. `global` if unconditional. Tool-specific values fine (`locked`, `normal`, `insert`, `visual`, `pane`, `tmux`…).
- `origin`: `custom` (set in dotfiles) | `default` (tool built-in, but actively used/important) | `plugin` (comes from installed plugin).
- `source`: repo-relative `file:line` for custom keys; `default` or plugin name otherwise.
- `notes`: conflicts, caveats, or empty string.

Include ALL custom bindings. Include defaults only if load-bearing for daily use (e.g. how to unlock zellij, how to open fzf history). Skip obscure defaults nobody uses.
