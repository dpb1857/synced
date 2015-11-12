
;;;;;;;;;;;;;;;;;;;;
;; Clojure
;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'clojure-mode)
  (package-refresh-contents)
  (package-install 'clojure-mode))

(unless (package-installed-p 'cider)
  (package-refresh-contents)
  (package-install 'cider))

(require 'cider)

(provide 'dpb-clj)
