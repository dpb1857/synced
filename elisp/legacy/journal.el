
;; Slightly modified version of add-log.el - dpb;


(defun add-work-log-entry (whoami file-name &optional other-window)
  "Find change log file and add an entry for today.
First arg (interactive prefix) non-nil means prompt for user name and site.
Second arg is file name of change log.
Optional third arg OTHER-WINDOW non-nil means visit in other window."
  (interactive
   (list current-prefix-arg
	 (let ((default
		 (if (eq system-type 'vax-vms) "$CHANGE_LOG$.TXT" "ChangeLog")))
	   (expand-file-name
	    (read-file-name (format "Log file (default %s): " default)
			    nil default)))))
  (let* ((default
	   (if (eq system-type 'vax-vms) "$CHANGE_LOG$.TXT" "ChangeLog"))
	 (full-name (if whoami
			(read-input "Full name: " (user-full-name))
		      (user-full-name)))
	 ;; Note that some sites have room and phone number fields in
	 ;; full name which look silly when inserted.  Rather than do
	 ;; anything about that here, let user give prefix argument so that
	 ;; s/he can edit the full name field in prompter if s/he wants.
	 (login-name (if whoami
			 (read-input "Login name: " (user-login-name))
		       (user-login-name)))
	 (site-name (if whoami
			(read-input "Site name: " (system-name))
		      (system-name))))
    (if (file-directory-p file-name)
	(setq file-name (concat (file-name-as-directory file-name)
				default)))
    (if other-window (find-file-other-window file-name) (find-file file-name))
    (or (eq major-mode 'indented-text-mode)
	(progn
	  (indented-text-mode)
	  (setq left-margin 8)
	  (setq fill-column 74)))
    (auto-fill-mode 1)
    (undo-boundary)
    (goto-char (point-min))
    (if (not (and (looking-at (substring (current-time-string) 0 10))
		  (save-excursion (re-search-forward "(.* at")
				  (skip-chars-backward "^(")
				  (looking-at login-name))))
	(progn (insert (substring (current-time-string) 0 10)
		       "  " full-name
		       "  (" login-name
		       " at " site-name ")\n\n")))
    (goto-char (point-min))
    (forward-line 1)
    (while (looking-at "\\sW")
      (forward-line 1))
    (delete-region (point)
		   (progn
		     (skip-chars-backward "\n")
		     (point)))
    (open-line 3)
    (forward-line 2)
    ;; (indent-to left-margin)
    ;; (insert "* ")
    (insert "  ")
    (insert-string (substring (current-time-string) 11 19))
    (insert-string " - \n        ")
    (setq left-margin (current-column))
    ))

(defun update-work-log ()
  (interactive)
  (let ((logname (concat (getenv "HOME") "/info/journal/worklog-"
			;; (substring (current-time-string) 4 7) "-"
			(substring (current-time-string) 20 24))
		 ))
    (add-work-log-entry nil logname)
    ))

(defun update-journal ()
  (interactive)
  (let ((logname (concat (getenv "HOME") "/info/journal/journal-"
			;; (substring (current-time-string) 4 7) "-"
			(substring (current-time-string) 20 24))
		 ))
    (add-work-log-entry nil logname)
    ))

