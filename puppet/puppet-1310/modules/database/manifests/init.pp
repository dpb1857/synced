
class database {

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

    package {'redis-server':
        ensure => installed,
    }

    package {'xqilla':
        ensure => installed,
    }

    class {'postgres91': }

}
