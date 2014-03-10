(defadvice load-theme  
  (before theme-dont-propagate activate) 
  (mapc #'disable-theme custom-enabled-themes))

(load-theme 'spacegray t)

(set-default-font "Menlo-Reguar 14")

(defalias 'yes-or-no-p 'y-or-n-p)

(scroll-bar-mode 0)
(tool-bar-mode 0)

;; line number settings
(setq linum-format " %d  ")

(provide 'ck-ui)
