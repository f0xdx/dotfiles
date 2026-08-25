;;; early-init.el --- f0xdx's Emacs early init file
;;
;; Copyright (c) 2016-2026 Felix Heinrichs
;;
;; Author: Felix Heinrichs <felix.heinrichs@gmail.com>
;; URL: https://github.com/f0xdx/dotfiles

;; This file is not part of GNU Emacs.

;; Commentary:

;; User specific settings for Emacs configuration.  Packages are managed through
;; nix home manager.

;; Packages

;; packages are managed through nix in home/editor/emacs/default.nix
;; loading them simply through (require '<package name>)
;; see also https://discourse.nixos.org/t/how-to-use-emacs-packages-installed-via-home-manager/2513
;; TODO after Emacs 31 upgrade implement diminish style functionality, see https://emacsredux.com/blog/2025/12/24/hide-minor-modes-in-the-modeline-in-emacs-31/

;;; Basic Settings

;; cache
(defconst user-emacs-cache-directory
  (expand-file-name "emacs/" (or (getenv "XDG_CACHE_HOME") "~/.cache/"))
  "Directory where cached files for this user should be stored.")
(unless (file-exists-p user-emacs-cache-directory)
  (make-directory user-emacs-cache-directory :parents))

;; core
(use-package emacs                                     ; basic Emacs settings
  :init                                                ; performance
  (setq read-process-output-max (* 1024 1024)          ; 1MB - data read from sub-processes, e.g., LSP (default is just 4KB)
        redisplay-skip-fontification-on-input t        ; keep typing responsive by defering fontification
        large-file-warning-threshold 100000000         ; warn when opening files bigger than 100MB
        confirm-kill-processes nil)                    ; quit Emacs directly even if there are running processes

  :config
  (setq user-full-name "Felix Heinrichs"
        user-email-address "felix.heinrichs@gmail.com"

        ;; auto-save
        auto-save-list-file-prefix (expand-file-name "saves-" user-emacs-cache-directory)
        backup-directory-alist `((".*" . ,temporary-file-directory))

        ;; custom
        custom-file (locate-user-emacs-file "custom.el")

        ;; sensible defaults
        help-window-select t                           ; automatically select help windows so you can dismiss them with 'q'
        window-combination-resize t                    ; resize all open windows proportionally
        require-final-newline t
        save-interprogram-paste-before-kill t          ; preserve system clipboard in kill ring
        kill-do-not-save-duplicates t
        ffap-machine-p-known 'reject                   ; don't let ffap ping random hostnames
        auto-revert-avoid-polling t                    ; automatic revert when underlying file changes
        next-line-add-newlines t                       ; automatically append new lines at the end of buffer
        set-mark-command-repeat-pop t                  ; after C-u C-SPC, keep popping the mark ring with just C-SPC
        isearch-lazy-count t                           ; isearch shows number matches
        search-whitespace-regexp ".*?"                 ; orderless style searching in isearch etc.
        isearch-allow-motion t                         ; quickly move between search results
        global-auto-revert-non-file-buffers t)         ; keep dired up to date

  (setq-default indent-tabs-mode nil                   ; don't use tabs to indent
                fill-column 80)                        ; default text length

  ;; file encoding
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)

  ;; custom
  (load custom-file 'noerror 'nomessage)               ; load the configured custom file

  ;; helpful modes
  (global-auto-revert-mode 1)                          ; reload changes from disk
  (delete-selection-mode 1)                            ; delete the selection with a keypress
  (minibuffer-regexp-mode 1)                           ; visual feedback for regex in minibuffer

  :hook
  (before-save-hook . delete-trailing-whitespace)      ; remove trailing whitespace

  :bind (:map global-map
         ("M-o M-o" . other-window)                    ; fast window movement
         ("M-o o" . other-window)
         ("M-o M-f" . windmove-right)
         ("M-o M-b" . windmove-left)
         ("M-o M-p" . windmove-up)
         ("M-o M-n" . windmove-down)
         ("C-c C-o" . browse-url))                     ; open url in browser
  )

;; mac specifics
;; sync PATH and env vars from the shell on macOS
;; only needed for GUI Emacs on macOS, where the shell env isn't inherited
(when (memq window-system '(mac ns))
  (use-package exec-path-from-shell
    :ensure nil                           ;; installed through home/editors/emacs/default.nix
    :config
    (exec-path-from-shell-initialize)))


;;; Appearance

(use-package emacs                        ; Emacs minimal appearance, minimal distraction
  :hook
  (conf-mode . display-line-numbers-mode) ; line numbers in all programming modes
  (text-mode . display-line-numbers-mode)
  (prog-mode . display-line-numbers-mode)

  :config
  (setq-default truncate-lines t)         ; no wrapping lines
  (setq inhibit-startup-message t         ; no startup message
        ring-bell-function 'ignore        ; no bell
        use-dialog-box nil                ; only text dialogs
        use-short-answers t               ; enable y/n answers
        next-error-message-highlight t)   ; highlight current error in compilation/grep buffers

  ;; fonts and theme
  (set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 160)
  ;; (load-theme 'modus-operandi)
  (load-theme 'modus-vivendi)

  ;; minimal visuals
  (blink-cursor-mode -1)                  ; blinking cursors are annoying
  (scroll-bar-mode -1)                    ; scroll bar not required
  (tool-bar-mode -1)                      ; no tool-bar - M-x is the way
  (tooltip-mode -1)
  (set-fringe-mode 14)                    ; fringe width both sides in px
  (menu-bar-mode -1))                     ; no menu bar
;; TODO automatic theme switching based on system: https://emacsredux.com/blog/2026/03/29/automatic-light-dark-theme-switching/
;; TODO use a short flash of mode line as bell https://emacs.stackexchange.com/questions/28906/how-to-switch-off-the-sounds

;; scrolling
(use-package ultra-scroll
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :init
  (setq scroll-margin 0                 ; ultra-scroll requires 0 for glitch-free scrolling
    scroll-conservatively 100000
    scroll-preserve-screen-position 1)
  :config
  (ultra-scroll-mode 1))

;; nerd-icons
;; see also https://github.com/rainstormstudio/nerd-icons.el
(use-package nerd-icons
  :ensure nil                           ;; installed through home/editors/emacs/default.nix
  :defer t
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "FiraCode Nerd Font"))


;;; Quality ofy Life

(use-package emacs                      ; quality of life in Emacs
  :config
  (defun slick-cut (beg end)            ; slick cut / copy
    (interactive
     (if mark-active
         (list (region-beginning) (region-end))
       (list (line-beginning-position) (line-beginning-position 2)))))
  (defun slick-copy (beg end)
    (interactive
     (if mark-active
         (list (region-beginning) (region-end))
       (list (line-beginning-position) (line-beginning-position 2)))))

  ;; emacs fu from https://emacs.stackexchange.com/questions/2347/kill-or-copy-current-line-with-minimal-keystrokes
  (advice-add 'kill-region :before #'slick-cut)
  (advice-add 'kill-ring-save :before #'slick-copy)

  ;; hippie expand
  :bind (:map global-map
         ("M-/" . hippie-expand)
         ("s-/" . hippie-expand)))

(use-package elec-pair                  ; auto pair parenthesis
  :ensure nil                           ; built-in
  :config
  (electric-pair-mode 1))

(use-package which-key                  ; discover available keys
  :ensure nil                           ; built-in
  :init
  ;; which-key is activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (which-key-mode 1))

(use-package paren                      ; show paren context
  :ensure nil                           ; built-in
  :config
  (show-paren-mode 1)
  ;; show matching paren context when it's offscreen
  (setq show-paren-context-when-offscreen 'overlay))

(use-package calendar                   ; calendar view
  :ensure nil                           ; built-in
  :defer t
  :config
  ;; weeks starting on Monday
  (setq calendar-week-start-day 1
        calendar-intermonth-text
        '(propertize
          (format "w%2d"
                  (car
                   (calendar-iso-from-absolute
                    (calendar-absolute-from-gregorian (list month day year)))))
          'font-lock-face 'font-lock-comment-face)))

;; spell checking
;; TODO configure aspell

(use-package hl-line                    ; highlight the current line
  :ensure nil                           ; built-in
  :config
  (global-hl-line-mode 1))

(use-package uniquify                        ; better buffer names
  :ensure nil                                ; built-in
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  (setq uniquify-after-kill-buffer-p t)      ; rename after killing uniquified
  (setq uniquify-ignore-buffers-re "^\\*"))  ; don't muck with special buffers

(use-package saveplace                  ; remembers your location in a file when saving files
  :ensure nil                           ; built-in
  :config
  (setq save-place-file (expand-file-name "saveplace" user-emacs-cache-directory))
  (save-place-mode 1))

(use-package savehist                   ; persist history over Emacs restarts
  :ensure nil                           ; built-in
  :config
  (setq savehist-additional-variables
        '(search-ring regexp-search-ring kill-ring vertico-repeat-history)      ; search entries, kill ring and vertico's session history
        history-length 30                                                       ; remember last n entries
        savehist-autosave-interval 60                                           ; save every minute
        savehist-file (expand-file-name "savehist" user-emacs-cache-directory)) ; keep the home clean
  ;; strip text properties from kill-ring entries before saving to disk --
  ;; propertized strings cause errors and bloat the savehist file
  (add-hook 'savehist-save-hook
            (lambda ()
              (setq kill-ring
                    (mapcar #'substring-no-properties
                            (cl-remove-if-not #'stringp kill-ring)))))
  (savehist-mode 1))

(use-package recentf
  :config
  (setq recentf-save-file (expand-file-name "recentf" user-emacs-cache-directory)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode 1))

(use-package dired                               ; manage directories with emacs
  :ensure nil                                    ; built-in
  :defer t
  :config
  (put 'dired-find-alternate-file 'disabled nil) ; dired - reuse current buffer by pressing 'a'
  (setq dired-recursive-deletes 'always)         ; always delete and copy recursively
  (setq dired-recursive-copies 'always)
  (setq dired-dwim-target t)                     ; use subdir of other window
  (setq dired-mouse-drag-files t))               ; drag files from dired to other apps

(use-package nerd-icons-dired           ; adds nerdicons for better visuals
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package hl-todo                    ; high-lights todo, note, etc. markers
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :config
  (setq hl-todo-highlight-punctuation ":")
  (global-hl-todo-mode 1))

;; xref
(use-package nerd-icons-xref
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :hook
  (xref--xref-buffer-mode . nerd-icons-xref-mode))
;;  (after-init-hook . nerd-icons-xref-mode))

;; server
(use-package server ; automatically start a server for emacsclient connections
  :ensure nil
  :defer 1
  :config
  (unless server-process
    (server-start)))


;;; Grep

(use-package grep                       ; grep using ripgrep
  :config
  (grep-apply-setting 'grep-command "rg --no-heading -Hn0 ")
  (grep-apply-setting 'grep-find-command '("rg -Hn --no-heading -e '' -g '**/*' $(git rev-parse --show-toplevel || pwd)" . 25))
  (grep-apply-setting grep-use-null-device nil)
  (setq grep-use-headings t))

;; nerd icons in grep buffers (buggy, may need fix)
(use-package nerd-icons-grep
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :init
  (setq grep-use-headings t)
  :hook
  (grep-mode . nerd-icons-grep-mode))

;; wgrep
;; edit grep/occur buffers and apply the changes to the files
;; (press C-c C-p in a grep buffer, edit, then C-c C-e to apply)
(use-package wgrep
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :defer t
  :config
  (setq wgrep-auto-save-buffer t))      ; save the affected buffers automatically after applying the edits


;;; Git & Version Control

(use-package difftastic
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :defer t)

(use-package difftastic-bindings
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :config
  (difftastic-bindings-mode 1))

;; ediff
;; TODO evaluate whether ediff config is required


;;; Modeline

;; TODO evaluate customizing it https://protesilaos.com/codelog/2023-07-29-emacs-custom-modeline-tutorial/
;;      vs. https://github.com/seagle0128/doom-modeline
;;      vs. https://codeberg.org/Lambda-Emacs/lambda-line
;; NOTE we can take inspiration from https://github.com/domtronn/all-the-icons.el/wiki/Mode-Line on how to
;;      build a custom mode line with icons
(line-number-mode 1)
(column-number-mode 1)
(size-indication-mode 1)


;;; LSP Support

(use-package eglot
  :ensure nil                           ; built-in
  :defer t
  :config
  (setq eglot-extend-to-xref t)
  :custom
  (eglot-autoshutdown t)                ; shut down LSP server when last managed buffer is killed
  ;; don't log every LSP event to the events buffer - the logging adds
  ;; overhead with chatty servers; set :size back to nil (unlimited)
  ;; temporarily when you need to debug an LSP session
  (eglot-events-buffer-config '(:size 0 :format full)))

;; eglot keybindings for common lsp commands


;;; Modal Editing
;; TODO decide on modal editing support:
;; * contextual, e.g., hydra: https://github.com/abo-abo/hydra
;; * absolute, e.g., meow: https://github.com/abo-abo/hydra


;;; Completion

(use-package marginalia                 ; rich annotations using the Marginalia package
  :ensure nil
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package nerd-icons-completion      ; better visuals for mini-buffer completions
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package vertico                    ; vertical command completion: https://github.com/minad/vertico
  :ensure nil
  :custom
  (vertico-scroll-margin 0)             ; different scroll margin
  (vertico-count 10)                    ; show 10 candidates
  (vertico-resize nil)                  ; one of t, nil, "grow-only" (default)
  (vertico-cycle t)                     ; enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

(use-package vertico-directory          ; vertico to navigate directories
  :after vertico
  :ensure nil
  :bind (:map vertico-map               ; more convenient directory navigation commands
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))   ; Tidy shadowed file names

;; vertico-repeat - resume the last minibuffer session with its input
;; and candidate intact (also ships with vertico).  Handy after you
;; abort a consult-ripgrep to check something and want it back.  The
;; history is persisted via `savehist-additional-variables'
(use-package vertico-repeat
  :ensure nil ; comes with vertico
  :after vertico
  :hook (minibuffer-setup . vertico-repeat-save)
  :bind ("M-R" . vertico-repeat))

(use-package emacs                      ; Emacs minibuffer configurations for vertico.
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  ;; hide commands in M-x which do not work in the current mode
  (read-extended-command-predicate
   #'command-completion-default-include-p))

(use-package orderless                  ; quick selection through partial matches
  :ensure nil
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

(use-package consult                    ; completions hooked into default mechanism
  :ensure nil
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ; orig. project-switch-to-buffer
         ("M-#" . consult-register-load)           ; Custom M-# bindings for fast register access
         ("M-'" . consult-register-store)          ; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ; orig. goto-line
         ("M-g o" . consult-outline)               ; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s f" . consult-fd)                    ; Alternative: consult-find
         ("M-s G" . consult-git-grep)
         ("M-s g" . consult-ripgrep)
         ("M-s M-g" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ; orig. next-matching-history-element
         ("M-r" . consult-history))                ; orig. previous-matching-history-element

  ;; The :init configuration is always executed (Not lazy)
  :init
  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"
  (setq completion-in-region-function #'consult-completion-in-region)

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )

(use-package consult-eglot
  :ensure nil                           ;; installed through home/editors/emacs/default.nix
  :bind(;; M-g bindings in `goto-map'
        ("M-g s" . consult-eglot-symbols)))

;; TODO consult-todo: https://github.com/eki3z/consult-todo ;; browse all todos in project

(use-package embark
  :ensure nil

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure nil)

;; completion-preview - built-in (Emacs 30+) inline "ghost text"
;; preview of the top completion candidate as you type; a lightweight
;; complement to vertico.  While a preview is visible TAB
;; accepts it and M-i completes up to the longest common prefix of
;; all candidates.
(use-package completion-preview
  :ensure nil
  :config
  ;; cycle through the other candidates (these commands exist, but
  ;; have no default bindings)
  (define-key completion-preview-active-mode-map (kbd "M-n") #'completion-preview-next-candidate)
  (define-key completion-preview-active-mode-map (kbd "M-p") #'completion-preview-prev-candidate)
  (global-completion-preview-mode 1))


;;; Treesitter
;;
;; Note that installed grammars are managed through home/editor/emacs/default.nix
(use-package emacs                           ; tree-sitter specific settings for Emacs
  :ensure nil
  :config
  (setq major-mode-remap-alist               ; use ts modes for some of the default modes
        '((c-mode . c-ts-mode)
          (js-json-mode . json-ts-mode)
          (python-mode . python-ts-mode)
          (conf-toml-mode . toml-ts-mode)))
  :custom (global-tree-sitter-mode t))

;; expand-region, tree-sitter edition
(use-package expreg
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :bind (:map global-map
         ("C-+" . expreg-expand)
         ("C-=" . expreg-contract))
  :config
  (defvar expreg-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map "+" #'expreg-expand)
      (define-key map "=" #'expreg-contract)
      map))
  (put 'expreg-expand 'repeat-map 'expreg-repeat-map)
  (put 'expreg-contract 'repeat-map 'expreg-repeat-map))


;;; Folding

;; outline
;; Native package to navigate/hide outlines either based on regex or tree-sitter nodes
;; as discussed in https://www.masteringemacs.org/article/whats-new-in-emacs-301
;; This package is the preferred built-in option.
;; TODO change default elipsis to something more useful https://www.jamescherti.com/emacs-customize-ellipsis-outline-minor-mode/
;; NOTE all programming modes should add a hook to enable outline-minor-mode
(use-package outline
  :ensure nil                                         ; built-in
  :bind
  ( :map outline-minor-mode-map
    ("C-c z t" . outline-toggle-children)
    ("C-c z a" . outline-show-all)
    ("C-c z h" . outline-hide-body)
    ("C-c z o" . outline-hide-other)
    ("C-c z e" . outline-hide-subtree)
    ("C-c z s" . outline-show-subtree))

  :hook ((emacs-lisp-mode . outline-minor-mode)       ; NOTE could these be moved toward an elisp prog package?
         (lisp-interaction-mode . outline-minor-mode) ; scratch config; may require hs-minor-mode instead
         (lisp-mode . outline-minor-mode)))


;;; Terminal

;; ghostel
;; provided libghostty based terminal in emacs: https://github.com/dakra/ghostel
;; TODO libghostty-vt currently doesn't build on mac os, revisit after fix; see also in default.nix
;;(use-package ghostel
;;  :ensure nil                          ; installed through home/editors/emacs/default.nix
;;  )


;;; Programming Support

;; direnv
;; supports flake based tooling on a project level
(use-package direnv
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :defer t
  :init
  (direnv-mode 1))

;; editorconfig
;; honor .editorconfig files (built-in since Emacs 30);
;; automatically adjusts indentation style/size, line endings, final
;; newlines, etc. to match the conventions of the project at hand
(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; markdown
;; NOTE emacs 31 has this builtin, so when upgrading ensure that we use
;; the builting package instead
(use-package markdown-ts-mode
  :ensure nil                           ; installed through home/editors/emacs/default.nix
  :hook ((markdown-ts-mode . outline-minor-mode))
  :mode ("\\.md\\'" . markdown-ts-mode)
  :defer 't)

;; bash
(use-package bash-ts-mode
  :ensure nil                                 ; built-in
  :hook ((bash-ts-mode . eglot-ensure)
         (bash-ts-mode . outline-minor-mode))
  :defer t)

;; nix
(use-package nix-ts-mode
  :ensure nil                                 ; built-in
  :hook ((nix-ts-mode . eglot-ensure)
         (nix-ts-mode . outline-minor-mode))
  :mode ("\\.nix\\'" . nix-ts-mode)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
               '(nix-ts-mode . ("nixd"))))
  :defer t)

;; golang
;; gopls is default language server, so no need to configure
(use-package go-ts-mode
  :ensure nil                               ; built-in
  :hook ((go-ts-mode . eglot-ensure)
         (go-ts-mode . subword-mode)
         (go-ts-mode . outline-minor-mode))
;;  :mode ("\\.go\\'" . go-ts-mode)
  :defer t)

(use-package go-mod-ts-mode
  :ensure nil                               ; built-in
;;  :mode ("\\.go.mod\\'" . go-mod-ts-mode)
  :defer t)

;; yaml
(use-package yaml-ts-mode
  :ensure nil                               ; built-in
  :mode ("\\.ya?ml\\'" . yaml-ts-mode)
  :defer t)

;; zig
(use-package zig-ts-mode
  :ensure nil                                ; installed through home/editors/emacs/default.nix
  :hook ((zig-ts-mode . eglot-ensure)
         (zig-ts-mode . subword-mode)
         (zig-ts-mode . outline-minor-mode))
  :defer t
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
               '(zig-ts-mode . ("zls")))))


;;; Work-in-Progress

;; TODO continue editing from https://github.com/bbatsov/emacs.d/blob/master/init.el L1209
;; TODO also check this out: https://github.com/konrad1977/emacs  -modularized vanilla
;; TODO take inspiration from: https://github.com/LionyxML/emacs-solo
;; TODO evaluate if following are needed:
;; * enlight to build a custom startup screen https://github.com/ichernyshovvv/enlight
;; * agent-shell to orchestrate ACP compatible agents: https://github.com/xenodium/agent-shell
;; * combobulate for treesitter based navigation https://github.com/mickeynp/combobulate
;; * nerdicons dired: https://github.com/rainstormstudio/nerd-icons-dired
;; * buffer nerd icons: https://github.com/seagle0128/nerd-icons-ibuffer/

(provide 'init)
;;; init.el ends here
