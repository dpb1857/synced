(require 'mh-e)

(defun dpb-reply-to-header ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (re-search-forward "^--------")
    (beginning-of-line 1)
    (open-line 1)
    (insert "Reply-To: dpb@netcom.com")
    ))

(defun dpb-delete-fcc-header ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (if (re-search-forward "Fcc:" nil t)
	(progn
	  (beginning-of-line 1)
	  (kill-line 1)
	  ))
    ))

(defun dpb-x20soft ()
  (interactive)
  (mh-send-sub "x20soft" "dpb" ""
	       (current-window-configuration)))

(defun dpb-xpert ()
  (interactive)
  (mh-send-sub "xpert@expo.lcs.mit.edu" "dpb" ""
	       (current-window-configuration))
  (dpb-reply-to-header)
  (save-excursion
    (insert-file-contents "~/.signature"))
  (open-line 2)
  )

(defun dpb-xbug ()
  (interactive)
  (mh-send-sub "qadbugload,hp20bugmail" "dpb" "Generic X11: "
	       (current-window-configuration))

  (insert-string "Product:\tMkr2.0GenericX11\n")
  (insert-string "Title:\t\tGeneric X:\n")
  (insert-string "Program Name:\tmaker\n")
  (insert-string "Version #:\t2.1d1 - software release\n")
  (insert-string "Machine/OS:\t\n")
  (insert-string "Reproducible:\t\n")
  (insert-string "Severity:\t\n")
  (insert-string "Contact:\tdpb\n")
  (insert-string "Confirmation:\tn\n")
  (insert-string "Send Mail:\tn\n")
  (insert-string "Description:\n\n")
  (insert-string "Reported by dpb on ")
  (insert-string (current-time-string))
  (insert-string "\n\n")
  (beginning-of-buffer)
  (forward-line 2)
  (end-of-line)
  )

(defun dpb-motif-talk ()
  (interactive)
  (mh-send-sub "motif-talk@osf.org" "dpb" ""
	       (current-window-configuration))
  (dpb-reply-to-header)
  (save-excursion
    (insert-file-contents "~/.signature"))
  (open-line 2)
  )

(defun current-number ()
  ;; (interactive)
  (let ((linenum nil)
	)
    (save-excursion
      (re-search-backward "[ \t\n]")
      (re-search-forward "[0-9]+")
      
      (setq linenum 
	    (read (buffer-substring (match-beginning 0) (match-end 0))))
      linenum
      )
    ))

(defun buginfo ()
  (interactive)
  (let ((bugnum (current-number))
	)
    (mh-send-sub "qadbugrept" "" ""
		 (current-window-configuration))
    (dpb-delete-fcc-header)
    (insert-string "dbdata\n")
    (insert-string (format "full -n %s -m dpb\n" bugnum))
    (mh-send-letter)
    ))

(defun fast-buginfo ()
  (interactive)
  (let* ((bugnum (current-number))
	 (dirnum (+ (/ bugnum 300) 1))
	 )
    (find-file (format "/usr/database/fminfo/qabug_desc/dir%s/%s"
			  dirnum bugnum))
    ))

(define-key mh-folder-mode-map "\C-c\C-h" 'dpb-hours)
(define-key mh-folder-mode-map "\C-c\C-x" 'dpb-x20soft)
(define-key mh-folder-mode-map "\C-cx"   'dpb-xpert)
(define-key mh-folder-mode-map "\C-cb"   'dpb-xbug)
(define-key mh-folder-mode-map "\C-cm"   'dpb-motif-talk)
(define-key mh-folder-mode-map "\^xn"    'gnus-func)

(define-key mh-letter-mode-map "\C-cr" 'dpb-reply-to-header)


;; (global-set-key "\^cb" 'buginfo)
(global-set-key "\^cb" 'fast-buginfo)

(defun basename (name)
  (if (null name)
      nil
    (string-match ".*/" name)
    (substring name (match-end 0))
    ))

(defun bug-close ()
  (interactive)
  (let* ((bugnum (current-number))
	 (fname  (basename buffer-file-name))
	 (productname
	  (cond
	   ((equal fname "generic3x.dpb")
	    "MkrGenericX11"
	    )
	   ((equal fname "motifx.dpb")
	    "MkrMotifX11"
	    )))
	)
    (if (null fname)
	(message "Buffer has no filename")
      (mh-send-sub "qadbugfix" "" ""
		   (current-window-configuration))
      ;; (dpb-delete-fcc-header)
      (insert-string "dbdata\n")
      (insert-string (format "%s %s C 3.0P1a\n" bugnum productname))
      ;; (mh-send-letter)
      )
    ))
