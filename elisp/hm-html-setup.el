          (autoload 'hm--html-mode "hm--html-mode" "HTML major mode." t)
          (autoload 'hm--html-minor-mode "hm--html-mode" "HTML minor mode." t)
          (or (assoc "\\.html$" auto-mode-alist)
              (setq auto-mode-alist (cons '("\\.html$" . hm--html-mode)
          				auto-mode-alist)))
          
          (autoload 'tmpl-expand-templates-in-buffer "tmpl-minor-mode"
            "Expand all templates in the current buffer." t)
          (autoload 'tmpl-expand-templates-in-region "tmpl-minor-mode"
            "Expands the templates in the region from BEGIN to END.
          If BEGIN and END are nil, then the current region is used."
            t)
          (autoload 'tmpl-insert-template-file-from-fixed-dirs
                    "tmpl-minor-mode"
            "Inserts a template FILE and expands it, if
          `tmpl-automatic-expand' is t.
          This command tries to read the template file from a list of
          predefined directories (look at `tmpl-template-dir-list') and it
          filters the contents of these directories with the regular
          expression `tmpl-filter-regexp' (look also at this variable).
          The command uses a history variable, which could be changed with the
          variable `tmpl-history-variable-name'.
          
          The user of the command is able to change interactively to another
          directory by entering at first the string \"Change the directory\".
          This may be too difficult for the user. Therefore another command
          called `tmpl-insert-template-file' exist, which doesn't use fixed
          directories and filters."
            t)
          
          (autoload 'tmpl-insert-template-file "tmpl-minor-mode"
            "Inserts a template FILE and expand it,
          if `tmpl-automatic-expand' is t.
          Look also at `tmpl-template-dir-list', to specify a default template
          directory. You should also take a look at
          `tmpl-insert-template-file-from-fixed-dirs', which has additional
          advantages (and disadvantages :-).
          
          ATTENTION: The interface of this function has changed. The old
          function had the argument list
                  (&optional TEMPLATE-DIR AUTOMATIC-EXPAND).
          The variables `tmpl-template-dir-list' and `tmpl-automatic-expand'
          must now be used instead of the args TEMPLATE-DIR and
          AUTOMATIC-EXPAND."
            t)
          
          (autoload 'html-view-start-mosaic "html-view" "Start Xmosaic." t)
          (autoload 'html-view-view-buffer
            "html-view"
            "View the current buffer in Xmosaic."
            t)
          (autoload 'html-view-view-file
            "html-view"
            "View a file in Xmosaic."
            t)
          (autoload 'html-view-goto-url
            "html-view"
            "Goto url in Xmosaic."
            t)
          (autoload 'html-view-get-display
            "html-view"
            "Get the display for Xmosaic (i.e. hostxy:0.0)."
            t)

;; XXX dpb added
(provide 'hm-html-setup)
