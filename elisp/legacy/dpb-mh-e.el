(require 'mh-e)
(require 'mh-comp)

(defun dpb-reply-to-header ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (if (re-search-forward "^Reply-To: .*@" nil t)
	(progn
	  (if (looking-at "esd\\.")
	      (delete-char 4)
	    (insert "esd.")))
      (re-search-forward "^--------")
      (beginning-of-line 1)
      (open-line 1)
      (insert "Reply-To: dpb@infoseek.com")
      )))

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

(defun dpb-fcc-header ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (if (re-search-forward "^Reply-To: .*@" nil t)
	(progn
	  (if (looking-at "esd\\.")
	      (delete-char 4)
	    (insert "esd.")))
      (re-search-forward "^--------")
      (beginning-of-line 1)
      (open-line 1)
      (insert "Fcc: +cc")
      )))

(define-key mh-folder-mode-map "\^xn"    'gnus-func)
(define-key mh-letter-mode-map "\C-cr" 'dpb-reply-to-header)
(define-key mh-letter-mode-map "\C-cc" 'dpb-fcc-header)


;;; Functions added for METAMAIL support

(require 'transparent)

(defvar mh-never-execute-automatically t "*Prevent metamail from
happening semi-automatically")

(define-key mh-folder-mode-map "@" 'mh-execute-content-type)

(defun mh-check-content-type ()
  "Check for certain Content Type headers in mail"
  (mh-maybe-execute-content-type nil))

(defun mh-execute-content-type ()
  "Check for certain Content Type headers in mail"
  (interactive)
  (mh-maybe-execute-content-type t))

(defun mh-exec-metamail-cmd-output (command &rest args)
  ;; Execute MH library command COMMAND with ARGS.
  ;; Put the output into buffer after point.  Set mark after inserted text.
  (push-mark (point) t)
  (erase-buffer)
  (apply 'call-process
	 command nil t nil
	 (mh-list-to-string args))
  (exchange-point-and-mark)
  (set-buffer-modified-p nil)
  (other-window -1))

(defun mh-handle-content-type (ctype override)
  (let (oldpt
        (fname (make-temp-name "/tmp/rmailct")))
    
    (cond
     ((and mh-never-execute-automatically (not override))
      (progn
       (message (concat "You can use '@' to run an interpreter for this '"
                        ctype "' format mail."))))
     ((or override
          (getenv "MM_NOASK")
          (y-or-n-p (concat "Run an interpreter for this '"
                            ctype "' format mail? ")))
      (progn
       (save-restriction
        (goto-char (point-max))
        (setq oldpt (point))
        (goto-char 0)
        (widen)
        (write-region
         (point)
         oldpt
         fname
         'nil
         "silent"))
       (if 
	   (and window-system (getenv "DISPLAY"))
	   (mh-exec-metamail-cmd-output "metamail" "-m" "mh-e" "-x" "-d"
					"-q" fname)
	 (progn
	   (other-window -1)
	   (switch-to-buffer "METAMAIL")
	   (erase-buffer)
	   (sit-for 0)
	   (transparent-window
	    "METAMAIL"
	    "metamail"
	    (list "-m" "mh-e" "-p" "-d" "-q" fname)
	    nil
	    (concat
	     "\n\r\n\r*****************************************"
	     "*******************************\n\rPress any key "
	     "to go back to EMACS\n\r\n\r***********************" 
	     "*************************************************\n\r"))))))
     (t (progn
	  (message (concat "You can use the '@' keystroke to "
			   "execute the external viewing program.")))))))

(defun mh-maybe-execute-content-type (dorun)
  "Check for certain Content Type headers in mail"
  (cond
   ((not (getenv "NOMETAMAIL"))
    (save-restriction
     (setq buffer-read-only 'nil)
     (let ((headend 0)
	   (ctype "text/plain")
           (old-min (point-min))
           (old-max (point-max))
	   (opoint 0))
       (if mh-show-buffer (pop-to-buffer mh-show-buffer))
       (goto-char (point-min))
       (forward-line 1)
       (goto-char (point-min))
       (search-forward "\n\n" nil 1)
       (setq headend (point))
       (setq opoint (- headend 1))
       (goto-char (point-min))    
       (setq case-fold-search 'T)
       (cond
	((search-forward "\ncontent-type:" opoint 't)
	 (progn
          (forward-word 1)	(backward-word 1)  ; Took care of white space
	  (setq opoint (point))
	  (re-search-forward "[;\n]" (point-max) t)
	  (setq ctype (downcase (buffer-substring opoint (- (point) 1))))
          (goto-char (point-min)))))
	(cond ((and (not (string= (downcase ctype) "text"))
                    (not (string= (downcase ctype) "text/plain"))
                    (not (string= (downcase ctype)
                                  "text/plain; charset=us-ascii")))
	      (mh-handle-content-type
	       ctype dorun))
             ))))))

(provide 'dpb-mh-e)
