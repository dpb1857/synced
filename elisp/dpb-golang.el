

;;;;;;;;;;;;;;;;;;;;
;; Golang
;;;;;;;;;;;;;;;;;;;;

(unless (package-installed-p 'go-mode)
  (package-refresh-contents)
  (package-install 'go-mode))

(require 'go-mode)

(add-hook 'go-mode-hook
  (lambda()
    (setq tab-width 4)))

(add-hook 'before-save-hook 'gofmt-before-save)

(provide 'dpb-golang)
