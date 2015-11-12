
class devtools {

    package {'autoconf':
        ensure => installed,
    }

    package {'eclipse':
        ensure => installed,
    }

    package {'bzr':
        ensure => installed,
    }

#   Defined in module/git;
#    package {'git-core':
#        ensure => installed,
#    }

    package {'git-cvs':
        ensure => installed,
    }

    package {'git-doc':
        ensure => installed,
    }

    package {'git-gui':
        ensure => installed,
    }

#    Defined in modules/git;
#    package {'git-svn':
#        ensure => installed,
#    }

    package {'gitk':
        ensure => installed,
    }

    package {'jq':
        ensure => installed,
    }

    package {'libtool':
        ensure => installed,
    }

    package {'subversion':
        ensure => installed,
    }

    package {'mercurial':
        ensure => installed,
    }

    ############################################################
    # sqlite3 and other db clients;
    ############################################################

    package {'sqlite3':
        ensure => installed,
    }

    package {'sqlite3-doc':
        ensure => installed,
    }

    package {'sqliteman':
        ensure => installed,
    }

    package {'mongodb-clients':
        ensure => installed,
    }

    ############################################################
    # Extra documentation
    ############################################################

    package {'bash-doc':
        ensure => installed,
    }

    package {'binutils-doc':
        ensure => installed,
    }

    package {'diffutils-doc':
        ensure => installed,
    }

    package {'make-doc':
        ensure => installed,
    }

    package {'manpages-dev':
        ensure => installed,
    }

    package {'tar-doc':
        ensure => installed,
    }

    package {'chromium-browser':
        ensure => installed,
    }

    package {'nginx':
        ensure => installed,
    }

    package {'uwsgi':
        ensure => installed,
    }

#    package {'apache2':
#        ensure => installed,
#    }

#    package {'apache2-doc':
#        ensure => installed,
#    }

    $gemdir = "/usr/local/bin"

#    package {'rubygems':
#        ensure => installed,
#    }

    package {'ruby-dev':
        ensure => installed,
    }

    exec {'/usr/bin/gem install fpm':
	creates => "$gemdir/fpm",
    }

}
