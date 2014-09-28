;; packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")))
(package-initialize)

(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

(require 'evil)
(evil-mode 1)

;; Enable clipboard support in insert mode
(setq x-select-enable-clipboard t)

;; We want all the backups to be together in a single folder, not littered around everywhere.
(setq backup-directory-alist `(("." . "~/.emacs-saves")))

;; Disable menu bar
(unless (display-graphic-p) (menu-bar-mode -1))

;; Shamelessly copied from https://github.com/bling/dotemacs, enables proper curser state i terminal emacs with evil.
(defun my-send-string-to-terminal (string)
    (unless (display-graphic-p) (send-string-to-terminal string)))

(defun my-evil-terminal-cursor-change ()
    (when (string= (getenv "TERM_PROGRAM") "iTerm.app")
          (add-hook 'evil-insert-state-entry-hook (lambda () (my-send-string-to-terminal "\e]50;CursorShape=1\x7")))
	  (add-hook 'evil-insert-state-exit-hook  (lambda () (my-send-string-to-terminal "\e]50;CursorShape=0\x7"))))
    (when (and (getenv "TMUX") (string= (getenv "TERM_PROGRAM") "iTerm.app"))
	  (add-hook 'evil-insert-state-entry-hook (lambda () (my-send-string-to-terminal "\ePtmux;\e\e]50;CursorShape=1\x7\e\\")))
	  (add-hook 'evil-insert-state-exit-hook  (lambda () (my-send-string-to-terminal "\ePtmux;\e\e]50;CursorShape=0\x7\e\\")))))

(add-hook 'after-make-frame-functions (lambda (frame) (my-evil-terminal-cursor-change)))
(my-evil-terminal-cursor-change)

;; better scrolling
(setq scroll-conservatively 9999
      scroll-preserve-screen-position t)

;; Sensible encoding defaults
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)


;; Eye Candy
(show-paren-mode)
(setq show-paren-delay 0)

(line-number-mode t)
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
