;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CC Mode configuration;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Behave like c-lineup-arglist-intro-after-paren if there is anything
;; after the paren, otherwise backup to indent the basic indentation
;; past the start of the function using the arglist;

(defun c-dpb-lineup-arglist-intro (langelem)
  ;; lineup an arglist-intro line to just after the open paren
  (save-excursion
    (let ((cs-curcol (save-excursion
		       (goto-char (cdr langelem))
		       (current-column)))
	  (open-paren (save-excursion
			(beginning-of-line)
			(backward-up-list 1)
			(current-column)))
	  (open-paren-and-skip (save-excursion
				 (beginning-of-line)
				 (backward-up-list 1)
				 (skip-chars-forward " \t" (c-point 'eol))
				 (current-column)))
	  (open-paren-and-back (save-excursion
				 (beginning-of-line)
				 (backward-up-list 1)
				 (skip-chars-backward " \t" (c-point 'bol))
				 (skip-chars-backward "a-zA-Z0-9_" (c-point 'bol))
				 (current-column)))
	  )
      (cond
       ;; If there *was* a reason for that extra skip-chars-forward " \t";
       ((> open-paren-and-skip open-paren)
	(- open-paren cs-curcol -1))

       ;; If the function name is too short to merit a full c-basic-offset from
       ;; the start of the function name;
       ((> c-basic-offset (- open-paren open-paren-and-back))
	(- open-paren cs-curcol -1))

       ;; Indent c-basic-indent past the start of the function name;
       (t
	(+ (- open-paren-and-back cs-curcol) c-basic-offset))
       )
      )))


(add-hook 'c-mode-common-hook
      '(lambda ()
	 (setq c-basic-offset 4)
	 (c-set-offset 'substatement-open 0)
	 (c-set-offset 'case-label 2)
	 (c-set-offset 'statement-case-intro 2)
	 (c-set-offset 'arglist-intro 'c-dpb-lineup-arglist-intro)
	 (define-key c-mode-map "\C-m" 'newline-and-indent)
	 (turn-on-font-lock)
	 ))


(provide 'dpb-cc-mode-setup)
