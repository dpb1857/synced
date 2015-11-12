
class editors {

    package {'texi2html':
        ensure => installed,
    }

    package {'texinfo':
        ensure => installed,
    }

    class { 'emacs24': }

    # Looks like /usr/local/share/emacs used by both
    # emacs23 and emacs24.

    class { 'emacs-python':
        lispdir => '/usr/local/share/emacs/site-lisp',
        require => Class['emacs24']
    }

    class { 'emacs-puppet':
        lispdir => '/usr/local/share/emacs/site-lisp',
        require => Class['emacs24']
    }
}
