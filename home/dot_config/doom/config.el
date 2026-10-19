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

;; \ toggles a file tree sidebar at the current file, like Neo-tree in Neovim.
(map! :n "\\" #'dirvish-side)
(after! dirvish-side (dirvish-side-follow-mode))



;;; Neovim keymap parity

;; Keys mirror ~/.config/nvim so muscle memory carries over, replacing Doom's
;; binding where they collide. Kept as Doom's on purpose: SPC h (help, where
;; Neovim has gitsigns hunks), SPC q (quit menu; Neovim's diagnostics list is
;; also on SPC s d) and PageUp/PageDown (no recentering, set above).

(setq evil-vsplit-window-right t        ; splitright
      evil-split-window-below t         ; splitbelow
      scroll-margin 10                  ; scrolloff
      which-key-idle-delay 0.3)         ; timeoutlen

(defun +nvim/format ()
  "Format the selection or buffer with the language server, like <leader>f."
  (interactive)
  (if (use-region-p)
      (eglot-format (region-beginning) (region-end))
    (eglot-format-buffer)))

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

(defun +nvim/repl-split (&optional vertical)
  "Show the REPL in a split below, or beside with VERTICAL, like Conjure's log."
  (interactive)
  (let ((repl (cider-current-repl nil 'ensure)))
    (select-window (split-window nil nil (if vertical 'right 'below)))
    (set-window-buffer (selected-window) repl)))

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

(defun +nvim/repl-close ()
  "Close every window showing a REPL, like Conjure's <localleader>lq."
  (interactive)
  (dolist (w (window-list))
    (when (with-current-buffer (window-buffer w) (derived-mode-p 'cider-repl-mode))
      (ignore-errors (delete-window w)))))

(defun +eglot/rename-prefilled ()
  "Rename the symbol at point, starting the prompt with its current name.
Neovim's grn prefills it; eglot only offers it as the M-n default."
  (interactive)
  (minibuffer-with-setup-hook
      (lambda () (when (stringp minibuffer-default) (insert minibuffer-default)))
    (call-interactively #'eglot-rename)))

(map! :n  "C-h" #'evil-window-left
      :n  "C-j" #'evil-window-down
      :n  "C-k" #'evil-window-up
      :n  "C-l" #'evil-window-right
      :n  "]c"  #'+vc-gutter/next-hunk
      :n  "[c"  #'+vc-gutter/previous-hunk
      ;; Neovim's LSP defaults (Doom's gr is an eval operator; SPC e covers that)
      :n  "grn" #'+eglot/rename-prefilled
      :nv "gra" #'eglot-code-actions
      :n  "grr" #'+lookup/references
      :n  "gri" #'eglot-find-implementation
      :n  "grd" #'+lookup/definition
      :n  "grD" #'eglot-find-declaration
      :n  "grt" #'eglot-find-type-definition
      :n  "gO"  #'consult-imenu
      :n  "gW"  #'xref-find-apropos)

(map! :leader
      :desc "Find buffer"          "SPC" #'+vertico/switch-workspace-buffer
      :desc "Search buffer"        "/"   #'+default/search-buffer
      :desc "Format"               "f"   #'+nvim/format
      :desc "Copy relative path"   "c p" #'+default/yank-buffer-path-relative-to-project
      :desc "Connect or start REPL" "c f" #'+nvim/repl-connect
      :desc "Quit REPL"            "c d" #'cider-quit
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
      :desc "Inlay hints"          "t h" #'eglot-inlay-hints-mode
      ;; Tests: Conjure's keys (tn tc ta) won in Clojure buffers, plus vim-test's
      :desc "Test namespace"       "t n" #'cider-test-run-ns-tests
      :desc "Test at cursor"       "t c" #'cider-test-run-test
      :desc "Test loaded"          "t a" #'cider-test-run-loaded-tests
      :desc "Test file"            "t f" #'cider-test-run-ns-tests
      :desc "Test suite"           "t s" #'cider-test-run-project-tests
      :desc "Test last"            "t l" #'cider-test-rerun-test
      :desc "Test file <-> source" "t v" #'projectile-toggle-between-implementation-and-test
      ;; Conjure's log windows and namespace refresh
      :desc "REPL split below"     "l s" #'+nvim/repl-split
      :desc "REPL split right"     "l v" (cmd! (+nvim/repl-split t))
      :desc "Close REPL windows"   "l q" #'+nvim/repl-close
      :desc "Refresh changed nses" "r r" #'cider-ns-refresh
      :desc "Refresh all nses"     "r a" (cmd! (cider-ns-refresh 'refresh-all)))


;;; Projects

;; SPC p p discovers git repos in the same folders tmux-sessionizer scans.
(setq projectile-project-search-path '(("~/work" . 1) ("~/personal" . 1)))


;;; Lisp

;; Colour nested parens by depth.
(add-hook! '(clojure-mode-hook emacs-lisp-mode-hook) #'rainbow-delimiters-mode)

;; eglot renders clojure-lsp's hover docs as Markdown. For each code block,
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
;; signatures (K shows full docs), and no "SPC c a: ... more actions" hint.
(setq eldoc-echo-area-use-multiline-p nil)
(after! eglot
  (setq eglot-code-action-indications nil))


;;; Clojure: Conjure-style eval keys

;; Neovim's localleader is Space, so Conjure evaluates with SPC e e and friends.
;; Doom's leader map leaves SPC e unbound, so these fall through to CIDER
;; buffers. Doom's own SPC m e menu still works.
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

;; SPC e b / SPC e f save a modified buffer before loading it instead of asking.
(after! cider
  (setq cider-save-file-on-load t))

(map! :after cider
      :map cider-mode-map
      :n "SPC e e"   #'+clojure/eval-list-at-point
      :n "SPC e r"   #'cider-eval-defun-at-point
      :n "SPC e w"   #'+clojure/eval-sexp-at-point
      :n "SPC e b"   #'cider-eval-buffer
      :n "SPC e f"   #'cider-load-buffer
      :n "SPC e !"   #'+clojure/eval-list-and-replace
      :n "SPC e c r" #'cider-eval-defun-to-comment
      :n "SPC e y"   #'+clojure/eval-list-and-copy
      :n "SPC e Y"   (cmd! (+clojure/eval-list-and-copy t))
      :n "SPC e i"   #'cider-interrupt
      :v "SPC E"     #'cider-eval-region
      ;; Enter in normal state evaluates too (insert-state Enter is a newline)
      :n "RET"       #'+clojure/eval-list-at-point
      :n [return]    #'+clojure/eval-list-at-point)


;;; Clojure: nvim-paredit keys

;; nvim-paredit's defaults. >) and friends make > and < prefixes in normal
;; state, so >> and << are rebound and other > and < motions (like >ip) are lost.
;; Its localleader keys move to SPC m, because SPC o is Doom's open menu.
(defun +paredit/drag-form-forward (count)
  "Drag the form around the cursor forward, like nvim-paredit's >f."
  (interactive "p")
  (sp-backward-up-sexp)
  (evil-cp-drag-forward count))

(defun +paredit/drag-form-backward (count)
  "Drag the form around the cursor backward, like nvim-paredit's <f."
  (interactive "p")
  (sp-backward-up-sexp)
  (evil-cp-drag-backward count))

(defun +paredit/raise-form ()
  "Replace the enclosing form with the form around the cursor."
  (interactive)
  (sp-backward-up-sexp)
  (sp-raise-sexp))

(defun +paredit/raise-element ()
  "Replace the form around the cursor with the element under it."
  (interactive)
  (goto-char (car (bounds-of-thing-at-point 'sexp)))
  (sp-raise-sexp))

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

(evil-define-motion +paredit/next-element-head (count)
  "Move to the start of the next element, like nvim-paredit's W."
  :jump t
  :type exclusive
  (dotimes (_ (or count 1))
    (forward-sexp 1)
    (forward-sexp 1)
    (backward-sexp 1)))

(evil-define-motion +paredit/next-element-tail (count)
  "Move to the last character of the next element, like nvim-paredit's E."
  :jump t
  :type inclusive
  (forward-char 1)
  (forward-sexp (or count 1))
  (backward-char 1))

(evil-define-motion +paredit/previous-element-tail (count)
  "Move to the last character of the previous element, like nvim-paredit's gE."
  :jump t
  :type inclusive
  (goto-char (car (bounds-of-thing-at-point 'sexp)))
  (backward-sexp (or count 1))
  (forward-sexp 1)
  (backward-char 1))

;; Its motions and drag commands aren't autoloaded.
(after! clojure-mode (require 'evil-cleverparens))

(map! :after clojure-mode
      :map clojure-mode-map
      :n ">)" #'sp-forward-slurp-sexp
      :n "<)" #'sp-forward-barf-sexp
      :n "<(" #'sp-backward-slurp-sexp
      :n ">(" #'sp-backward-barf-sexp
      :n ">e" #'evil-cp-drag-forward
      :n "<e" #'evil-cp-drag-backward
      :n ">f" #'+paredit/drag-form-forward
      :n "<f" #'+paredit/drag-form-backward
      :n ">>" #'evil-shift-right-line
      :n "<<" #'evil-shift-left-line
      :nvo "W"  #'+paredit/next-element-head
      :nvo "B"  #'evil-cp-backward-sexp
      :nvo "E"  #'+paredit/next-element-tail
      :nvo "gE" #'+paredit/previous-element-tail
      :nvo "("  #'evil-cp-backward-up-sexp
      :nvo ")"  #'evil-cp-up-sexp
      :vo "if" #'evil-cp-inner-form
      :vo "af" #'evil-cp-a-form
      :vo "iF" #'evil-cp-inner-defun
      :vo "aF" #'evil-cp-a-defun
      :vo "ie" #'+paredit/inner-element
      :vo "ae" #'+paredit/a-element
      (:localleader
       "o" #'+paredit/raise-form
       "O" #'+paredit/raise-element
       "@" #'sp-splice-sexp))
