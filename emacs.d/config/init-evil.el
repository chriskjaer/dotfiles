;; Evil Settings
(require-package 'evil)
(evil-mode 1)

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
