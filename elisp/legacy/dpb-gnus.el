
(autoload 'gnus "gnus" "Read network news." t)
(autoload 'gnus-post-news "gnus" "Post news." t)

(setq gnus-your-domain "netcom.com")
(setq gnus-your-organization "Netcom Online Services")
(setq gnus-use-generic-from t)
(setq gnus-novice-user nil)


;; (setq gnus-author-copy "|mail dpb")

(defun dpb-gnus-doit()
  (goto-char (point-min))
  (re-search-forward "^Subject: ")
  (insert-string "POST "))

(defun dpb-gnus-undoit()
  (goto-char (point-min))
  (re-search-forward "^Subject: ")
  (delete-char 5))

(defun dpb-deliver-cc()
  (goto-char (point-min))
  (re-search-forward "^Subject:.*\n")
  (insert-string "cc: dpb\n")
  (funcall gnus-mail-send-method)
  (delete-char -8))

;; (setq gnus-inews-article-hook
(setq news-inews-hook
      (list (function dpb-gnus-doit)
	    (function dpb-deliver-cc)
	    (function dpb-gnus-undoit)))

(setq gnus-prepare-article-hook nil); No auto-insert of .signature; 


;; Mark isn't set, causing certain things to blow up;
(defun dpb-mail-using-mhe (&optional yank)
  (gnus-mail-reply-using-mhe yank)
  (set-mark (point)))

(defun dpb-mail-other-window ()
  (gnus-mail-other-window-using-mhe)
  (set-mark (point)))

(setq mail-fwd-keep-headers
      '("date" "from" "to" "cc" "subject"))

(defun dpb-gnus-forward-article()
  "Forward an article to someone else."
  (interactive)
  (gnus-summary-select-article)
  (switch-to-buffer gnus-article-buffer)
  (widen)
  (delete-other-windows)
  (bury-buffer gnus-article-buffer)
  ;; (gnus-summary-mail-reply t)
  ;; (funcall gnus-mail-reply-method yank)
  ;; (gnus-mail-other-window-using-mhe)
  (let (from cc subject date to reply-to (buffer (current-buffer)))
    (save-restriction
      (gnus-article-show-all-headers)	;I don't think this is really needed.
      (setq from (gnus-fetch-field "from")
	    subject (concat "FYI: " (gnus-fetch-field "subject"))
	    reply-to (gnus-fetch-field "reply-to")
	    cc (gnus-fetch-field "cc")
	    date (gnus-fetch-field "date"))
      (setq mh-show-buffer buffer)
      (setq to (read-string "To: "))
      (mh-find-path)
      (mh-send to "" subject)
      (setq mh-sent-from-folder buffer)
      (setq mh-sent-from-msg 1)
      ))
  (let ((last (point))
	(mh-yank-hooks nil))
    (mh-yank-cur-msg)
    (goto-char last)
    (if (looking-at "^From ")
	(delete-region (point)
		       (progn (forward-line 1)
			      (point)))
      ))
  (let ((loc1 (point))
	(loc2 (if (re-search-forward "\n\n")
		  (point)
		loc1))
	(sc-nuke-mail-headers 'keep)
	(sc-nuke-mail-header-list mail-fwd-keep-headers))
    (sc-mail-process-headers loc1 loc2))
  )

(defun dpb-gnus-display-current ()
  "Display the current article."
  (interactive)
  (gnus-summary-display-article (gnus-summary-article-number)))

(defun dpb-gnus-current-word ()
  ;; (interactive)
  (let ((linenum nil)
	)
    (save-excursion
      (re-search-backward "[ \t\n]")
      (re-search-forward "[\-a-zA-Z0-9]+")
      
      (setq linenum 
	    (read (buffer-substring (match-beginning 0) (match-end 0))))
      linenum
      )
    ))

(setq gnus-summary-mode-hook
      '(lambda ()
	 (require 'gnusmail)
	 (setq gnus-mail-reply-method 'dpb-mail-using-mhe)
	       ;; gnus-mail-reply-using-mhe
	 (setq gnus-mail-other-window-method 'dpb-mail-other-window)
	       ;; gnus-mail-other-window-using-mhe

	 (setq gnus-summary-lines-height
	       (/ (window-height) 5))
	 (define-key gnus-summary-mode-map "\C-^"
	   'gnus-summary-refer-parent-article)
	 (define-key gnus-summary-mode-map "^" 'gnus-summary-save-in-folder)
	 (define-key gnus-summary-mode-map "t" 'gnus-summary-expand-window)
	 (define-key gnus-summary-mode-map "%" 'gnus-summary-caesar-message)
	 (define-key gnus-summary-mode-map "s" 'mh-send)
	 (define-key gnus-summary-mode-map "i" 'mh-rmail)
	 (define-key gnus-summary-mode-map "M" 'dpb-gnus-forward-article)
	 (define-key gnus-summary-mode-map "." 'dpb-gnus-display-current)
	 ))

(defun dpb-gnus-insert-sig()
  (interactive)
  (gnus-inews-insert-signature))

(setq news-reply-mode-hook
      '(lambda ()
	 (define-key news-reply-mode-map "\C-c\C-s" 'dpb-gnus-insert-sig)
	 ))

(setq group-folder-map 
    '(("ba.food"              "+food")
      ("rec.food.restaurants" "+food")
      ("comp.emacs"           "+gnu")
      ("comp.lang.perl"       "+perl")
      ("comp.sources.misc"    "+junk")
      ("comp.sources.unix"    "+junk")
      ("comp.sources.x"       "+junk")
      ("alt.sources"          "+junk")
      ("comp.windows.x"       "+xpert")
      ("comp.windows.x.motif" "+motif")
      ("comp.lang.scheme"     "+scheme")
      ("comp.graphics"        "+graphics")
      ("comp.risks"           "+risks")
      ("comp.sys.sun"         "+sun-spots")
      ("inbox.vl"             "+project")
      ("inbox.cvs"            "+cvs")
      ("inbox.motif"          "+motif")
      ("inbox.gnu"            "+gnu")
      ("inbox.xpert"          "+xpert")
      ("inbox.humor"          "+humor")
      ("inbox.stuff1"         "+jobs")
      ("inbox.stuff2"         "+contract")
      ("misc.int-property"    "+gnu.lpf")
      ("rec.humor.funny"      "+humor")
      ("rec.humor.funny.reruns" "+humor.reruns")
      ("alt.comedy.british"   "+humor")
      ("rec.arts.movies"      "+movies")
      ("rec.music.folk"       "+music")
      ("rec.arts.movies.reviews" "+movies")
      ("rec.bicycles"         "+bicycles")
      ("rec.arts.books"       "+books")
      ("rec.travel"           "+travel")
      ("gnu.emacs.announce"   "+gnu.announce")
      ("gnu.emacs.sources"    "+gnu.emacs")
      ("gnu.gcc.announce"     "+gnu.announce")
      ("gnu.g++.announce"     "+gnu.announce")
      ("frame.enotes"         "+enotes")
      ("inbox.interviews"     "+interviews")
      ("frame.x.c++"          "+interviews")
      ("alt.sys.sun"          "+sun-spots")
      ("comp.os.linux.announce" "+comp.os.linux")
      ))

(setq gnus-folder-save-name
      '(lambda (group headers junk)
	 (interactive)
	 (let ((match (assoc group group-folder-map))
	       )
	   (if match
	       (car (cdr match))
	     (concat "+" group)))
	 ))

;; Now, every time a new group is selected, if more than 20 articles have been
;; read since the last time .newsrc was saved, it's saved, and the counter is
;; reset. 
;; - Skip Montanaro (montanaro@crdgw1.ge.com)

(setq gnus-newsrc-save-frequency 20)
(setq gnus-read-articles 0)
(setq gnus-select-group-hook
      '(lambda ()
	 (if (> gnus-read-articles gnus-newsrc-save-frequency)
	     (progn
	       (gnus-save-newsrc-file)
	       (setq gnus-read-articles 0)))))

(add-hook 'gnus-article-prepare-hook
      '(lambda ()
	 (setq gnus-read-articles (1+ gnus-read-articles))))

;; Taken straight from the 3.14.1 help; 
;; Don't hook it up if we're only reading mail!
(setq sort-group-hook
      (function
       (lambda ()
	 ;; First of all, sort by date.
	 (gnus-sort-headers
	  (function
	   (lambda (a b)
	     (gnus-date-lessp (gnus-header-date a)
			      (gnus-header-date b)))))
	 ;; Then sort by subject string ignoring `Re:'.
	 ;; If case-fold-search is non-nil, case of letters is ignored.
	 (gnus-sort-headers
	  (function
	   (lambda (a b)
	     (gnus-string-lessp
	      (gnus-simplify-subject (gnus-header-subject a) 're)
	      (gnus-simplify-subject (gnus-header-subject b) 're)
	      )))))))

;; This is the function I use to start up news.
;; The number of times you hit control-u before the function
;; is invoked controls the nntp server selected.
;;  0 - don't use nntp, use the mhspool package to read new mail;
;;  1 - nntp on viking;
;;  2 - nntp on frame;
;;  3 - nntp on figment;
 
(defun gnus-func (arg)
  "Startup gnus to read news"
  (interactive "p")
  (cond
   ((eq arg 1)
    (setq gnus-select-group-hook nil)
    (setq gnus-cache-enabled nil)
    (setq gnus-nntp-server ":NewMail")
    (setq gnus-startup-file "~/.newsrc-:NewMail"))
;;   ((eq arg 4)
;;    (setq gnus-select-group-hook sort-group-hook)
;;    (setq gnus-cache-enabled t)
;;    (setq gnus-nntp-server "zuni")
;;    (setq gnus-startup-file "~/.newsrc-zuni"))
   ((eq arg 4)
    (setq gnus-select-group-hook sort-group-hook)
    (setq gnus-cache-enabled nil)
    ;; (setq gnus-nntp-server "gazette")
    (setq gnus-startup-file "~/.newsrc-netcom")
    (setq gnus-nntp-service nil))
   (t
    (setq gnus-cache-enabled nil)
    (setq gnus-nntp-server nil)
    (setq gnus-startup-file nil)))
  (gnus))

(setq gnus-auto-select-first nil)
(setq gnus-mail-other-window-method 'gnus-mail-other-window-using-mhe)

(global-set-key "\^xn" 'gnus-func)

;;  ;;
;;  ;; Hook to catch crossposts;
;;  ;;
;;  If you use GNUS (and why wouldn't you) you can drop the following in
;;  your ~/.emacs file and never again be bothered by those pesky
;;  inadvertent crossposts (you try scrubbing, you try spraying, and
;;  still...).  It will notice when you're about to send a cross posted
;;  article and ask for confirmation in the minibuffer.
;;  
;;  (This also assumes that this code works, but I'm pretty sure it does.)

(add-hook 'news-inews-hook 'wsm-gnus-crosspost-warning)
(defun wsm-gnus-crosspost-warning ()
  (if (save-excursion (goto-char (point-min))
		      (search-forward-regexp "^Newsgroups:[^,\n]*," nil t))
      (progn
	(beep)
	(if (not (y-or-n-p "WARNING: article cross-posted!  Post anyway? "))
	    (error "Posting of message aborted")
	  ))
    ))
;; --
;; Wayne();
;; WMesard@SGI.com

(provide 'dpb-gnus)


