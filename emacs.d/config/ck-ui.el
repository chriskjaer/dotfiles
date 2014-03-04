(defadvice load-theme  
  (before theme-dont-propagate activate) 
  (mapc #'disable-theme custom-enabled-themes))

(load-theme 'spacegray t)

(set-frame-font "Menlo")
(set-face-attribute 'default nil :height 130) ; Font size
(global-font-lock-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(scroll-bar-mode 0)
(tool-bar-mode 0)


(provide 'ck-ui)
