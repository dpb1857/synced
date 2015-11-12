
;; found on the web;
;; http://emacsblog.org/2007/01/17/indent-whole-buffer/

(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(provide 'iwb)
