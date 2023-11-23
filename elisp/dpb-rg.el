
;; add rg (ripgrep) support

(unless (package-installed-p 'rg)
  (package-refresh-contents)
  (package-install 'rg))

(require 'rg)
(setq wgrep-auto-save-buffer t)

(provide 'dpb-rg)
