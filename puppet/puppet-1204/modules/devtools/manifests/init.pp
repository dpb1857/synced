
class devtools {

    package {'autoconf':
        ensure => installed,
    }

#    package {'eclipse':
#        ensure => installed,
#    }

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

#    package {'apache2':
#        ensure => installed,
#    }

#    package {'apache2-doc':
#        ensure => installed,
#    }

}
