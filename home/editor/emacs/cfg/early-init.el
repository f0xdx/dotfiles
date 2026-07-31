;;; early-init.el --- f0xdx's Emacs early init file
;;
;; Copyright (c) 2016-2026 Felix Heinrichs
;;
;; Author: Felix Heinrichs <felix.heinrichs@gmail.com>
;; URL: https://github.com/f0xdx/dotfiles

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Settings that to be applied before the initial frame is
;; created and before package.el is loaded.

;;; Code:

;; temporarily raise GC threshold
(setq gc-cons-threshold 1073741824) ;; 1 GB (* 1024 1024 1024)
;; reset after to have frequent short pauses instead of long freezes
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 50331648 ;; 48 MB (* 48 1024 1024)
                  gc-cons-percentage 0.2)))  ;; heap proportion if > threshold

;; disable toolbar with frame parameters to prevent resize, maximize
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(fullscreen . maximized) initial-frame-alist)
(setq frame-inhibit-implied-resize t) ;; don't resize, frame is maximized

;; native-compile packages when they are installed, instead of
;; stalling when they get loaded for the first time
(setq package-native-compile t)
;; Prefer loading newer compiled files
(setq load-prefer-newer t)

;; GUI Emacs on macOS doesn't inherit the environment from the shell,
;; so without LANG it ends up in the "C" locale, which breaks things
;; like spell-checking dictionaries and subprocess sorting
(when (and (eq system-type 'darwin) (not (getenv "LANG")))
  (setenv "LANG" "en_US.UTF-8"))
