
;; Javascript/jsx setup;

;; much taken from http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html


;; Install js2 mode;

(unless (package-installed-p 'js2-mode)
  (package-refresh-contents)
  (package-install 'js2-mode))

(require 'js2-mode)

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


(require 'json-mode)

(provide 'dpb-javascript)
