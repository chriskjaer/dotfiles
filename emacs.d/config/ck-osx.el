(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

(menu-bar-mode 1)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(defun ns-get-pasteboard ()
  "Returns the value of the pasteboard, or nil for unsupported formats."
  (condition-case nil
      (ns-get-selection-internal 'CLIPBOARD)
    (quit nil)))

(setq save-interprogram-paste-before-kill 'nil)

(provide 'ck-osx)
