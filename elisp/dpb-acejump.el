
;;;;;;;;;;;;;;;;;;;;
;; Ace Jump
;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'ace-jump-mode)
  (package-refresh-contents)
  (package-install 'ace-jump-mode))

(define-key global-map (kbd "C-`") 'ace-jump-mode)

(provide 'dpb-acejump)
