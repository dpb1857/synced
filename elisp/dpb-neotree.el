
;;;;;;;;;;;;;;;;;;;;
;; Neotree
;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'neotree)
  (package-refresh-contents)
  (package-install 'neotree))

(provide 'dpb-neotree)
