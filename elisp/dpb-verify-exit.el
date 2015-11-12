
;;
;; Verify we reall want to exiton ^x-^c; 
;;

(defun dpb-exit ()
   "dpb's safe exit function"
   (interactive)
   (if (y-or-n-p "Do you *really* want to exit? ")
       (save-buffers-kill-emacs))
   )

(global-set-key "\^x\^c" 'dpb-exit)

(provide 'dpb-verify-exit)
