
class common-system {
    
    package {'make':
        ensure => installed,
    }
    
    package {'mg':
        ensure => installed,
    }
    
    package {'ntp':
        ensure => installed,
    }
    
    package {'python-software-properties':
        ensure => installed,
    }

}
