
class emacs-puppet($lispdir) {

    file {'puppet-mode.el':
        path =>"$lispdir/puppet-mode.el",
	ensure => file,
	source => "puppet:///modules/editors/puppet-mode.el",
    }

    file {'puppet-mode-init.el':
        path =>"$lispdir/puppet-mode-init.el",
	ensure => file,
	source => "puppet:///modules/editors/puppet-mode-init.el",
    }
}