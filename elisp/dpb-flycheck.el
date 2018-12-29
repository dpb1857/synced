
(unless (package-installed-p 'flycheck)
  (package-refresh-contents)
  (package-install 'flycheck))

(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'flycheck)

;; Add mypy to the python checkers;
;; from https://www.reddit.com/r/emacs/comments/7dbunc/emacs_python_36_type_checking_support_using_mypy/

(flycheck-define-checker
    python-mypy ""
    :command ("mypy"
              "--ignore-missing-imports"
              "--python-version" "3.6"
              source-original)
    :error-patterns
    ((error line-start (file-name) ":" line ": error:" (message) line-end))
    :modes python-mode)

(add-to-list 'flycheck-checkers 'python-mypy t)
(flycheck-add-next-checker 'python-pylint 'python-mypy t)


(provide 'dpb-flycheck)
