;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin
      catppuccin-flavor 'mocha)  ; matches Ghostty's Catppuccin Mocha
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;; macOS

;; Right Option is Meta too, like left Option, Karabiner and Ghostty.
(setq mac-right-option-modifier 'meta
      ns-right-option-modifier 'meta)


;;; Navigation (see AGENTS.md in chezmoi for the cross-tool map)

;; PageUp/PageDown move to the first/last line once a full page can't scroll.
(setq scroll-error-top-bottom t)

;; Alt+arrows focus windows, like Neovim splits; Alt+Shift+Left/Right cycle
;; workspaces, like tmux tabs (Doom already selects them with Alt+1-9).
(map! :n "M-<left>"    #'windmove-left
      :n "M-<down>"    #'windmove-down
      :n "M-<up>"      #'windmove-up
      :n "M-<right>"   #'windmove-right
      :n "M-S-<left>"  #'+workspace/switch-left
      :n "M-S-<right>" #'+workspace/switch-right)

;; \ toggles the project tree, like Neo-tree in Neovim (also SPC o p; SPC o P
;; reveals the current file). Use it to look around, not as a fixed sidebar.
(map! :n "\\" #'+treemacs/toggle)

;; Hide ls details in every dirvish buffer (dirvish's default), not just the
;; full frame as Doom sets it. ( toggles them.
(after! dirvish
  (setq dirvish-hide-details t))



;;; Neovim keymap parity

;; Actions used in both editors (search, LSP, git, splits) mirror ~/.config/nvim,
;; replacing Doom's binding where they collide. Clojure-only work (REPL, eval,
;; tests, structural editing) follows Doom and the localleader instead; see the
;; Clojure sections below. Kept as Doom's on purpose: SPC h (help, where Neovim
;; has gitsigns hunks), SPC q (quit menu; Neovim's diagnostics list is also on
;; SPC s d) and PageUp/PageDown (no recentering, set above).

(setq evil-vsplit-window-right t        ; splitright
      evil-split-window-below t         ; splitbelow
      scroll-margin 10                  ; scrolloff
      which-key-idle-delay 0.3)         ; timeoutlen

(defun +nvim/format ()
  "Format the selection or buffer with the language server, like <leader>f."
  (interactive)
  (if (use-region-p)
      (lsp-format-region (region-beginning) (region-end))
    (lsp-format-buffer)))

(defun +nvim/diff-or-definition ()
  "<leader>gd: Conjure's go-to-definition in Clojure, Diffview elsewhere."
  (interactive)
  (if (derived-mode-p 'clojure-mode)
      (call-interactively #'+lookup/definition)
    (call-interactively #'magit-diff-working-tree)))

(defun +nvim/diff-vs-main ()
  "What this branch changes, like DiffviewOpen main...HEAD."
  (interactive)
  (magit-diff-range "main...HEAD"))

(defun +nvim/log-vs-main ()
  "This branch's commits, like DiffviewFileHistory --range=main..HEAD."
  (interactive)
  (magit-log-other '("main..HEAD")))

(defun +nvim/repl-connect ()
  "Get a REPL for this project, like Conjure's <localleader>cf.
Connect to the running REPL named in .nrepl-port (or lein/shadow-cljs's port
file), or start one with jack-in."
  (interactive)
  (require 'cider)
  (let* ((root (clojure-project-dir))
         (port (and root (car (nrepl-extract-ports root)))))
    (cond
     ((cider-current-repl)
      (message "Already connected: %s" (buffer-name (cider-current-repl))))
     (port
      (condition-case err
          (cider-connect-clj (list :host "localhost" :port port :project-dir root))
        (error
         (message "No REPL at .nrepl-port %s (%s); starting one" port
                  (error-message-string err))
         (cider-jack-in-clj nil))))
     (t (cider-jack-in-clj nil)))))

(map! :n  "C-h" #'evil-window-left
      :n  "C-j" #'evil-window-down
      :n  "C-k" #'evil-window-up
      :n  "C-l" #'evil-window-right
      :n  "]c"  #'+vc-gutter/next-hunk
      :n  "[c"  #'+vc-gutter/previous-hunk
      ;; Neovim's LSP defaults (Doom's gr is an eval operator; SPC e covers that)
      :n  "grn" #'lsp-rename
      :nv "gra" #'lsp-execute-code-action
      :n  "grr" #'+lookup/references
      :n  "gri" #'lsp-find-implementation
      :n  "grd" #'+lookup/definition
      :n  "grD" #'lsp-find-declaration
      :n  "grt" #'lsp-find-type-definition
      :n  "gO"  #'consult-imenu
      :n  "gW"  #'xref-find-apropos)

(map! :leader
      :desc "Find buffer"          "SPC" #'+vertico/switch-workspace-buffer
      :desc "Search buffer"        "/"   #'+default/search-buffer
      :desc "Format"               "f"   #'+nvim/format
      :desc "Copy relative path"   "c p" #'+default/yank-buffer-path-relative-to-project
      ;; Telescope
      :desc "Help"                 "s h" #'helpful-symbol
      :desc "Keymaps"              "s k" #'embark-bindings
      :desc "Find file in project" "s f" #'projectile-find-file
      :desc "Grep word"            "s w" #'+default/search-project-for-symbol-at-point
      :desc "Grep project"         "s g" #'+default/search-project
      :desc "Diagnostics"          "s d" #'+default/diagnostics
      :desc "Resume search"        "s r" #'vertico-repeat
      :desc "Recent files"         "s o" #'consult-recent-file
      :desc "Commands"             "s c" #'execute-extended-command
      :desc "Emacs config files"   "s n" #'doom/find-file-in-private-config
      ;; Fugitive, Diffview and gitsigns toggles
      :desc "Git status"           "g s" #'magit-status
      :desc "Git blame"            "g b" #'magit-blame-addition
      :desc "Diff / definition"    "g d" #'+nvim/diff-or-definition
      :desc "File history"         "g f" #'magit-log-buffer-file
      :desc "Repo history"         "g h" #'magit-log-head
      :desc "Diff vs main"         "g m" #'+nvim/diff-vs-main
      :desc "Commits vs main"      "g c" #'+nvim/log-vs-main
      :desc "Blame"                "t b" #'magit-blame-addition
      :desc "Preview hunk"         "t D" #'diff-hl-show-hunk
      :desc "Inlay hints"          "t h" #'lsp-inlay-hints-mode)


;;; Projects

;; SPC p p discovers git repos in the same folders tmux-sessionizer scans, and
;; opens each in its own workspace. File lists are read fresh each time, so new
;; files show up without SPC p i (Doom caches them across sessions).
(setq projectile-project-search-path '(("~/work" . 1) ("~/personal" . 1))
      projectile-enable-caching nil)


;;; Lisp

;; Colour nested parens by depth.
(add-hook! '(clojure-mode-hook emacs-lisp-mode-hook) #'rainbow-delimiters-mode)

;; Clojure indents in steps of 2, but >>, << and visual > shift by
;; evil-shift-width, which follows Doom's global tab-width of 4.
(setq-hook! 'clojure-mode-hook evil-shift-width 2 tab-width 2)

;; LSP hover docs (K, eldoc) render clojure-lsp's Markdown. For each code block,
;; markdown-mode searches disk for a tree-sitter grammar (~37 ms without one),
;; which froze typing whenever the cursor paused. Look each language up once.
;; Fixed upstream in jrblevin/markdown-mode#956; drop this once Doom's pin of
;; markdown-mode includes it.
(defvar +markdown--lang-mode-cache (make-hash-table :test #'equal))
(defadvice! +markdown-cache-lang-mode-a (fn lang)
  :around #'markdown-get-lang-mode
  (with-memoization (gethash lang +markdown--lang-mode-cache)
    (funcall fn lang)))

;; Keep the echo area quiet so workspace tabs stay visible: one-line eldoc
;; signatures (K shows full docs).
(setq eldoc-echo-area-use-multiline-p nil)


;;; Clojure: CIDER and clojure-lsp

;; clojure-lsp does static work (navigation, rename, diagnostics, completion)
;; and CIDER does runtime work (eval, tests, debugger, inspector). Doom's +lsp
;; already hands eldoc, completion and lookup to LSP; xref goes too, so
;; go-to-definition doesn't switch to CIDER once a REPL connects. clj-refactor
;; stays off, as Doom leaves it under +lsp.
(after! cider
  (setq cider-use-xref nil
        ;; Show the REPL on connect without moving the cursor into it.
        cider-repl-pop-to-buffer-on-connect 'display-only
        ;; , e b / , e f save a modified buffer before loading it instead of asking.
        cider-save-file-on-load t)
  ;; Doom already keeps the REPL popup open on ESC; put the test report beside
  ;; the code.
  (set-popup-rule! "^\\*cider-test-report\\*" :side 'right :width 0.4))

;; Forms inside (comment ...) count as top level, so , e r evaluates the form
;; under the cursor in a rich comment block, not the whole comment.
(after! clojure-mode
  (setq clojure-toplevel-inside-comment-form t))

(after! lsp-mode
  ;; Semantic highlighting replaces CIDER's dynamic font-lock, which +lsp turns off.
  (setq lsp-semantic-tokens-enable t)
  ;; Save the files a rename or code action changed instead of leaving them
  ;; modified in the background. Formatting and completion edits stay unsaved.
  (add-hook 'lsp-after-apply-edits-hook
            (defun +lsp-save-after-refactor-h (operation)
              (when (memq operation '(rename code-action))
                (save-buffer)))))

(after! lsp-ui
  (setq lsp-ui-doc-enable nil           ; K shows docs on demand
        lsp-ui-peek-enable nil))        ; grr and grd use the minibuffer


;;; Clojure: localleader keys

;; , is the localleader (replacing SPC m), as in Spacemacs and most evil Clojure
;; configs. Without the snipe setting, evil-snipe would take , in every buffer
;; to repeat a find backwards; f/F/t/T and s/S still repeat by pressing them
;; again, and , keeps that job in buffers without localleader keys.
(setq doom-localleader-key ","
      evil-snipe-override-evil-repeat-keys nil)

;; Doom's localleader map covers the rest: , ' jack in, , t t/n/p/l/r tests,
;; , r r refresh namespaces (SPC u , r r refreshes all), , r b REPL buffer,
;; , r q quit, , d d debug. Eval keeps Conjure's letters (, e e, , e r, ...),
;; replacing Doom's , e e and , e r.
;;
;; CIDER's own -at-point commands jump past the form and call its last-sexp
;; commands, which evil-collection shifts one character in normal state, so
;; they evaluate the enclosing form instead. These evaluate exact bounds.
(defun +clojure/eval-list-at-point ()
  "Evaluate the form under the cursor, like Conjure's ee."
  (interactive)
  (apply #'cider-eval-region (cider-list-at-point 'bounds)))

(defun +clojure/eval-sexp-at-point ()
  "Evaluate the element under the cursor, like Conjure's ew."
  (interactive)
  (apply #'cider-eval-region (cider-sexp-at-point 'bounds)))

(defun +clojure/eval-list-and-replace ()
  "Replace the form under the cursor with its value, like Conjure's e!."
  (interactive)
  ;; Land on the closing paren, which the advice above includes.
  (goto-char (1- (cadr (cider-list-at-point 'bounds))))
  (cider-eval-last-sexp-and-replace))

(defun +clojure/eval-list-and-copy (&optional with-form)
  "Evaluate the form under the cursor and copy its value to the clipboard.
With WITH-FORM, copy \"form => value\" instead."
  (interactive)
  (let* ((form (cider-list-at-point))
         (value (nrepl-dict-get (cider-nrepl-sync-request:eval
                                 form nil (cider-current-ns))
                                "value")))
    (if (not value)
        (message "Evaluation failed; nothing copied")
      (let ((text (if with-form (format "%s => %s" form value) value)))
        (kill-new text)
        (message "Copied: %s" text)))))

;; Conjure's localleader was Space, so its keys keep their letters under ,.
(map! :after cider
      :map cider-mode-map
      ;; Enter in normal state evaluates too (insert-state Enter is a newline)
      :n "RET"    #'+clojure/eval-list-at-point
      :n [return] #'+clojure/eval-list-at-point
      (:localleader
       :desc "Connect or start REPL" "c" #'+nvim/repl-connect
       "e e"   #'+clojure/eval-list-at-point
       "e r"   #'cider-eval-defun-at-point
       "e w"   #'+clojure/eval-sexp-at-point
       "e f"   #'cider-load-buffer
       "e !"   #'+clojure/eval-list-and-replace
       "e c r" #'cider-eval-defun-to-comment
       "e y"   #'+clojure/eval-list-and-copy
       "e Y"   (cmd! (+clojure/eval-list-and-copy t))
       "e i"   #'cider-interrupt
       "E"     #'cider-eval-region
       :desc "Test file <-> source" "t v" #'projectile-toggle-between-implementation-and-test))


;;; Clojure: structural editing

;; evil-cleverparens with its own keys: < and > slurp or barf by cursor position,
;; M-j/M-k drag, M-r/M-R raise, M-s splice, H/L and ( ) move by form, and af/if
;; and ad/id select forms and defuns. Its operators keep parens balanced. s and
;; S stay evil-snipe's; set before it loads.
(setq evil-cleverparens-use-s-and-S nil)
(add-hook 'clojure-mode-hook #'evil-cleverparens-mode)

;; It binds [ and ] to paren motions, which shadows ]c/[c hunks and Doom's other
;; [ and ] pairs. Give those back.
(map! :after evil-cleverparens
      :map evil-cleverparens-mode-map
      :nvo "[" nil
      :nvo "]" nil)

;; nvim-paredit's element text objects, which cleverparens lacks.
(evil-define-text-object +paredit/inner-element (count &optional beg end type)
  "The element (symbol, literal or form) under the cursor."
  (let ((b (bounds-of-thing-at-point 'sexp)))
    (evil-range (car b) (cdr b))))

(evil-define-text-object +paredit/a-element (count &optional beg end type)
  "The element under the cursor plus trailing whitespace."
  (let ((b (bounds-of-thing-at-point 'sexp)))
    (evil-range (car b) (save-excursion (goto-char (cdr b))
                                        (skip-chars-forward " \t\n")
                                        (point)))))

(map! :after clojure-mode
      :map clojure-mode-map
      :vo "ie" #'+paredit/inner-element
      :vo "ae" #'+paredit/a-element)
