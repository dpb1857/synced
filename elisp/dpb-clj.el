
;;;;;;;;;;;;;;;;;;;;
;; Clojure
;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'clojure-mode)
  (package-refresh-contents)
  (package-install 'clojure-mode))

(unless (package-installed-p 'cider)
  (package-refresh-contents)
  (package-install 'cider))

(unless (package-installed-p 'paredit)
  (package-refresh-contents)
  (package-install 'paredit))

(add-hook 'clojure-mode-hook 'enable-paredit-mode)

;; XXX Doesn't quite work; try again later; also, checkout this package:
;; https://github.com/clojure-emacs/squiggly-clojure
;;
;; (unless (package-installed-p 'flycheck-clojure)
;;   (package-refresh-contents)
;;   (package-install 'flycheck-clojure))

(require 'cider)
(require 'paredit)

(provide 'dpb-clj)
