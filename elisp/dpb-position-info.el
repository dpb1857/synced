;;
;; position-info
;;

(defun position-info ()
   "Tell cursor position and line number."
   (interactive)
   (what-line)
   (sleep-for 1)
   (what-cursor-position))

(global-set-key "\^x=" 'position-info)

(provide 'dpb-position-info)
