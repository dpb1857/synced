
;; Python mode setup;

(unless (package-installed-p 'python-mode)
  (package-refresh-contents)
  (package-install 'python-mode)
  ;; (package-install 'pydoc)
  )

(require 'python-mode)
;; pydoc not really doing it for me; 12/14/18; maybe next time.
;; (require 'pydoc)

;; (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))

;; (setq interpreter-mode-alist (cons '("python" . python-mode)
;;				   interpreter-mode-alist))

;; (autoload 'python-mode "python-mode" "Python editing mode." t)

;; lambda-mode;
;; (require 'lambda-mode)
;; (add-hook 'python-mode-hook #'lambda-mode 1)
;; (setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))

;; http://ergoemacs.org/emacs/emacs_pretty_lambda.html
;; fun, but not doing it, at least in python-mode;
;; (defun my-add-pretty-lambda ()
;;   "make some word or string show as pretty Unicode symbols"
;;   (setq prettify-symbols-alist
;;         '(
;;           ("lambda" . 955) ; λ
;;           ;; ("->" . 8594)    ; →
;;           ;; ("=>" . 8658)    ; ⇒
;;           ;; ("map" . 8614)   ; ↦
;;           )))
;;
;; (add-hook 'python-mode-hook 'my-add-pretty-lambda)

(setq pylint-disables "
# Find pylint codes at: http://pylint-messages.wikidot.com/all-codes
# pylint: disable=line-too-long
# pylint: disable=invalid-name
# pylint: disable=missing-docstring
# pylint: disable=too-few-public-methods
# pylint: disable=superfluous-parens

")

(defun pylint-disables ()
  (interactive)
  "Insert standard set of pylint disable settings at the top of the buffer"
  (save-excursion
    (goto-char (point-min))
    (next-line 1)
    (insert pylint-disables)
    ))


;; Disable those automatic definition pop-up buffers, add key to popup help;
(global-eldoc-mode -1)
(global-set-key "\^h@" 'py-eldoc)
;; See: https://www.flycheck.org/en/latest/languages.html#Python
;; (setq flycheck-python-pylint-executable "pylint")

(provide 'dpb-python)
