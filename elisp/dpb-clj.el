
;;;;;;;;;;;;;;;;;;;;
;; Clojure
;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'clojure-mode)
  (package-refresh-contents)
  (package-install 'clojure-mode))

(unless (package-installed-p 'cider)
  (package-refresh-contents)
  (package-install 'cider))

;; XXX Doesn't quite work; try again later; also, checkout this package:
;; https://github.com/clojure-emacs/squiggly-clojure
;;
;; (unless (package-installed-p 'flycheck-clojure)
;;   (package-refresh-contents)
;;   (package-install 'flycheck-clojure))

(require 'cider)

(provide 'dpb-clj)
