
;;;;;;;;;;;;;;;;;;;;
;; Groovy
;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'groovy-mode)
  (package-refresh-contents)
  (package-install 'groovy-mode))

(provide 'dpb-groovy-mode)
