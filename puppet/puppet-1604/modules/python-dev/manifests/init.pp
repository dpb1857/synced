
class python-dev {

    package {'python-doc':
        ensure => installed,
    }

    package {'pylint':
        ensure => installed,
    }

    package {'python-virtualenv':
        ensure => installed,
    }

    package {'ipython':
        ensure => installed,
    }

#    package {'zlib1g-dev':
#        ensure => installed,
#    }
}
