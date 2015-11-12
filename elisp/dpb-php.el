

(autoload 'php-mode "php-mode")
(add-to-list 'auto-mode-alist
	     '("\\.php[34]\\'\\|\\.php\\'\\|\\.phtml\\'" . php-mode))

(provide 'dpb-php)
