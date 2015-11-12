
;; truncate-toggle

(defun truncate-toggle()
  "Toggle the value of the truncate-lines variable in the current buffer."
  (interactive)
  (setq truncate-lines (not truncate-lines)))

(global-set-key "\^xt" 'truncate-toggle)

(provide 'dpb-truncate-toggle)
