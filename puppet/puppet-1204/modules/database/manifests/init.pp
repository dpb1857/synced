
class database {

    package {'sqlite3':
        ensure => installed,
    }

    package {'sqlite3-doc':
        ensure => installed,
    }

    package {'sqliteman':
        ensure => installed,
    }

    package {'sqliteman-doc':
        ensure => installed,
    }

    package {'mysql-client':
        ensure => installed,
    }

    package {'mysql-server':
        ensure => installed,
    }

#    package {'mysql-admin':
#        ensure => installed,
#    }

    package {'memcached':
        ensure => installed,
    }

    package {'redis-doc':
        ensure => installed,
    }

    package {'redis-server':
        ensure => installed,
    }

    package {'libdb4.8':
        ensure => installed,
    }

    package {'db4.8-util':
        ensure => installed,
    }

    package {'xqilla':
        ensure => installed,
    }

    class {'postgres91': }

}
