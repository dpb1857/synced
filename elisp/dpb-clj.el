
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

(unless (package-installed-p 'flycheck-clj-kondo)
  (package-refresh-contents)
  (package-install 'flycheck-clj-kondo))

(add-hook 'clojure-mode-hook 'enable-paredit-mode)

(global-set-key "\C-xcj" 'cider-jack-in)
(global-set-key "\C-xcb" 'cider-connect-cljs)

(setq cider-show-error-buffer nil)

(require 'cider)
(require 'paredit)
(require 'flycheck-clj-kondo)

(provide 'dpb-clj)
