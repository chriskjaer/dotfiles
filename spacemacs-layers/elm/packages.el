;;; packages.el --- elm Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq elm-packages
    '(
      elm-mode
      ))

;; List of packages to exclude.
(setq elm-excluded-packages '())

;; For each package, define a function elm/init-<package-elm>
;;
(defun elm/init-elm-mode ()
  (use-package elm-mode
    :defer t
    :init
    (progn
      (add-to-list 'auto-mode-alist '("\\.elm\\'" . elm-mode)))
    :config
    (progn
      (evil-leader/set-key-for-mode 'elm-mode
        "mcb" 'elm-compile-buffer
        "mcm" 'elm-complile-main
        "msb" 'load-elm-repl
        "msr" 'push-elm-repl
        "mpb" 'elm-preview-buffer
        "mpm" 'elm-preview-main
      ))
  ))
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
