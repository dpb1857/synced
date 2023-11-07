
;;;;;;;;;;;;;;;;;;;;
;; Ace Jump
;;;;;;;;;;;;;;;;;;;;

;; If this is ever problematic, checkout the package 'avy';
;; https://emacsredux.com/blog/2015/07/19/ace-jump-mode-is-dead-long-live-avy/

(unless (package-installed-p 'ace-jump-mode)
  (package-refresh-contents)
  (package-install 'ace-jump-mode))

(define-key global-map (kbd "C-`") 'ace-jump-mode)

(provide 'dpb-acejump)
