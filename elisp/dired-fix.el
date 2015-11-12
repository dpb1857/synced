
(add-hook 'dired-load-hook
	  (lambda()
	    (setq dired-use-ls-dired nil)))

(provide 'dired-fix)
