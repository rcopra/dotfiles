## Keybind Planning

I regularly switch between two keyboard setups:

- Laptop: built-in keyboard using QWERTY.
- Docked: Hillside Dactyl50 split keyboard running ZMK with Colemak DH.

When proposing keybindings:

- Consider usability on both layouts, including the physical cost of holding
  modifiers and accessing layers.
- Distinguish bindings chosen for their letter from those chosen for their
  physical position. Explain ergonomic tradeoffs between the two setups.
- Plan across ZMK, macOS/global shortcuts, Karabiner, the terminal, the
  multiplexer, and the editor. Even an application-specific request (such as a
  Herdr binding) should fit this overall navigation model.
- Trace the physical key/layer → emitted chord → global interception → terminal
  translation → application action before choosing where a change belongs.
- Read the relevant configuration when a proposal depends on exact mappings;
  ask for missing layer or modifier details when they cannot be found locally.

### Keyboard access reference

Physical/emitted source of truth: `~/personal/zmk-config/docs/d50-map.md` (plus
the generated `~/personal/zmk-config/draw/hillside_d50.yaml`). If this section
disagrees with the zmk map, the zmk map wins — update this snapshot.

Snapshot of the local ZMK and Karabiner configuration, checked 2026-09-10:

- Home-row holds on Colemak: `A/R/S/T` → Ctrl/Alt/Cmd/Shift on the left;
  `N/E/I/O` → Shift/Cmd/Alt/Ctrl on the right. These use hold-tap behaviors.
- Left bottom thumbs, outer → inner: outer = tap Space / hold NAV; middle = tap
  Enter / hold FN; inner = unbound. Right bottom thumbs, inner → outer: Space,
  Smart NUM (tap num-word / hold NUM / double-tap sticky NUM), Magic Shift (tap
  sticky Shift / hold Shift).
- NAV puts Left/Down/Up/Right at the base-layer `N/E/U/I` positions. Left-hand
  `A/R/S/T` positions become sticky Ctrl/Alt/Cmd/Shift. Holding a NAV arrow emits
  Cmd+arrow, so tapping and holding are distinct when planning shortcuts.
- Dedicated raised keys on both halves emit Ctrl+Alt+Cmd. Upper thumb keys on
  both halves include one multiplexer-prefix key, Ctrl+a (the other emits F24 / KP_DIVIDE
  for the dongle screen).
- Laptop Caps Lock taps Escape and holds Ctrl+Alt+Cmd through Karabiner.
  Call this three-modifier chord **Hyper-3** here. OmniWM's configured `Hyper`
  includes Shift as well: Ctrl+Alt+Shift+Cmd.

### Current navigation ethos and map

This is a working plan, open to revision. Use it as the starting point for
consistent muscle memory across tools. Propose departures with their tradeoffs
and affected layers, and update this reference when the plan changes. The map
records configured intent; confirm deployed settings when diagnosing behavior.

The organizing idea is scope: text movement within a pane, focus between panes,
tabs within a terminal session, sessions for projects, and desktop windows and
workspaces above those. Prefer consistent directional actions across tools.

| Scope / intent | Current chord | Handler / meaning |
| --- | --- | --- |
| Shell text movement | Ctrl+Left/Right | Zsh backward/forward word |
| Terminal pane / editor split focus | Alt+arrows | Ghostty passes through; Herdr and Neovim coordinate focus across split edges (herdr-splits) |
| Doom Emacs window / workspace focus | Alt+arrows; Alt+Shift+Left/Right; Alt+1–9 | Normal state only. GUI Emacs, so no multiplexer handoff; leave it with Hyper-3+N/E/U/I |
| Terminal tab (Herdr tab) focus | Alt+Shift+Left/Right; Alt+1–9 | Previous/next tab; select numbered tab |
| Agent pane focus | Cmd+Option+Up/Down | Herdr previous/next agent |
| Terminal workspace focus | Alt+Shift+Up/Down | Herdr previous/next workspace; Ctrl+Alt+Up/Down remains an alias (and the tmux session chord) |
| Project / workspace picker | Ctrl+f at shell; Alt+Shift+s in Herdr | Project picker (`herdr-sessionizer`); Alt+s opens Herdr's goto |
| Terminal pane resize | Ctrl+a, then arrows | Herdr prefix followed by a direction |
| Desktop window focus | Hyper-3+N/E/U/I | OmniWM left/down/up/right; Alt+Tab focuses the previous window |
| Desktop window move | Hyper-3+Shift+N/E/U/I | OmniWM moves in the corresponding direction |
| Desktop workspace focus / move | Cmd+1–9 / Cmd+Shift+1–9 | OmniWM switches workspace / sends the window there |
| Desktop monitor focus | Hyper-3+M | OmniWM focuses the next monitor |
| New terminal window | Hyper-3+Enter | Hammerspoon opens a Ghostty window, launching Ghostty if needed |

Alt means macOS Option; Ghostty is configured to send Option as Alt. Desktop
shortcuts can intercept application bindings (for example Cmd+digits), so check
global ownership before assigning a chord inside an application. The desktop
`N/E/U/I` directions match the Colemak NAV positions but have different physical
reach on QWERTY; retain that tradeoff in planning.

### Where to verify a proposed change

- Physical/emitted keymap map: `~/personal/zmk-config/docs/d50-map.md` (canonical;
  generated view in `draw/hillside_d50.yaml`). The firmware sources below are
  source mappings, not proof of what is currently flashed.
- Firmware: `~/personal/zmk-config/config/base.keymap` for shared layers and
  behaviors, and `config/hillside_d50.keymap` in that checkout for physical thumb
  and extra-key assignments.
- Global remapping and desktop navigation:
  `home/dot_config/private_karabiner/karabiner.json` and
  `home/dot_config/omniwm/settings.toml`; also check relevant macOS/app global
  shortcuts when assessing collisions.
- Terminal and shell: `home/dot_config/ghostty/config`, `home/dot_zshrc`, and
  `home/dot_config/herdr/config.toml`. The current repo workflow is Ghostty +
  Herdr. tmux (`home/dot_tmux.conf`) stays installed as a fallback with the same
  chords; check the active multiplexer when diagnosing behavior.
- Editor split handoff: `~/.config/nvim/lua/custom/plugins/splits.lua`, managed
  outside this repo; it uses herdr-splits.nvim inside Herdr and smart-splits.nvim
  elsewhere. Fallback tmux actions are in `docs/tmux-cheatsheet.md`.
- Doom Emacs (GUI, for Clojure): `home/dot_config/doom/config.el` holds the
  keymaps. Doom core in `~/.config/emacs` is an unmanaged clone. Keys mirror
  the Neovim config 1:1 where possible (Telescope, LSP, git, tests, Conjure,
  nvim-paredit), overriding Doom defaults; when a Neovim binding changes, update
  the matching Doom key. See `docs/keybindings.md`.

When a ZMK binding changes, check whether the workflow table above moves with
it. When a handler binding changes, check the physical origin in the zmk map
before editing. Update both docs when the cross-tool contract changes.
