

class emacs-python($emacs = 'emacs', $lispdir) {

    file { 'python-mode.el':
        path  => "$lispdir/python-mode.el",
	ensure => file,
	source => "puppet:///modules/editors/python-mode.el",
    }
}

