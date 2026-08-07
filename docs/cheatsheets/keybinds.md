# Keybinds — full text reference

Printable versions: `hyper-desk-reference.html`, `zellij-desk-reference.html`,
`ghostty-shell-desk-reference.html` (shared `sheet.css`; `./make-pdfs.sh` → PDFs on
~/Desktop).

`⌃` Ctrl · `⌥` Alt/Option · `⇧` Shift · `⌘` Cmd · **Caps = ⌃⌥⌘ = hyper**
Sequences read left → right: `⌃g ⌃p f` = Ctrl+g, then Ctrl+p, then f.

Tier discipline: `⌃⌥⌘` windows · `⌃⌥` columns/sizing · `⌘1-9` workspaces ·
`⌘`+key Ghostty · `⌥`/`⌃` left to zellij, zsh, nvim.

## Zellij

Every `⌥` bind below works in **any mode**, locked included — they live in the
config's `shared` block. `F1` toggles a live tooltip of the real binds in-terminal.

### Panes
| Action | Keys |
|---|---|
| Focus pane | `⌥ ←↓↑→` |
| New pane | `⌥n` |
| New right | `⌥⇧r` |
| New below | `⌥⇧d` |
| Close pane | `⌥w` |
| **Fullscreen** | `⌥z` |
| Floating panes | `⌥⇧f` |
| Float ⇄ embed this pane | `⌥⇧e` |
| Resize ± | `⌥- ⌥=` |
| Rename pane | `⌃g ⌃p c` |

### Tabs
| Action | Keys |
|---|---|
| Go to tab | `⌥ 1-9` |
| Prev / next tab | `⌥⇧ ← →` |
| New tab | `⌥t` |
| **Rename tab** | `⌥⇧t` |
| Move tab | `⌥i ⌥o` |
| Close tab | `⌃g ⌃t x` |
| Last tab | `⌃g ⌃t ⇥` |
| Pane → own tab | `⌃g ⌃t b` |
| Pane → tab left / right | `⌃g ⌃t [ ]` |
| Sync input across tab's panes | `⌃g ⌃t s` |

Close pane (`⌥w`) closes the tab too when it's the tab's last pane — that's the
everyday path. `⌃g ⌃t x` is only for nuking a multi-pane tab in one shot.
`⌥←`/`⌥→` at a pane edge crosses into the adjacent tab.

### Sessions
| Action | Keys |
|---|---|
| Session manager | `⌥s` |
| Sessionizer (new/switch) | `⌥⇧s` |
| **Detach** | `⌥q` |
| Sessionizer (shell prompt only) | `⌃f` |
| Quit session | `⌃g ⌃q` |

Session-mode plugins (`⌃g ⌃o` then): `w` session manager · `d` detach ·
`c` configuration · `p` plugin manager · `l` layout manager · `s` share · `a` about.

### Scroll / scrollback
| Action | Keys |
|---|---|
| **Scroll mode** | `⌃s` then `j k d u` |
| Page up / down in scroll mode | `⌃b ⌃f` (also `h l`) |
| Bottom + relock | `⌃s ⌃c` |
| Search scrollback | `⌃s s` → `⏎` → `n`/`p` |
| Toggle case / whole word / wrap | `c` / `o` / `w` (in search) |
| **Scrollback → nvim** | `⌥e` (or `⌃s e`) |
| Leave scroll mode | `⏎` or `esc` |

Mouse drag-select is capped to one viewport — zellij owns the scrollback, so
Ghostty's own buffer is empty. To copy across scrollback use `⌥e`, then `V`/`y`
in nvim. `⇧`+drag gives Ghostty-native selection of the visible screen.

### Modes (`⌃g` unlocks first)
| Mode | Keys |
|---|---|
| Normal ⇄ locked | `⌃g` |
| Pane | `⌃g ⌃p` |
| Tab | `⌃g ⌃t` |
| Resize | `⌃g ⌃n` |
| Move | `⌃g ⌃h` |
| Session | `⌃g ⌃o` |
| Scroll | `⌃s` (direct from locked) |
| tmux compat | `⌃g ⌃b` |
| Back to locked | `esc` or `⏎` |

Pane mode (`⌃g ⌃p` then): `n d r s` new auto/below/right/stacked · `c` rename ·
`x` close · `f` fullscreen · `hjkl`/arrows focus · `p` next pane ·
`w` floating · `e` embed⇄float · `i` pin · `z` frames.

### Precision resize / move
| Action | Keys |
|---|---|
| Resize mode | `⌃g ⌃n` then `←↓↑→` or `hjkl` (grow), `HJKL` (shrink), `+ -` |
| Move pane | `⌃g ⌃h` then `hjkl`; `⇥`/`p` next/prev slot |
| Swap layout | `⌃g ⌥[ ⌥]` |
| Pane group / group marking | `⌃g ⌥p` / `⌃g ⌥⇧p` |

`⌃n` and `⌃o` are deliberately *not* bound in locked mode — they'd shadow nvim's
`<C-n>` and jumplist `<C-o>`. Same reason `⌥f`/`⌥d` are unused: zsh
`forward-word` / `kill-word`. `⌥[`/`⌥]` stay out of locked because `⌥[` is
ambiguous with the CSI prefix at a shell.

## OmniWM

### Workspaces
| Action | Keys |
|---|---|
| Go to workspace | `⌘ 1-9` |
| Send window to workspace | `⇧⌘ 1-9` (follows) |
| Send window silently | `⇧⌘⌥ 1-9` |
| Send window to workspace ↑ / ↓ | `⌃⌥⇧ ↑ ↓` |
| Send whole column to workspace ↑ / ↓ | `⌃⌥⇧ PgUp PgDn` |
| Last workspace | `Caps ⇥` |
| Niri ⇄ dwindle layout | `Caps l` |
| Overview | `Caps o` |

### Windows — N E U I = ← ↓ ↑ →
| Action | Keys |
|---|---|
| Focus | `Caps n e u i` |
| Move window | `⇧ Caps n e u i` |
| Last window | `` Caps ` `` |
| Column in / out | `Caps ← →` |
| Reorder within column | `Caps ↑ ↓` |
| Move column | `Caps [ ]` |
| Column → first / last | `⌃⌥ Home End` |
| Focus column | `⌃⌥ 1-9` |
| Tabbed column | `Caps t` |
| Next monitor | `Caps m` |
| Last monitor | `` ⌃⌘ ` `` |

### Size / toggles
| Action | Keys |
|---|---|
| Fullscreen | `Caps f` |
| Window fills column width | `⇧ Caps f` |
| Expand column into free space | `⌃⌥ f` |
| Cycle column width | `Caps . ,` |
| Column ± 10% | `Caps - =` |
| Window height ± 10% | `⇧ Caps - =` |
| Reset window height | `⌃⌥ r` |
| Balance sizes | `⇧ Caps b` |
| Float window | `Caps v` |
| Raise all floating | `⇧ Caps r` |
| Command palette | `⌃⌥ Space` |
| Menu anywhere | `⌃⌥ m` |

## Launch (Karabiner)
| Action | Keys |
|---|---|
| Ghostty, new window | `⌥ ⏎` |
| Ghostty / Safari / Firefox / Slack / Discord | `Caps g w b s d` |
| Hyper itself | hold Caps Lock (tap = Esc) |

## Ghostty

`⌘` binds are consumed by Ghostty — zellij, zsh and nvim never see them. Splits
and tabs here are *Ghostty's*; inside a session prefer the zellij `⌥` tier
(survives detach, nvim-aware).

| Action | Keys |
|---|---|
| New window / tab | `⌘n` / `⌘t` |
| Close surface / tab / window | `⌘w` / `⌘⌥w` / `⌘⇧w` |
| Go to tab / last tab | `⌘1-8` / `⌘9` |
| Prev / next tab | `⌘⇧[ ⌘⇧]` (also `⌃⇥`) |
| Fullscreen | `⌘⏎` |
| Split right / down | `⌘d` / `⌘⇧d` |
| Prev / next split | `⌘[ ⌘]` |
| Focus split by direction | `⌘⌥ ←↓↑→` |
| Resize / equalize / zoom split | `⌘⌃ ←↓↑→` / `⌘⌃=` / `⌘⇧⏎` |
| Copy / paste / select all | `⌘c` / `⌘v` / `⌘a` |
| Native selection (bypass zellij mouse) | `⇧`+drag |
| Adjust selection | `⇧ ←↓↑→` (also PgUp/Dn, Home/End) |
| Clear screen / search | `⌘k` / `⌘f` |
| Screen → file: paste path / copy / open | `⌘⇧j` / `⌘⌃⇧j` / `⌘⌥⇧j` |
| Jump to prev / next prompt | `⌘↑` / `⌘↓` |
| Scroll top / bottom / page | `⌘Home` / `⌘End` / `⌘PgUp PgDn` |
| Font bigger / smaller / reset | `⌘=` / `⌘-` / `⌘0` |
| Command palette | `⌘⇧p` |
| Open / reload config | `⌘,` / `⌘⇧,` |
| Quit | `⌘q` |

Scroll and prompt-jump binds act on Ghostty's own buffer, which stays empty
inside zellij — use `⌃s` and `⌥e` instead.

Non-default config lines: titlebar hidden · `theme = light:Catppuccin
Latte,dark:Catppuccin Mocha` (live switch) · `macos-option-as-alt = true` ·
`option+left`/`option+right` unbound so Alt+arrow CSI reaches zellij/nvim ·
`quit-after-last-window-closed`. Full list: `ghostty +list-keybinds`.

## Shell (zsh)

| Action | Keys |
|---|---|
| History substring search | `↑ ↓` |
| fzf history | `⌃r` |
| fzf file picker | `⌃t` |
| fzf cd into subdir | `⌥c` |
| **Zellij sessionizer** | `⌃f` |
| Accept autosuggestion | `→` or `⌃e` |
| Word forward / kill word | `⌥f` / `⌥d` |
| Line start / kill to end / kill line / kill word | `⌃a` / `⌃k` / `⌃u` / `⌃w` |
| fzf fuzzy completion | `**` then `⇥` |

Sessions: `tms` pick anywhere · `tmd` dotfiles ·
`tmw` ~/work · `tmp` ~/personal · `tmv` ~/.config/nvim.

Dirs/files: `cd` = zoxide `z` · `zi` interactive picker · `ls la ll lla lt` eza
variants · `cd -` previous dir.

git (forgit, all interactive): `ga` stage · `gd`/`gso` diff/show · `glo`/`grl`
log/reflog · `gcf`/`grh` checkout file / reset HEAD · `gcb gsw gbd` branch
checkout/switch/delete · `gss`/`gsp` stash show/push · `gfu gsq grw`
fixup/squash/reword · `grb gcp grc` rebase/cherry-pick/revert · `gclean` ·
`gbl` blame.

## Collision map
| Tier | Owner |
|---|---|
| `⌃⌥⌘` (hyper) | OmniWM / Karabiner — never reaches apps |
| `⌃⌥` | OmniWM columns, sizing, palette |
| `⌘`+key | Ghostty (plus `⌘1-9` → OmniWM workspaces) |
| `⌥`+key | zellij `shared` binds; `⌥f ⌥d ⌥c` left to zsh/fzf |
| `⌃`+key | shell, except `⌃g` and `⌃s` which zellij takes in locked mode |
