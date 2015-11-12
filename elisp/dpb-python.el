
;; Python mode setup;

(require 'python-mode)

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))

(autoload 'python-mode "python-mode" "Python editing mode." t)

;; lambda-mode;
;; (require 'lambda-mode)
;; (add-hook 'python-mode-hook #'lambda-mode 1)
;; (setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))

(provide 'dpb-python)
