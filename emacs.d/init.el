;; packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")))

(package-initialize)


;; Custom package require
;; Install if not installed and then require, else require.
(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
  (unless (assoc package package-archive-contents)
    (package-refresh-contents))
    (package-install package)))


;; Enable clipboard support in insert mode
(setq x-select-enable-clipboard t)

;; better scrolling
(setq scroll-conservatively 9999
      scroll-preserve-screen-position t)

;; Sensible encoding defaults
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Indentation
(setq indent-tabs-mode nil)
(setq tab-width 2)

;; Indent after RET
(global-set-key (kbd "RET") 'newline-and-indent)

;; Tell me when there's an easier shortcut
(setq suggest-key-bindings t)

;; Eye Candy
(show-paren-mode)
(setq show-paren-delay 0)

(column-number-mode t)
(display-time-mode t)
(size-indication-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (base16-default)))
 '(custom-safe-themes (quote ("4cb3034cbb7fd36bf0989fad19cac0beb818472854a7cbc8d2a597538b1f2cf0" default))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'load-path (concat user-emacs-directory "config"))
;;(require 'init-evil)

