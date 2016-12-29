
(unless (package-installed-p 'smooth-scrolling)
  (package-refresh-contents)
  (package-install 'smooth-scrolling))

(unless (package-installed-p 'sublimity)
  (package-refresh-contents)
  (package-install 'sublimity))

(require 'smooth-scrolling)

(require 'sublimity)
(require 'sublimity-scroll)
(require 'sublimity-map)

(provide 'dpb-smooth)
