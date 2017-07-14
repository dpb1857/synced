
;;;;;;;;;;;;;;;;;;;;
;; Docker
;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'docker)
  (package-refresh-contents)
  (package-install 'docker))

(provide 'dpb-docker)
