
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
}
