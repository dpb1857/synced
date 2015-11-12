
package {'curl':
    ensure => installed,
}

class emacs-lambda($lispdir='/usr/local/share/emacs/site-lisp') {

    file { $lispdir:
	 ensure => directory,
    }

    exec {
        "/usr/bin/curl http://dishevelled.net/elisp/lambda-mode.el > ${lispdir}/lambda-mode.el":
	creates => "${lispdir}/lambda-mode.el",
	require => [Package['curl'], File['/usr/local/share/emacs/site-lisp']],
    }
}
