

;;;;;;;;;;;;;;;;;;;;
;; Golang
;;;;;;;;;;;;;;;;;;;;

;; Dependencies -

;; godef:
;; go get code.google.com/p/rog-go/exp/cmd/godef
;;
;; gocode:
;; go get -u github.com/nsf/gocode

;;; Code:
(unless (package-installed-p 'go-mode)
  (package-refresh-contents)
  (package-install 'go-mode))

(unless (package-installed-p 'go-eldoc)
  (package-refresh-contents)
  (package-install 'go-eldoc))

(require 'go-mode)
(require 'go-eldoc)

(add-hook 'go-mode-hook
  (lambda()
    (setq tab-width 4)))

(add-hook 'go-mode-hook 'go-eldoc-setup)

(add-hook 'before-save-hook 'gofmt-before-save)

(provide 'dpb-golang)
;;; dpb-golang.el ends here
