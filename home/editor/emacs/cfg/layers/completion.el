;; completion


;; vertico for vertical command completion: https://github.com/minad/vertico

(use-package vertico
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 10) ;; Show 10 candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))


;; Persist history over Emacs restarts. Vertico sorts by history position.

(use-package savehist
  :custom
  (setq savehist-file (expand-file-name "history" user-emacs-cache-directory))
  :init
  (savehist-mode))


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

(provide 'completion)
