# Keybinding inventory

Checked 2026-09-10. This reference includes the source cleanup below; deployment
status is recorded separately. It covers explicit bindings in this dotfiles repo, the separately
managed Neovim configuration, and the D50 firmware's cross-application bindings.
Application and plugin defaults are identified separately, not exhaustively
reproduced. This is not an inventory of every GUI application's preferences.

## Ownership and verification

| Layer | Configuration | Owns |
| --- | --- | --- |
| D50 firmware | `~/personal/zmk-config/docs/d50-map.md`, `draw/hillside_d50.yaml` | Physical positions, layers, combos, emitted chords |
| Laptop remapping | [Karabiner](../home/dot_config/private_karabiner/karabiner.json) | Caps tap/hold, Option remapping, device exclusions |
| Desktop | [OmniWM](../home/dot_config/omniwm/settings.toml) | Workspaces, windows, columns, monitors |
| Application launch | [Hammerspoon](../home/dot_hammerspoon/init.lua) | Launch/focus applications, new application windows |
| Terminal | [Ghostty](../home/dot_config/ghostty/config) | macOS chords and terminal translation |
| Multiplexer | [tmux](../home/dot_tmux.conf) | Projects/sessions, windows/tabs, panes, copy mode |
| Shell | [zsh](../home/dot_zshrc), [aliases](../home/dot_aliases) | Prompt editing, history, fuzzy pickers |
| Editor | `~/.config/nvim/init.lua`, `lua/custom/plugins/`, `lua/kickstart/plugins/` | Editing, search, Git, tests, debugging |

The deployed Karabiner, Hammerspoon, OmniWM, Ghostty, and tmux files matched
their source files. Deployed `.zshrc` differed, but its explicit `bindkey` lines
matched; no direct `bindkey` lines were found in `.zshrc.local`. That is not a
complete audit of code sourced by local shell configuration.

Subsequent source cleanup removed zsh's Alt+Shift+w forward-word alias, leaving
Alt+w intact and explicitly unbinding the uppercase chord so no Emacs default
action takes its place. It also removed tmux's Alt+n, Alt+Shift+r, and
Alt+Shift+d split aliases. These changes have not been deployed. Reloading an
existing tmux server does not clear bindings merely deleted from its config;
deployment must also unbind those three old root-table keys.

The running tmux root key table confirmed its direct bindings. Ghostty's CLI
reported the configured translations and inherited tab shortcuts (it also
printed `SentryInitFailed`). Neovim was inspected statically, including which
plugin modules are loaded. GUI hotkey registration, firmware currently flashed,
and end-to-end keypress behavior were not tested.

No explicit custom keybindings were found in gh-dash, gh CLI, Git, Powerlevel10k,
or `.zprofile`. The macOS defaults script sets repeat behavior, not shortcuts.
Forgit is sourced but defines no `bindkey` lines in the installed plugin;
its interactive pickers still inherit fzf behavior. The sessionizer also uses
fzf without its own `--bind` options.

## Notation and physical access

- **Alt** means Option. Ghostty sets `macos-option-as-alt = true`.
- **H3** means Ctrl+Alt+Cmd. **H4** means Ctrl+Alt+Shift+Cmd.
  OmniWM spells H4 `Hyper`; Hammerspoon's variable `hyper` means H3.
- **P** means press Ctrl+a, release, then press the following key (tmux prefix).
- **Leader** in Neovim means Space. Uppercase letters require Shift.
- **N/V/X/T** below mean Neovim normal/visual/visual/terminal modes; X excludes
  Select mode. Buffer-specific bindings require the relevant plugin/LSP attachment.

| Input | Laptop QWERTY | D50 Colemak DH |
| --- | --- | --- |
| H3 | Hold Caps Lock | Either outer raised key |
| Escape | Tap Caps Lock | W+F combo |
| Ctrl+a | Ctrl+a | Dedicated upper thumb on either half |
| Ctrl/Alt/Cmd/Shift | Physical modifiers | Hold A/R/S/T on left; O/I/E/N on right |
| Arrows | Physical arrows | Hold outer-left lower thumb for NAV; tap base N/E/U/I positions for left/down/up/right |
| Modified arrows | Modifier plus arrows | NAV has sticky Ctrl/Alt/Cmd/Shift at base A/R/S/T positions |
| Digits | Number row | Smart NUM on middle-right lower thumb: hold NUM, tap num-word, double-tap sticky NUM |
| Function keys | Laptop function row, subject to system Fn settings | Hold middle-left lower thumb for FN |

The local firmware source assigns **Cmd+arrow to the arrow key's hold action**
on NAV (`NAV_LEFT/RIGHT/UP/DOWN` in `config/base.keymap`). Holding the NAV thumb
alone does not add Cmd. Actual hold resolution depends on the configured
hold-tap behavior, and the user reports that observed behavior differs from
the earlier blanket claim. The flashed firmware and emitted events have not
been verified. If an arrow hold emits Cmd while Ctrl+Alt is active, its result
would match OmniWM's H3+Up/Down window-movement bindings; that is a conditional
configuration finding, not an observed collision.

N/E/U/I desktop directions preserve Colemak physical positions, not letter
mnemonics. They are scattered on QWERTY. Arrow bindings retain their directional
meaning on both setups, but D50 adds NAV activation. Letter commands such as
G for Ghostty or T for tab keep their mnemonic across layouts while moving
physically. Alt+digits also costs a NUM layer on D50.

Karabiner ignores the ZMK keyboard interface. Hammerspoon's config explains why
shared global hotkeys live there: remapping the dongle had disrupted ZMK's
modifier-morph reports. Karabiner's Option rule uses `lazy`; its description
alone does not establish that Option symbols are disabled in every macOS app.

## Desktop and application windows

OmniWM has **67 assigned hotkey entries and 102 unassigned entries**. Ranges in
this table group individual assignments. Action IDs disambiguate layout-specific
operations. Hammerspoon's five shortcuts are listed afterward.

| Shortcut | OmniWM action |
| --- | --- |
| Left Cmd+1–9 | Workspace 1–9 (`switchWorkspace.0`–`.8`) |
| Cmd+Shift+1–9 | Send window to workspace 1–9 |
| H3+Tab | Previous workspace / back-and-forth |
| H3+N/E/U/I | Focus left/down/up/right |
| H4+N/E/U/I | Move left/down/up/right |
| Alt+Tab | Focus previous window |
| Ctrl+Alt+Shift+Up/Down | Move window to workspace up/down |
| Ctrl+Alt+Shift+PageUp/PageDown | Move column to workspace up/down |
| H3+Up/Down | Move window up/down (`moveWindowUp/Down`) |
| H3+M | Focus next monitor |
| Ctrl+Cmd+grave | Focus last monitor |
| H3+F | Toggle fullscreen |
| H3+[/] | Move column left/right |
| Ctrl+Alt+Home/End | Move column to first/last |
| H3+T | Toggle column tabbed |
| Ctrl+Alt+1–9 | Focus column 1–9 |
| H3+period/comma | Cycle size forward/backward |
| H4+F | Toggle container full primary span |
| Ctrl+Alt+F | Expand container to available primary span |
| Ctrl+Alt+R | Reset window secondary span |
| H3+minus/equal | Decrease/increase container primary span by 10% |
| H4+minus/equal | Decrease/increase window secondary span by 10% |
| H4+B | Balance sizes |
| Ctrl+Alt+Space | Open command palette |
| H4+R | Raise all floating windows |
| H3+V | Toggle focused window floating |
| Ctrl+Alt+M | Open menu anywhere |
| H3+L | Toggle workspace layout |
| H3+O | Toggle overview |

OmniWM also configures Option mouse move/resize, Option+Shift scrolling, and
four-finger scrolling. Workspace swiping is disabled. These gestures share
modifier ownership with keyboard commands but are separate input events.

| Shortcut | Hammerspoon action |
| --- | --- |
| H3+G | Launch/focus Ghostty |
| H3+D | Launch/focus Discord |
| H3+W | New Safari window, or launch Safari if absent |
| H3+B | New Firefox window, or launch Firefox if absent |
| Alt+Enter | New Ghostty window, or launch Ghostty if absent |

The exact `Left Command` spelling on workspace focus is preserved above.
Confirm right-Cmd behavior in OmniWM before treating it as interchangeable.

## Terminal translation

All six explicit Ghostty keybind entries:

| Input | Result |
| --- | --- |
| Alt+Left/Right | Remove Ghostty's bindings so terminal applications receive the keys |
| Cmd+Alt+Up/Down | CSI `1;7A` / `1;7B`, tmux Ctrl+Alt+Up/Down |
| Cmd+D | Bytes Ctrl+a then `|`, tmux split right |
| Cmd+Shift+D | Bytes Ctrl+a then `-`, tmux split down |

These split translations run regardless of whether a tmux session is attached.
Outside tmux, their bytes reach the current program. Cmd+Alt session translations
also rely on tmux being the consumer.

Inherited Ghostty bindings relevant to ownership, verified with
`ghostty +list-keybinds`:

| Shortcut | Ghostty action |
| --- | --- |
| Ctrl+Tab / Ctrl+Shift+Tab | Next/previous Ghostty tab |
| Cmd+T | New Ghostty tab |
| Cmd+1–8 / Cmd+9 | Ghostty tab 1–8 / last tab; overlaps OmniWM's workspace keys |
| Cmd+Shift+[/] | Previous/next Ghostty tab |
| Cmd+[/] | Previous/next Ghostty split |
| Cmd+Alt+Left/Right | Focus Ghostty split left/right |
| Cmd+Ctrl+arrows | Resize Ghostty split |
| Cmd+Ctrl+equal | Equalize Ghostty splits |
| Cmd+Shift+Enter | Zoom Ghostty split |
| Cmd+Alt+W | Close Ghostty tab |
| Cmd+Alt+Shift+W | Close all Ghostty windows |
| Cmd+Shift+P | Ghostty command palette |

This leaves two tab systems available: Ghostty tabs and tmux windows. The
current project workflow uses tmux windows as tabs.

## tmux

The [daily tmux cheat sheet](tmux-cheatsheet.md) includes useful inherited prefix
bindings. This inventory lists every explicit keyboard binding in `.tmux.conf`.
Direct bindings are intercepted before the shell/editor; prefix bindings apply
after P. Copy-mode bindings apply only in that key table.

| Shortcut | Action |
| --- | --- |
| P, Ctrl+a | Send literal prefix to the pane |
| P, \| | Split right in current path |
| P, - | Split down in current path |
| P, arrows | Resize pane by 5 cells; repeatable |
| P, m / Alt+z | Zoom/unzoom |
| Alt+Shift+w | Kill pane with confirmation |
| P, r | Reload `.tmux.conf` |
| Alt+arrows | Navigate panes, or forward to Neovim when `@pane-is-vim` is set |
| P, c / Alt+t | New window in current path |
| Alt+Shift+t | Rename window |
| Alt+Shift+Left/Right | Previous/next window |
| Alt+i/o | Swap window with previous/next |
| Alt+1–9 | Select window 1–9 |
| P, Shift+j | Choose window and join its pane into current window |
| P, Shift+s | Choose destination and send current pane there |
| P, Shift+w | Choose window to swap with |
| P, q / Alt+q | Detach |
| Alt+s | Session/window tree (`choose-tree -Zw`) |
| P, s | Session tree (`choose-tree -Zs`) |
| Ctrl+Alt+Up/Down | Previous/next session |
| P, f / Alt+Shift+s | Project picker popup |
| P, Ctrl+d | Dotfiles session (`chezmoi/home`) |
| P, Ctrl+n | Neovim configuration session |
| P, Ctrl+w | Work-root session |
| P, Ctrl+p | Personal-root session |
| Copy mode: v | Begin selection |
| Copy mode: y / Enter | Copy selection and exit |
| Copy mode: Shift+Up/Down | Scroll up/down |

Explicit mouse bindings: left click selects a pane and forwards the mouse
event; ending a drag in vi copy mode copies the selection and exits. Mouse mode,
vi copy keys, clipboard support, and passthrough are enabled. The default Ctrl+b
prefix and prefix `%` / `"` split shortcuts are explicitly unbound.

## Shell and fuzzy pickers

Zsh selects Emacs editing mode, then applies these custom bindings:

| Shortcut | Action |
| --- | --- |
| Home (`ESC [ H` or `ESC [ 1 ~`) | Beginning of line |
| End (`ESC [ F` or `ESC [ 4 ~`) | End of line |
| Forward Delete (`ESC [ 3 ~`) | Delete character |
| Ctrl+Left/Right | Backward/forward word |
| Alt+w | Forward word; Colemak neighbor alias for Alt+f |
| Up/Down | History substring search up/down |
| Ctrl+f | Insert `~/bin/tmux-sessionizer` plus newline via `bindkey -s` |

Ctrl+f is a string macro, not a ZLE widget that saves/clears the current editing
buffer. Its interaction with a partially typed command deserves checking before
treating it as a context-independent launcher. It replaces Emacs forward-char;
inside tmux, Ctrl+a is also intercepted as the prefix.

Installed `fzf --zsh` adds Ctrl+t (file picker), Ctrl+r (history), Alt+c
(directory picker), and Tab (fzf completion). Within its history picker,
Ctrl+r toggles sort and Alt+r toggles raw display. Its shared picker options
ignore Ctrl+z. These are integration defaults, not explicit custom bindings.

The session aliases are commands, not chords: `tms` picker, `tmd` dotfiles,
`tmv` Neovim, `tmw` work root, and `tmp` personal root.

## Neovim

This configuration lives outside chezmoi. Tables cover active explicit mappings;
plugin defaults such as Telescope's internal picker keys and Diffview's buffer
maps are not duplicated. The optional `kickstart/plugins/gitsigns.lua` example
is **not loaded**; the active Gitsigns mappings are in `init.lua`.

| Shortcut | Mode | Action |
| --- | --- | --- |
| Esc | N | Clear search highlight |
| Esc Esc | T | Exit terminal mode |
| Ctrl+h/j/k/l | N | Focus Neovim split left/down/up/right |
| Alt+arrows | N | Smart-splits navigation, including tmux edge handoff |
| Ctrl+d/u or PageDown/PageUp | N | Half-page down/up and center |
| Leader cp | N | Copy relative file path |
| Leader q | N | Diagnostics location list (description calls it quickfix) |
| Leader f | N/V | Format buffer asynchronously |
| Backslash | N | Reveal current file in Neo-tree |
| Backslash in Neo-tree filesystem window | N | Close tree |

Search mappings are N unless noted:

| After Leader | Action |
| --- | --- |
| sh / sk / sf | Help / keymaps / files |
| ss | Telescope picker list |
| sw | Grep word/selection (N/V) |
| sg / sd | Live grep / diagnostics |
| sr / so / sc | Resume picker / recent files / commands |
| Space | Buffers |
| / | Fuzzy search current buffer |
| s/ | Live grep open files |
| sn | Find Neovim configuration files |
| gs | Telescope Git status |

LSP mappings require attachment; supported methods gate the Telescope mappings:

| Shortcut | Action |
| --- | --- |
| grn | Rename |
| gra | Code action (N/X) |
| grD | Declaration |
| grr / gri / grd | References / implementation / definition |
| grt | Type definition |
| gO / gW | Document / workspace symbols |
| Leader th | Toggle inlay hints when supported |

Git mappings are N, except hunk stage/reset also support V:

| Shortcut | Action |
| --- | --- |
| ]c / [c | Next/previous change (native diff movement when in diff mode) |
| Leader hs / hr | Stage/reset hunk or visual selection |
| Leader hS / hR | Stage/reset buffer |
| Leader hu | Calls `stage_hunk`; description says undo stage hunk |
| Leader hp / hb | Preview hunk / blame line |
| Leader hd / hD | Diff against index / last commit |
| Leader tb / tD | Toggle line blame / preview hunk inline |
| Leader gg / gb | Fugitive Git / blame |
| Leader gd | Diffview open |
| Leader gf / gh | File / repository history |
| Leader gm | Diffview `main...HEAD` |
| Leader gc | Commit history `main..HEAD` |

Tests and debugging (N):

| Shortcut | Action |
| --- | --- |
| Leader tn / tf / ts | Nearest test / file / suite |
| Leader tl / tv | Last test / visit last test file |
| F5 | Debug start/continue |
| F1 / F2 / F3 | Step into / over / out |
| F7 | Toggle debugger UI |
| Leader b / B | Toggle breakpoint / conditional breakpoint |

`mini.ai` explicitly changes next around/inside text objects to `aa` / `ii`.
`mini.surround` uses its default mappings. Blink completion explicitly selects
the `super-tab` preset. These plugins introduce further contextual bindings;
inspect their installed help and `:verbose map` before reclaiming keys.

## Firmware interactions

The canonical D50 map already inventories all layers, combos, leader sequences,
and physical extras. Keep that as the firmware reference rather than maintaining
a second full copy here. Relevant cross-tool emissions beyond H3 and Ctrl+a:

| Physical origin | Emitted input / result |
| --- | --- |
| NAV base P / F | Cmd+Tab app switcher / Shift+Tab |
| NAV base C / D | Ctrl+Shift+Tab / Ctrl+Tab; Ghostty currently handles these as native tabs |
| NAV arrow held | Cmd+arrow |
| NAV Backspace/Delete held | Alt+Backspace / Alt+Delete |
| Base X+D / X+C / C+D combos | Cmd+X / Cmd+C / Cmd+V |
| Base S+T | Firmware leader; A/O/U/S sequences emit ä/ö/ü/ß |
| Firmware leader USB / BLE | Select output transport |
| Firmware leader RESET / BOOT | Reset / bootloader |
| Base F+P combo | Smart mouse layer |
| Left upper outer thumb | F24; reserved dongle-screen use |
| Right upper inner thumb | KP_DIVIDE; canonical map says purpose unverified in repo |

The dotfiles AGENTS snapshot groups F24/KP_DIVIDE as screen keys; the canonical
D50 map only verifies F24's purpose. Resolve that documentation discrepancy
before reassigning KP_DIVIDE.

## Cleanup decisions

| Priority | Finding | Proposed next step |
| --- | --- | --- |
| 1 | NAV C/D reaches Ghostty tabs, while the navigation plan uses tmux windows | Decide whether NAV should address native tabs or tmux windows; then change one handler/emitter and update both repos' docs |
| 1 | Firmware source assigns Cmd+arrow on hold; actual behavior is disputed/unverified | Compare flashed firmware and emitted events before proposing any change |
| 2 | Cmd+digits is claimed by both OmniWM and Ghostty | Preserve desktop ownership if intentional; make the terminal reference explicitly favor Alt+digits |
| Done in source | Alt+Shift+w was shell forward-word outside tmux, pane kill inside tmux | Removed the uppercase shell typo alias; Alt+w and Ctrl+arrows remain |
| Done in source | Splits had three additional Alt aliases | Kept Cmd+d / Cmd+Shift+d and prefix pipe / minus; removed Alt+n, Alt+Shift+r, Alt+Shift+d |
| 2 | Ghostty retains native tabs/splits alongside translated tmux controls | Decide whether native tabs/splits remain part of the workflow before changing defaults |
| 2 | Neovim Alt+arrows only maps normal mode | Document normal-mode scope, or deliberately extend mode support |
| 3 | Neovim Leader+t group is called Toggle but includes tests | Separate the group naming or prefixes; preserve existing actions until a choice is made |
| 3 | OmniWM `Hyper` and Hammerspoon `hyper` denote different modifier sets | Use Hyper-3/Hyper-4 consistently in documentation and comments |
| 3 | The tmux cheat sheet omits direct project prefix shortcuts | Keep this complete inventory and the shorter daily sheet distinct |
| 3 | Ctrl+f uses an injected shell command; Leader+hu and Leader+q descriptions merit verification | Check actual behavior before changing implementation or labels |

The local macOS symbolic-hotkey settings disable Cmd+Shift+3/4 and enable
Ctrl+Cmd+Shift+3/4 plus Alt+Cmd+Shift+5. These do not exactly overlap OmniWM's
Cmd+Shift+digits. The settings do not prove event priority or cover every app's
global registrations. No keypresses were sent to test potentially destructive
or disruptive actions.

Suggested organization: keep settings in the application that owns them, with
this document as the cross-tool index. Within each editable config, use the
same ordering where applicable: focus, create/close, move, resize, pickers,
clipboard, maintenance. Keep plugin-dependent Neovim mappings with their plugin
setup. Preserve generated/application-owned formats such as OmniWM's TOML.

For later changes, verify the whole chain:

`physical key/layer → emitted chord → global interception → Ghostty translation → tmux table → shell/editor mode → action`

Check source/deployed diffs first, then use `ghostty +list-keybinds`,
`tmux list-keys -T root`, `tmux list-keys -T prefix`, and
`tmux list-keys -T copy-mode-vi`. In an existing shell, `bindkey -M emacs` shows
the effective editing map. In Neovim, Leader sk and `:verbose nmap` / `:verbose
imap` / `:verbose tmap` show effective mappings for the current context.
