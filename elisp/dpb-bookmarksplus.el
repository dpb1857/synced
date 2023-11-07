;; Read about Bookmark Plus: https://www.emacswiki.org/emacs/BookmarkPlus
;; from comments tetris11 on https://www.emacswiki.org/emacs/BookmarkPlus#h5o-9 ;

(let ((bookmarkplus-dir "~/synced/elisp/bookmark-plus/")
      (emacswiki-base "https://www.emacswiki.org/emacs/download/")
      (bookmark-files '("bookmark+.el" "bookmark+-mac.el" "bookmark+-bmu.el" "bookmark+-key.el" "bookmark+-lit.el" "bookmark+-1.el")))
  (require 'url)
  (add-to-list 'load-path bookmarkplus-dir)
  (make-directory bookmarkplus-dir t)
  (mapcar (lambda (arg)
            (let ((local-file (concat bookmarkplus-dir arg)))
              (unless (file-exists-p local-file)
                (url-copy-file (concat emacswiki-base arg) local-file t))))
          bookmark-files)
  (byte-recompile-directory bookmarkplus-dir 0)
  (require 'bookmark+))

(provide 'dpb-bookmarksplus)
