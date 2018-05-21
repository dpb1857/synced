

;;;;;;;;;;;;;;;;;;;;
;; Golang
;;;;;;;;;;;;;;;;;;;;

;; Dependencies -

;; godef:
;; go get -u github.com/rogpeppe/godef
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

(unless (package-installed-p 'go-guru)
  (package-refresh-contents)
  (package-install 'go-guru))

(unless (package-installed-p 'go-dlv)
  (package-refresh-contents)
  (package-install 'go-dlv))

(require 'go-mode)
(require 'go-eldoc)
(require 'go-guru)
(require 'go-dlv)

(add-hook 'go-mode-hook
  (lambda()
    (setq tab-width 4)))

(add-hook 'go-mode-hook 'go-eldoc-setup)

(add-hook 'before-save-hook 'gofmt-before-save)

;; (go-guru-hl-identifier-mode)
(add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)

(provide 'dpb-golang)
;;; dpb-golang.el ends here
