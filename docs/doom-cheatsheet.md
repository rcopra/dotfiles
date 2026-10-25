# Doom Emacs

Actions you also use in Neovim keep their Neovim keys. Clojure-only work uses
Doom's `,` localleader and evil-cleverparens' default keys. Keys are normal
state unless marked. `M-` is Option (either side). Pause after `SPC` or `,` and
which-key lists the next keys; `SPC h k` then a key shows what it does.

## Everyday

| Action | Shortcut |
| --- | --- |
| Switch project (opens its own workspace) | `SPC p p` |
| Find file in project | `SPC s f` or `SPC p f` |
| Find file by path | `SPC .` |
| Recent files | `SPC s o` |
| Switch buffer (this workspace) | `SPC SPC` |
| Kill buffer | `SPC b k` |
| Grep project / word under cursor | `SPC s g` / `SPC s w` |
| Search this buffer | `SPC /` |
| Resume last search | `SPC s r` |
| Commands (M-x) | `SPC s c` or `M-x` |
| Toggle project tree | `\` or `SPC o p` |
| Reveal current file in tree | `SPC o P` |
| Focus window left/down/up/right | `M-arrows` or `C-h/j/k/l` |
| Split right / below / close window | `C-w v` / `C-w s` / `C-w c` |
| Previous/next workspace | `M-S-Left/Right` |
| Workspace 1–9 | `M-1`–`M-9` |
| List / new / rename / delete workspace | `SPC TAB TAB` / `n` / `r` / `d` |
| Copy path relative to project | `SPC c p` |
| Open private config | `SPC s n` |

## LSP and code (shared with Neovim)

| Action | Shortcut |
| --- | --- |
| Go to definition | `grd` or `gd` |
| References | `grr` |
| Rename (saves changed files) | `grn` |
| Code action (normal or visual; saves changed files) | `gra` |
| Implementation / declaration / type | `gri` / `grD` / `grt` |
| Docs for symbol | `K` |
| Symbols in buffer / workspace | `gO` / `gW` |
| Format selection or buffer (leaves it unsaved) | `SPC f` |
| Next/previous diagnostic | `]e` / `[e` |
| Diagnostics list | `SPC s d` |
| Toggle inlay hints | `SPC t h` |

The first time you open a file in a new project, lsp-mode asks for the project
root: press `i` to import it.

## Clojure workflow

### A typical loop

1. `SPC p p` to the project, open a namespace.
2. `, c` connects to the REPL in `.nrepl-port`, or jacks in if there is none.
3. `, e f` loads the buffer, then work in a `(comment ...)` block: `RET` on a
   form evaluates it, `, e r` evaluates the top-level form under the cursor.
4. `, t v` jumps to the test file; `, t t` runs the test under the cursor,
   `, t n` the namespace, `, t r` reruns failures.
5. `, r r` refreshes changed namespaces when state gets stale.

### REPL

| Action | Shortcut |
| --- | --- |
| Connect to running REPL, or jack in | `, c` |
| Jack in (always start a new one) | `, '` |
| Show REPL buffer (opens as a popup) | `, r b` |
| REPL buffer and switch to this ns | `, r B` |
| Set REPL namespace to this file's | `, r n` |
| Clear REPL output | `, r c` |
| Refresh changed namespaces / all | `, r r` / `SPC u , r r` |
| Restart / quit REPL | `, r R` / `, r q` |
| Interrupt running eval | `, e i` |

### Evaluate

| Action | Shortcut |
| --- | --- |
| Form under cursor | `RET` or `, e e` |
| Element under cursor (symbol, literal) | `, e w` |
| Top-level form (inner form inside `comment`) | `, e r` or `, e d` |
| Selection | `, E` (visual) |
| Load buffer (saves first) | `, e f` or `, r l` |
| Eval buffer without saving | `, e b` |
| Replace form with its value | `, e !` |
| Top-level form, result as a comment | `, e c r` |
| Copy value / copy `form => value` | `, e y` / `, e Y` |
| Pretty-print top-level form / as comment | `, p d` / `, p D` |
| Undefine symbol | `, e u` |
| Macroexpand once / fully | `, m` / `, M` |

### Tests

| Action | Shortcut |
| --- | --- |
| Toggle test file and source | `, t v` |
| Test under cursor | `, t t` |
| Namespace tests | `, t n` |
| Project tests | `, t p` |
| Loaded tests | `, t l` |
| Rerun failed / rerun last test | `, t r` / `, t a` |

The report opens on the right; `q` closes it.

### Docs, inspect, debug

| Action | Shortcut |
| --- | --- |
| CIDER doc / ClojureDocs / Javadoc | `, h d` / `, h c` / `, h j` |
| Apropos | `, h a` |
| Browse namespace | `, n n` |
| Inspect value / last result | `, i i` / `, i r` |
| Instrument defun for debugging | `, d d` |
| Debugger: next / in / out / continue / quit | `n` / `i` / `o` / `c` / `q` |
| Debugger: eval / locals / inspect | `e` / `L` / `p` |

### Structural editing (evil-cleverparens)

Operators (`d`, `c`, `y`, `x`, `D`, `C`) never leave parens unbalanced.

| Action | Shortcut |
| --- | --- |
| Slurp / barf (direction depends on cursor at `(` or `)`) | `>` / `<` |
| Drag form down / up | `M-j` / `M-k` |
| Raise element / raise form | `M-r` / `M-R` |
| Splice (remove parens) / split / join | `M-s` / `M-S` / `M-J` |
| Transpose / convolute | `M-t` / `M-v` |
| Wrap next in `()` `{}` `[]` (square: GUI only) | `M-(` / `M-{` / `M-[` |
| Wrap previous in `()` `{}` `[]` | `M-)` / `M-}` / `M-]` |
| Insert at start / end of form | `M-i` / `M-a` |
| New line below / above form | `M-o` / `M-O` |
| Delete / change / yank element | `M-d` / `M-c` / `M-y` |
| Delete / change / yank enclosing form | `M-D` / `M-C` / `M-Y` |
| Duplicate form | `M-w` |
| Previous / next element | `H` / `L` |
| Up to enclosing `(` / past enclosing `)` | `(` / `)` |
| Start / end of defun | `M-h` / `M-l` |
| Re-indent defun | `M-q` |
| Text objects: form / defun / comment / element | `af if` / `ad id` / `ac ic` / `ae ie` |

## Git

| Action | Shortcut |
| --- | --- |
| Status | `SPC g s` |
| Blame | `SPC g b` or `SPC t b` |
| Diff working tree (definition in Clojure) | `SPC g d` |
| File / repo history | `SPC g f` / `SPC g h` |
| Diff / commits vs main | `SPC g m` / `SPC g c` |
| Next/previous hunk | `]c` / `[c` |
| Preview hunk | `SPC t D` |

## Different from before

- `SPC m` is gone; Clojure keys moved to `,` (`SPC e e` is now `, e e`).
- `>>` and `<<` slurp and barf in Clojure buffers instead of indenting; use
  `SPC f` or `M-q`.
- `H` and `L` move by form, not to the top and bottom of the window.
- `s` and `S` stay evil-snipe; `,` still repeats `f`/`t` outside Clojure buffers.
