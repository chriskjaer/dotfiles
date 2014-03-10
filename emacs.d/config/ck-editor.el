
(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

(require 'grizzl)
(require 'fiplr)
(setq fiplr-root-markers '(".git" ".svn" "node_modules" "source")) 
(setq fiplr-ignored-globs '((directories (".git" ".svn" "node_modules" "build"))
                            (files ("*.jpg" "*.png" "*.zip" "*~"))))

(global-set-key (kbd "C-c p") 'fiplr-find-file)

(electric-pair-mode 1)

(show-paren-mode 1) ; turn on paren match highlighting

(provide 'ck-editor)
