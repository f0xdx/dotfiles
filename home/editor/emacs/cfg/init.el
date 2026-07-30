;; basic

(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

;; TODO use a short flash https://emacs.stackexchange.com/questions/28906/how-to-switch-off-the-sounds
(setq ring-bell-function 'ignore)                     ;; no bell
(setq-default truncate-lines t)		              ;; no wrapping lines
(add-hook 'prog-mode-hook 'display-line-numbers-mode) ;; line numbers in all programming modes


;; appearance

(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 160)
;; (load-theme 'modus-operandi)
(load-theme 'modus-vivendi)		;; TODO automatic switching: https://emacsredux.com/blog/2026/03/29/automatic-light-dark-theme-switching/


;; packages

;; packages are managed through nix in home/editor/emacs/default.nix
;; loading them simply through (require '<package name>)
;; see also https://discourse.nixos.org/t/how-to-use-emacs-packages-installed-via-home-manager/2513
;; TODO evaluate use of autoload (load a function on use) instead of require


;; environmental protection

(defvar user-emacs-cache-directory
  (expand-file-name "emacs/" (or (getenv "XDG_CACHE_HOME") "~/.cache/"))
  "Directory where cached files for this user should be stored.")

(make-directory user-emacs-cache-directory :parents)

(setq auto-save-list-file-prefix (expand-file-name "saves-" user-emacs-cache-directory))


;; layers

(let ((default-directory (locate-user-emacs-file "layers/")))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

(use-package completion
  :defer t
  :hook (after-init . 'completion))
;;(require 'completion)


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
