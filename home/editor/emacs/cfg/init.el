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

;;; Code:

;; basic settings

(setq user-full-name "Felix Heinrichs"
      user-email-address "felix.heinrichs@gmail.com")

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

;; emacs cache directory
(defconst user-emacs-cache-directory
  (expand-file-name "emacs/" (or (getenv "XDG_CACHE_HOME") "~/.cache/"))
  "Directory where cached files for this user should be stored.")
(unless (file-exists-p user-emacs-cache-directory)
  (make-directory user-emacs-cache-directory :parents))

;; looks
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore) ;; no bell, TODO use a short flash https://emacs.stackexchange.com/questions/28906/how-to-switch-off-the-sounds

(blink-cursor-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)


;; appearance

(setq-default truncate-lines t)		              ;; no wrapping lines

;; line numbers
;; built-in and fastest option these days.  Only in buffers where the
;; numbers mean something - the global mode also turns them on in
;; magit, dired, ibuffer, REPLs and the like, where they're just noise
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))
;; (add-hook 'prog-mode-hook 'display-line-numbers-mode) ;; line numbers in all programming modes

;; mode line settings
(line-number-mode 1)
(column-number-mode 1)
(size-indication-mode 1)

;; ultra-scroll - buttery-smooth pixel-precision scrolling; a better
;; take on the built-in pixel-scroll-precision-mode (which it enables
;; and builds upon internally): faster, handles images taller than
;; the window and hides the cursor while scrolling
(use-package ultra-scroll
  :init
  (setq scroll-margin 0 ; ultra-scroll requires 0 for glitch-free scrolling
    scroll-conservatively 100000
    scroll-preserve-screen-position 1)
  :config
  (ultra-scroll-mode +1))

;;(add-to-list 'initial-frame-alist '(fullscreen . maximized))  ;; fullscreen on startup
;;(add-to-list 'default-frame-alist '(fullscreen . fullheight)) ;; full-height frames

(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 160)
;; (load-theme 'modus-operandi)
(load-theme 'modus-vivendi)		;; TODO automatic switching: https://emacsredux.com/blog/2026/03/29/automatic-light-dark-theme-switching/

;; highlight the current error in compilation/grep buffers
(setq next-error-message-highlight t)


;; environmental protection

;; TODO refactor this
;; store stuff there
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

;; mark
;; after C-u C-SPC, keep popping the mark ring with just C-SPC
;; instead of having to repeat the C-u prefix each time
(setq set-mark-command-repeat-pop t)

;; isearch
(setq isearch-lazy-count t)
(setq isearch-allow-motion t)
(delete-selection-mode 1)  ;; delete the selection with a keypress
(minibuffer-regexp-mode 1) ;; visual feedback for regex in minibuffer

(setq auto-revert-avoid-polling t) ;; automatic revert when underlying file changes
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; hippie expand
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand)

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
  ;; weeks in Bulgaria start on Monday
  (setq calendar-week-start-day 1))

;; highlight the current line
(use-package hl-line
  :config
  (global-hl-line-mode +1))

(use-package uniquify
  :ensure nil
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

;; TODO continue from https://github.com/bbatsov/emacs.d/blob/master/init.el


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

;; vertico for vertical command completion: https://github.com/minad/vertico
;; Vertico sorts by history position.
(use-package vertico
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 10) ;; Show 10 candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))


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
   '(read-only t cursor-intangible t face minibuffer-prompt)))


;; orderless for fuzzy matching: https://github.com/oantolin/orderless
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring


;; consult for search and navigation commands: https://github.com/minad/consult
;; marginalia for contextual hints in mini-buffers: https://github.com/minad/marginalia


;; TODO evaluate if needed

;; embark for contextual actions in (mini-)buffers: https://github.com/oantolin/embark
;; corfu for local completion pop-ups: https://github.com/minad/corfu
;; cape for additional pop-ups: https://github.com/minad/cape
;; ghostel for modern terminal: https://github.com/dakra/ghostel
;; nerdicons dired: https://github.com/rainstormstudio/nerd-icons-dired
;; buffer nerd icons: https://github.com/seagle0128/nerd-icons-ibuffer/
