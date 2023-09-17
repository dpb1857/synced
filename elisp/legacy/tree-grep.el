
(require 'compile)

(defvar tree-grep-default-dir nil "Default directory for tree greps.")

(defun get-tree-grep-args(dir pattern)
  (interactive "DTopLevelDirectory: \nsSearch for pattern: ")
  (cons dir pattern))

(defun tree-grep ()
  (interactive)
  (let ((old-default-directory default-directory)
	(input nil))
    (if tree-grep-default-dir
	(setq default-directory tree-grep-default-dir))
    
    (setq input (call-interactively 'get-tree-grep-args))
    (setq default-directory (car input))
    (setq pattern           (cdr input))
    
    (compile-internal (concat "find . \\( -name \\*.[hc] -o -name \\*.c++ \\) -print "
		      "| xargs -n200 grep -n " pattern)
	      "No more tree-grep hits"
	      "tree-grep")

    (setq tree-grep-default-dir default-directory)
    (setq default-directory     old-default-directory)
    ))

(defun kill-tree-grep ()
  "Kill the process made by the \\[tree-grep] command."
  (interactive)
  (if compilation-process
      (interrupt-process compilation-process)))


(defun curr-error ()
  (interactive)
  (let ((fname nil)
	(linenum nil)
	(directory nil))
    (save-excursion
      (beginning-of-line 1)
      (re-search-forward "[^:]*")
      (setq fname (buffer-substring (match-beginning 0) (match-end 0)))
      (forward-char)
      (re-search-forward "[^:]*")
      (setq linenum 
	    (read (buffer-substring (match-beginning 0) (match-end 0))))

      (goto-char (point-min))
      (forward-char 3)
      (re-search-forward ".*")
      (setq directory (buffer-substring (match-beginning 0) (match-end 0))))
    (find-file-other-window (concat directory fname))
    (goto-char (point-min))
    (forward-line (- linenum 1))
    (select-window (previous-window))
    ))


(defun next-error (&optional argp)
  "Visit next compilation error message and corresponding source code.
This operates on the output from the \\[compile] command.
If all preparsed error messages have been processed,
the error message buffer is checked for new ones.
A non-nil argument (prefix arg, if interactive)
means reparse the error message buffer and start at the first error."
  (interactive "P")
  (if (or (eq compilation-error-list t)
	  argp)
      (progn (compilation-forget-errors)
	     (setq compilation-prev-error-list nil)  ;; dpb added;
	     (setq compilation-parsing-end 1)))
  (if compilation-error-list
      nil
    (save-excursion
      (switch-to-buffer "*compilation*")
      (set-buffer-modified-p nil)
      (compilation-parse-errors)))
  (let ((next-error (car compilation-error-list)))
    (if (null next-error)
	(error (concat compilation-error-message
		       (if (and compilation-process
				(eq (process-status compilation-process)
				    'run))
			   " yet" ""))))
    (setq compilation-prev-error-list
	  (cons next-error compilation-prev-error-list))
    (setq compilation-error-list (cdr compilation-error-list))
    (if (null (car (cdr next-error)))
	nil
      (switch-to-buffer (marker-buffer (car (cdr next-error))))
      (goto-char (car (cdr next-error))))
    (let* ((pop-up-windows t)
	   (w (display-buffer (marker-buffer (car next-error)))))
      (set-window-point w (car next-error))
      (set-window-start w (car next-error)))
      ))

(defun prev-error ()
  "Visit previous compilation error message and corresponding source code."
  (interactive)
  (if compilation-prev-error-list
      (let ((prev-error (car compilation-prev-error-list)))
	(if (< 1 (length compilation-prev-error-list))
	    (progn
	      (setq compilation-prev-error-list
		    (cdr compilation-prev-error-list))
	      (setq compilation-error-list
		    (cons prev-error compilation-error-list))
	      ))
	
	(if compilation-prev-error-list
	    (setq prev-error (car compilation-prev-error-list)))

	(if (null (car (cdr prev-error)))
	    nil
	  (switch-to-buffer (marker-buffer (car (cdr prev-error))))
	  (goto-char (car (cdr prev-error))))
	(let* ((pop-up-windows t)
	       (w (display-buffer (marker-buffer (car prev-error)))))
	  (set-window-point w (car prev-error))
	  (set-window-start w (car prev-error)))
	))
  )

(global-set-key "\^c."  'curr-error)
(global-set-key "\^cm"  'compile)
(global-set-key "\^c\`" 'prev-error)
(global-set-key "\^c\'" 'next-error)


