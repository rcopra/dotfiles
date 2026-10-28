# Keybinding inventory

Checked 2026-09-10; multiplexer sections updated 2026-10-20 for Herdr and 2026-10-28 for Rex. This reference includes the source cleanup below; deployment
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
| Multiplexer | [Rex](../home/dot_config/rex/init.lua); [Herdr](../home/dot_config/herdr/config.toml) and [tmux](../home/dot_tmux.conf) still configured | Projects/sessions, tabs, panes |
| Shell | [zsh](../home/dot_zshrc), [aliases](../home/dot_aliases) | Prompt editing, history, fuzzy pickers |
| Editor | `~/.config/nvim/init.lua`, `lua/custom/plugins/`, `lua/kickstart/plugins/` | Editing, search, Git, tests, debugging |
| Clojure editor | [Doom Emacs](../home/dot_config/doom/config.el) (GUI) | Clojure REPL work; mirrors Neovim for shared actions, Doom's `,` localleader for Clojure |

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
- **P** means press Ctrl+a, release, then press the following key (Herdr prefix; tmux uses the same).
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
operations. Hammerspoon's six shortcuts are listed afterward.

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
| H3+X | Launch/focus Emacs |
| H3+W | New Safari window, or launch Safari if absent |
| H3+B | New Firefox window, or launch Firefox if absent |
| H3+Enter | New Ghostty window, or launch Ghostty if absent |

The exact `Left Command` spelling on workspace focus is preserved above.
Confirm right-Cmd behavior in OmniWM before treating it as interchangeable.

## Terminal passthrough

All six explicit Ghostty keybind entries:

| Input | Result |
| --- | --- |
| Alt+Left/Right | Remove Ghostty's bindings so terminal applications receive the keys |
| Cmd+Alt+Up/Down | Remove Ghostty's `goto_split` bindings so Herdr receives Alt+Super+Up/Down |
| Cmd+D / Cmd+Shift+D | Remove Ghostty's split bindings so Herdr receives the chords |

Herdr requests enhanced keyboard reporting, so the unbound Cmd+Alt chord arrives
with Super intact and matches its `cmd+alt` binding directly. Cmd+Shift+Up/Down
remains Ghostty's `jump_to_prompt`. tmux has no Super modifier binding, so its
session navigation remains on Ctrl+Alt+Up/Down. Without Herdr, Cmd+D does
nothing: Ghostty's own splits are unbound globally.

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

This leaves two tab systems available: Ghostty tabs and Herdr tabs. The
current project workflow uses Herdr tabs.

## Rex

Rex is the active multiplexer. [`init.lua`](../home/dot_config/rex/init.lua)
adds chords on top of Rex's built-in shortcuts and overrides none of them.
`rex config check` validates it; `rex keymap` lists what it loaded. Sessions
hold tabs, which hold panes.

Added in `init.lua`:

| Shortcut | Action |
| --- | --- |
| Cmd+Alt+arrows | Focus pane; in Neovim, forwards Alt+arrow to smart-splits (smart-splits-backend-rex), which hands back at an edge |
| Alt+Shift+Left/Right | Previous/next tab |
| Alt+Shift+Up/Down | Previous/next session |
| Alt+Shift+s | Project picker in a floating pane (`rex-sessionizer`) |

Rex defaults in use (not reproduced exhaustively):

| Shortcut | Action |
| --- | --- |
| Ctrl+Tab / Ctrl+Shift+Tab; Cmd+Shift+] / [ | Next/previous tab |
| Cmd+T / Cmd+Alt+W | New tab / close tab |
| Cmd+1–9 | Select tab (Right Cmd only; OmniWM owns Left Cmd+digits) |
| Ctrl+Shift+PageUp/PageDown | Move tab |
| Cmd+D / Cmd+Shift+D | Split right / down |
| Cmd+Shift+arrows | Split in that direction |
| Cmd+Alt+Shift+arrows | Move pane |
| Cmd+] / Cmd+[ | Next/previous pane |
| Cmd+Shift+Enter / Cmd+Alt+Enter | Zoom / float pane |
| Cmd+W | Close pane |
| Cmd+K / Cmd+Shift+N | Session picker / new session |
| Cmd+Shift+P | Command palette |
| Cmd+Left/Right, Cmd+Backspace | Send Ctrl+a / Ctrl+e / Ctrl+u |
| Alt+Left/Right | Send Alt+b / Alt+f |

Pane resize is by dragging dividers.

## Herdr

Herdr stays configured but is no longer the active multiplexer. This lists every explicit binding in
[`config.toml`](../home/dot_config/herdr/config.toml); `herdr config check`
validates it. Direct bindings are intercepted before the shell/editor; prefix
bindings apply after P.

| Shortcut | Action |
| --- | --- |
| Alt+arrows | Navigate panes across Neovim splits (herdr-splits plugin) |
| Cmd+D / Alt+n / Alt+Shift+r / P, \| | Split right |
| Cmd+Shift+D / Alt+Shift+d / P, - | Split down |
| P, o / P, ; | Next pane / last pane |
| P, arrows / P, Shift+r | Resize pane / resize mode |
| Alt+z / P, m / P, z | Zoom/unzoom |
| Alt+Shift+w / P, x | Close pane |
| Alt+e / P, e | Edit scrollback |
| Alt+t / P, c | New tab |
| Alt+Shift+t / P, comma / P, Shift+t | Rename tab |
| Alt+Shift+Left/Right / P, p / P, n | Previous/next tab |
| Alt+i/o | Move tab left/right |
| Alt+1–9 / P, 1–9 | Select tab 1–9 |
| P, & / P, Shift+x | Close tab |
| Cmd+Alt+Up/Down / P, [ / P, ] | Previous/next agent |
| P, Alt+1–9 | Focus agent 1–9 |
| Alt+Shift+Up/Down / Ctrl+Alt+Up/Down | Previous/next workspace |
| Alt+s / P, w / P, g | Go-to picker |
| P, s | Workspace picker |
| Alt+Shift+s | Project picker popup (`herdr-sessionizer`) |
| Alt+q / P, d / P, q | Detach |
| P, Shift+s / P, r | Settings / reload config |

## tmux (fallback)

tmux stays installed with its config, but no shell entry point starts it; run
`tmux` directly. The chords match Herdr's where both have the action.

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
| Ctrl+f | Insert `~/bin/rex-sessionizer` (inside Rex) or `~/bin/herdr-sessionizer` plus newline via `bindkey -s` |

Ctrl+f is a string macro, not a ZLE widget that saves/clears the current editing
buffer. Its interaction with a partially typed command deserves checking before
treating it as a context-independent launcher. It replaces Emacs forward-char;
inside Herdr, Ctrl+a is also intercepted as the prefix.

Installed `fzf --zsh` adds Ctrl+t (file picker), Ctrl+r (history), Alt+c
(directory picker), and Tab (fzf completion). Within its history picker,
Ctrl+r toggles sort and Alt+r toggles raw display. Its shared picker options
ignore Ctrl+z. These are integration defaults, not explicit custom bindings.

The Herdr workspace aliases are commands, not chords: `tms` picker, `tmd` dotfiles,
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
| Alt+arrows | N | Split navigation with edge handoff: herdr-splits in Herdr, smart-splits v3 in tmux and Rex (Rex sends these for Cmd+Alt+arrows) |
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

## Doom Emacs

GUI Emacs (emacs-plus) running Doom, used for Clojure. Checked 2026-10-23
against a test Doom daemon with clojure-lsp (lsp-mode) and a live CIDER REPL.
Both Options are Meta (Doom's default leaves right Option typing characters).

The config is a thin layer over Doom's defaults, modelled on Eric Dallo's
(clojure-lsp's author). Actions used in both editors mirror Neovim, replacing
Doom's binding on collision: Telescope's `SPC s` keys, `SPC SPC` buffers,
`SPC /` buffer search, `SPC f` format, Neovim's `gr*` LSP keys, `]c` / `[c`
hunks, `C-h/j/k/l` window focus, Fugitive/Diffview `SPC g` keys, and `\` for
the file tree. Clojure-only work follows Doom under the `,` localleader, and
structural editing uses evil-cleverparens' own keys. Kept as Doom's: `SPC h`
(help, where Neovim has gitsigns hunks), `SPC q` (quit menu), Page Up/Down
(no recentering), and evil-snipe on `s`/`S` (two-character jump), so surround
is vim-surround's `ys` / `ds` / `cs` rather than mini.surround's `sa` / `sd` /
`sr`. `config.el` has the full list; the user-facing reference is `EMACS.md` in
`~/personal/clojure-challenges`.

| Shortcut | State | Action |
| --- | --- | --- |
| Alt+arrows | Normal | Focus window (windmove); no multiplexer handoff in GUI Emacs |
| Alt+Shift+Left/Right | Normal | Previous/next Doom workspace |
| Alt+1–9 | Any | Select Doom workspace (Doom default) |
| Backslash | Normal | Toggle the treemacs project tree (also `SPC o p`; `SPC o P` reveals the current file) |
| SPC p p | Normal | Switch project, opening it in its own workspace |

### Clojure

`,` is the localleader in place of Doom's `SPC m`. evil-snipe no longer takes
`,` and `;`, so outside localleader buffers `,` repeats `f`/`t` backwards as in
Vim; in Clojure buffers repeat a find by pressing `f`/`F`/`t`/`T` again.
Doom's localleader map covers jack-in (`, '`), tests (`, t t` at point, `, t n`
namespace, `, t p` project, `, t l` loaded, `, t r` rerun failures), the REPL
(`, r b` buffer, `, r q` quit, `, r r` refresh changed namespaces; `SPC u , r r`
refreshes all) and the debugger (`, d d`). The REPL opens as a bottom popup that
ESC leaves open; the test report opens on the right. Overrides and additions:

| Shortcut | Action |
| --- | --- |
| , c | Connect to the project's running REPL (`.nrepl-port`), else jack in (replaces Doom's connect) |
| , e e / e r / e w | Evaluate form under cursor / root form / element (Conjure's letters; replaces Doom's `e e` / `e r`) |
| , e b / e f | Evaluate buffer / load file (saves first) |
| , e ! | Replace form with its value |
| , e c r | Evaluate root form into a comment |
| , e y / e Y | Copy the form's value / "form => value" |
| , e i | Interrupt evaluation |
| , E (visual) | Evaluate selection |
| RET | Evaluate form under cursor (normal state) |
| , t v | Toggle between test and source file |

Forms inside `(comment ...)` count as top level, so `, e r` evaluates the form
under the cursor in a rich comment block. clojure-lsp owns navigation, rename,
completion and diagnostics; CIDER's go-to-definition is off. Renames and code
actions save the files they change; formatting does not.

Structural editing is evil-cleverparens with its default keys (normal state
unless noted):

| Shortcut | Action |
| --- | --- |
| < / > | Slurp or barf, depending on whether the cursor is on an opening or closing paren |
| M-j / M-k | Drag element forward / backward |
| M-r / M-R | Raise element / raise enclosing form |
| M-s / M-S / M-J | Splice / split / join |
| H / L | Previous / next form (N/V/O) |
| ( / ) | Enclosing form start / end (N/V/O) |
| W / B / E / gE | Next symbol start / previous symbol start / symbol end / previous symbol end |
| af / if, ad / id, ie / ae | Form, top-level form, element text objects (V/O); element is kept from nvim-paredit |
| M-( / M-{ / M-[ | Wrap the next element in parens / braces / brackets |

`d`, `c`, `y`, `x` and `D` keep parens balanced. Because `<` and `>` slurp and
barf, `>>`, `<<` and `>ip` don't indent in Clojure buffers; formatting (`SPC f`)
covers indentation. cleverparens' `[` / `]` paren motions are unbound so
`]c` / `[c` and Doom's other bracket pairs keep working; `s` / `S` stay
evil-snipe's.

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
| 1 | NAV C/D reaches Ghostty tabs, while the navigation plan uses Herdr tabs | Decide whether NAV should address native tabs or Herdr tabs; then change one handler/emitter and update both repos' docs |
| 1 | Firmware source assigns Cmd+arrow on hold; actual behavior is disputed/unverified | Compare flashed firmware and emitted events before proposing any change |
| 2 | Cmd+digits is claimed by both OmniWM and Ghostty | Preserve desktop ownership if intentional; make the terminal reference explicitly favor Alt+digits |
| Done in source | Alt+Shift+w was shell forward-word outside tmux, pane kill inside tmux | Removed the uppercase shell typo alias; Alt+w and Ctrl+arrows remain |
| Done in source | Splits had three additional Alt aliases | Kept Cmd+d / Cmd+Shift+d and prefix pipe / minus; removed Alt+n, Alt+Shift+r, Alt+Shift+d |
| 2 | Ghostty retains native tabs alongside Herdr's (its splits are unbound) | Decide whether native tabs/splits remain part of the workflow before changing defaults |
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

`physical key/layer → emitted chord → global interception → Ghostty translation → multiplexer binding → shell/editor mode → action`

Check source/deployed diffs first, then use `ghostty +list-keybinds`,
`herdr config check`,
and for the tmux fallback `tmux list-keys -T root`, `tmux list-keys -T prefix`, and
`tmux list-keys -T copy-mode-vi`. In an existing shell, `bindkey -M emacs` shows
the effective editing map. In Neovim, Leader sk and `:verbose nmap` / `:verbose
imap` / `:verbose tmap` show effective mappings for the current context.
