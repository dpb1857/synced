
;; 
;; vi-type-paren-patch 
;;
;; Todd Cooper (...!buita!ptltd!todd)
;; Phoenix Technologies Ltd. (617 551 4107)
;;

(defun vi-type-paren-match (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "[([{]") (forward-sexp 1) (backward-char))
	((looking-at "[])}]") (forward-char) (backward-sexp 1))
	(t (self-insert-command (or arg 1)))))

(global-set-key "%" 'vi-type-paren-match)

(provide 'vi-paren-matching)
