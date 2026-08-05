;;; early-init.el --- f0xdx's Emacs early init file
;;
;; Copyright (c) 2016-2026 Felix Heinrichs
;;
;; Author: Felix Heinrichs <felix.heinrichs@gmail.com>
;; URL: https://github.com/f0xdx/dotfiles

;; This file is not part of GNU Emacs.

;;; Commentary:

;; User specific settings for emacs configuration. Packages are managed through
;; nix home manager.

;; Packages

;; packages are managed through nix in home/editor/emacs/default.nix
;; loading them simply through (require '<package name>)
;; see also https://discourse.nixos.org/t/how-to-use-emacs-packages-installed-via-home-manager/2513
;; TODO evaluate use of autoload (load a function on use) instead of require
;; TODO after emacs 31 upgrade implement diminish style functionality, see https://emacsredux.com/blog/2025/12/24/hide-minor-modes-in-the-modeline-in-emacs-31/

;;; Code:

;; basic settings
(setq user-full-name "Felix Heinrichs"
      user-email-address "felix.heinrichs@gmail.com")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; performance
;; data read from sub-processes, e.g., LSP (default is just 4KB)
(setq read-process-output-max (* 1024 1024)) ; 1MB
;; defer fontification while there is input pending -- this keeps
;; typing responsive in large/complex buffers where font-lock is slow
(setq redisplay-skip-fontification-on-input t)
;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)
;; quit Emacs directly even if there are running processes
(setq confirm-kill-processes nil)

;; cache
(defconst user-emacs-cache-directory
  (expand-file-name "emacs/" (or (getenv "XDG_CACHE_HOME") "~/.cache/"))
  "Directory where cached files for this user should be stored.")
(unless (file-exists-p user-emacs-cache-directory)
  (make-directory user-emacs-cache-directory :parents))

;; minimal
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore) ;; no bell, TODO use a short flash https://emacs.stackexchange.com/questions/28906/how-to-switch-off-the-sounds
(blink-cursor-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)


;; appearance

;; line
(setq-default truncate-lines t)		              ;; no wrapping lines
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))
;; (add-hook 'prog-mode-hook 'display-line-numbers-mode) ;; line numbers in all programming modes
;; mode line
(line-number-mode 1)
(column-number-mode 1)
(size-indication-mode 1)

;; scrolling
(use-package ultra-scroll
  :ensure nil                           ;; external installation
  :init
  (setq scroll-margin 0                 ;; ultra-scroll requires 0 for glitch-free scrolling
    scroll-conservatively 100000
    scroll-preserve-screen-position 1)
  :config
  (ultra-scroll-mode +1))

;; fonts and theme
(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 160)
;; (load-theme 'modus-operandi)
(load-theme 'modus-vivendi)		;; TODO automatic switching: https://emacsredux.com/blog/2026/03/29/automatic-light-dark-theme-switching/

;; misc
(setq next-error-message-highlight t) ;; highlight current error in compilation/grep buffers


;; environmental protection

;; auto-save
(setq auto-save-list-file-prefix (expand-file-name "saves-" user-emacs-cache-directory))
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))


;; quality of life

(setq use-short-answers t)                   ;; enable y/n answers
(setq help-window-select t)                  ;; automatically select help windows so you can dismiss them with 'q'
(setq-default indent-tabs-mode nil)          ;; don't use tabs to indent
(setq-default fill-column 80)
(setq require-final-newline t)
(setq save-interprogram-paste-before-kill t) ;; preserve system clipboard in kill ring
(setq kill-do-not-save-duplicates t)
(setq ffap-machine-p-known 'reject)          ;; don't let ffap ping random hostnames
(setq auto-revert-avoid-polling t)           ;; automatic revert when underlying file changes
(global-auto-revert-mode t)

;; mark
;; after C-u C-SPC, keep popping the mark ring with just C-SPC
;; instead of having to repeat the C-u prefix each time
(setq set-mark-command-repeat-pop t)

;; isearch
(setq isearch-lazy-count t)
(setq isearch-allow-motion t)
(delete-selection-mode 1)  ;; delete the selection with a keypress
(minibuffer-regexp-mode 1) ;; visual feedback for regex in minibuffer

;; hippie expand
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand)

;; remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;;(add-hook 'before-save-hook
;;          (lambda ()
;;            (when (derived-mode-p 'progr-mode)
;;              (delete-trailing-whitespace))))
;; TODO ws-butler style region mapping from vc tools

;; slick cut / copy (emacs fu from https://emacs.stackexchange.com/questions/2347/kill-or-copy-current-line-with-minimal-keystrokes)
(defun slick-cut (beg end)
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

(defun slick-copy (beg end)
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

(advice-add 'kill-region :before #'slick-cut)
(advice-add 'kill-ring-save :before #'slick-copy)

;; exec-path-from-shell - sync PATH and env vars from the shell on macOS
(use-package exec-path-from-shell
  :config
  ;; only needed for GUI Emacs on macOS, where the shell env isn't inherited
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

;; ripgrep
(use-package grep
  :config
  (grep-apply-setting 'grep-command "rg --no-heading -Hn0 ")
  (grep-apply-setting 'grep-find-command '("rg -Hn --no-heading -e '' -g '**/*' $(git rev-parse --show-toplevel || pwd)" . 25))
  (grep-apply-setting grep-use-null-device nil)
  (setq grep-use-headings t))

;; discover available keys
(use-package which-key
  :init
  (which-key-mode))

;; paren context
(use-package paren
  :config
  (show-paren-mode +1)
  ;; show matching paren context when it's offscreen
  (setq show-paren-context-when-offscreen 'overlay))

(use-package calendar
  :defer t
  :config
  ;; weeks starting on Monday
  (setq calendar-week-start-day 1))

;; highlight the current line
(use-package hl-line
  :config
  (global-hl-line-mode +1))

(use-package uniquify
  :ensure nil ;; external installation
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; rename after killing uniquified
  (setq uniquify-after-kill-buffer-p t)
  ;; don't muck with special buffers
  (setq uniquify-ignore-buffers-re "^\\*"))

;; saveplace remembers your location in a file when saving files
(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "saveplace" user-emacs-cache-directory))
  ;; activate it for all buffers
  (save-place-mode +1))

;; persist history over Emacs restarts.
(use-package savehist
  :config
  (setq savehist-additional-variables
        ;; search entries, kill ring and vertico's session history
        '(search-ring regexp-search-ring kill-ring vertico-repeat-history)
        ;; save every minute
        savehist-autosave-interval 60
        ;; keep the home clean
        savehist-file (expand-file-name "savehist" user-emacs-cache-directory))
  ;; strip text properties from kill-ring entries before saving to disk --
  ;; propertized strings cause errors and bloat the savehist file
  (add-hook 'savehist-save-hook
            (lambda ()
              (setq kill-ring
                    (mapcar #'substring-no-properties
                            (cl-remove-if-not #'stringp kill-ring)))))
  (savehist-mode +1))

(use-package recentf
  :config
  (setq recentf-save-file (expand-file-name "recentf" user-emacs-cache-directory)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode +1))

;; editorconfig - honor .editorconfig files (built-in since Emacs 30);
;; automatically adjusts indentation style/size, line endings, final
;; newlines, etc. to match the conventions of the project at hand
(use-package editorconfig
  :config
  (editorconfig-mode +1))

;; dired ?
;; ediff ?

;; hl-todo
(use-package hl-todo
  :ensure nil                           ;; external installation
  :config
  (setq hl-todo-highlight-punctuation ":")
  (global-hl-todo-mode +1))

;; git
(use-package magit
  :ensure nil                           ;; external installation
  :bind (("C-x g" . magit-status))
  :config
  (setq
   transient-values-file (expand-file-name "transient-values.el" user-emacs-cache-directory)
   transient-levels-file (expand-file-name "transient-levels.el" user-emacs-cache-directory)
   transient-history-file (expand-file-name "transient-history.el" user-emacs-cache-directory)))
(use-package difftastic-bindings
  :ensure nil                           ;; external installation
  :config
  (difftastic-bindings-mode +1))

;; TODO continue editing from https://github.com/bbatsov/emacs.d/blob/master/init.el L786
;; TODO also check this out: https://github.com/konrad1977/emacs  -modularized vanilla

;; modeline

;; TODO evaluate customizing it https://protesilaos.com/codelog/2023-07-29-emacs-custom-modeline-tutorial/
;;      vs. https://github.com/seagle0128/doom-modeline
;;      vs. https://codeberg.org/Lambda-Emacs/lambda-line


;; lsp support

;; lsp mode: https://github.com/emacs-lsp/lsp-mode
;; consult-lsp: https://github.com/gagbo/consult-lsp ;; unclear whether needed, may work out of the box


;; modal editing
;; TODO decide on modal editing support:
;; * contextual, e.g., hydra: https://github.com/abo-abo/hydra
;; * absolute, e.g., meow: https://github.com/abo-abo/hydra
;; completion


;; completion

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :ensure nil
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

;; vertico for vertical command completion: https://github.com/minad/vertico
;; Vertico sorts by history position.
(use-package vertico
  :ensure nil
  :custom
  (vertico-scroll-margin 0) ;; different scroll margin
  (vertico-count 10)        ;; show 10 candidates
  (vertico-resize nil)      ;; one of t, nil, "grow-only" (default)
  (vertico-cycle t)         ;; enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Configure directory extension.
(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; vertico-repeat - resume the last minibuffer session with its input
;; and candidate intact (also ships with vertico).  Handy after you
;; abort a consult-ripgrep to check something and want it back.  The
;; history is persisted via `savehist-additional-variables'
(use-package vertico-repeat
  :ensure nil ; comes with vertico
  :after vertico
  :hook (minibuffer-setup . vertico-repeat-save)
  :bind ("M-R" . vertico-repeat))

;; Emacs minibuffer configurations.
(use-package emacs
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

;; orderless for fuzzy matching: https://github.com/oantolin/orderless
(use-package orderless
  :ensure nil
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Example configuration for Consult
(use-package consult
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
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s f" . consult-fd)                    ;; Alternative: consult-find
         ("M-s g" . consult-git-grep)
         ("M-s s" . consult-ripgrep)
         ("M-s M-s" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

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
;; complement to corfu's popup.  While a preview is visible TAB
;; accepts it and M-i completes up to the longest common prefix of
;; all candidates.
(use-package completion-preview
  :ensure nil
  :config
  ;; cycle through the other candidates (these commands exist, but
  ;; have no default bindings)
  (define-key completion-preview-active-mode-map (kbd "M-n") #'completion-preview-next-candidate)
  (define-key completion-preview-active-mode-map (kbd "M-p") #'completion-preview-prev-candidate)
  (global-completion-preview-mode +1))


;; treesitter

;; TODO setup treesitter with grammars installed through nix like here https://mort.io/blog/treesitting-emacs/

;; expand-region, tree-sitter edition
(use-package expreg
  :ensure nil                           ;; manual installation
  :bind (("C-+" . expreg-expand)
         ("C-=" . expreg-contract))
  :config
  (defvar expreg-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map "+" #'expreg-expand)
      (define-key map "=" #'expreg-contract)
      map))
  (put 'expreg-expand 'repeat-map 'expreg-repeat-map)
  (put 'expreg-contract 'repeat-map 'expreg-repeat-map))

;; TODO evaluate if needed

;; ghostel as libghostty based terminal in emacs: https://github.com/dakra/ghostel
;; projectile for project based config: https://docs.projectile.mx/projectile/index.html
;; corfu for local completion pop-ups: https://github.com/minad/corfu
;; cape for additional pop-ups: https://github.com/minad/cape
;; ghostel for modern terminal: https://github.com/dakra/ghostel
;; nerdicons dired: https://github.com/rainstormstudio/nerd-icons-dired
;; buffer nerd icons: https://github.com/seagle0128/nerd-icons-ibuffer/
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
