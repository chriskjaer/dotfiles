(require 'ido)
(setq ido-enable-flex-matching t) ;; enables fuzzy matching
(setq ido-everywhere t)
(setq ido-auto-merge-work-directories-length -1)
(setq ido-create-new-buffer 'always)
(setq ido-ignore-extensions t)
(ido-mode t)

(provide 'ck-ido)
