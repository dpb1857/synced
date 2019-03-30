
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Install which-key mode;
;;
;; Enable: M-x which-key-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'which-key)
  (package-refresh-contents)
  (package-install 'which-key))

(provide 'dpb-which-key)
