(add-to-list 'load-path (concat user-emacs-directory "/config"))
(setq inhibit-splash-screen t)

(setq package-archives '(("org" . "http://orgmode.org/elpa/")
			 ("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

(require 'package)
(package-initialize)

(defvar my-packages '( ;; Core
		      auto-complete
		      dired-details
		      magit
		      evil
		      linum-relative
		      exec-path-from-shell	      
		      key-chord
		      rainbow-delimiters
		      
		      ;; Searching
		      ag
		      findr fiplr grizzl

		      ;; Color Themes
		      spacegray-theme

		      ;; Web Development
		      emmet-mode
		      haml-mode scss-mode js3-mode jade-mode
		      web-mode))

(defun my-missing-packages ()
  (let (missing-packages)
    (dolist (package my-packages missing-packages)
      (push package missing-packages))))

(let ((missing (my-missing-packages)))
  (when missing
    ;; Check for new packages (package versions)
    (package-refresh-contents)
    ;; Install the missing packages
    (mapc (lambda (package)
            (when (not (package-installed-p package))
              (package-install package))) missing)
    ;; Close the compilation log.
    (let ((compile-window (get-buffer-window "*Compile-Log*")))
      (if compile-window
          (delete-window compile-window)))))

(when (memq window-system '(mac ns))
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

;; Config
(require 'ck-keybindings)
(require 'ck-misc)
(require 'ck-ui)
(require 'ck-evil)
(require 'ck-ido)
(require 'ck-web)
(require 'ck-editor)



(if (eq system-type 'darwin)
    (require 'ck-osx))
