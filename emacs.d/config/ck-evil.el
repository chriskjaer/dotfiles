(require 'evil)
(require 'key-chord)
(key-chord-mode t)

(evil-mode 1)
(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)

(provide 'ck-evil)
