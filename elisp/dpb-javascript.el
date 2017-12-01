
;; Javascript/jsx setup;

;; much taken from http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html
;; XXX re-read if we want better linting of our javascript...


;; Install js2-mode;

(unless (package-installed-p 'js2-mode)
  (package-refresh-contents)
  (package-install 'js2-mode))

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; Install web-mode;

(unless (package-installed-p 'web-mode)
  (package-refresh-contents)
  (package-install 'web-mode))

(require 'web-mode)
;; from http://cha1tanya.com/2015/06/20/configuring-web-mode-with-jsx.html
(setq web-mode-content-types-alist
  '(("jsx" . "\\.js[x]?\\'")))

;;
;; Install json mode;
;;

(unless (package-installed-p 'json-mode)
  (package-refresh-contents)
  (package-install 'json-mode))

;;
;; Use eslint;

(setq-default flycheck-disabled-checkers
	(append flycheck-disabled-checkers
	        '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; (require 'json-mode)

(provide 'dpb-javascript)
