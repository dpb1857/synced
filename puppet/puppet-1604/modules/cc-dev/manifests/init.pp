
class cc-dev {

    package {'c++-annotations':
        ensure => installed,
    }

    package {'cpp-doc':
        ensure => installed,
    }

    package {'g++':
        ensure => installed,
    }

    package {'gcc-doc':
        ensure => installed,
    }

    package {'libboost-all-dev':
        ensure => installed,
    }

    package {'libboost-doc':
        ensure => installed,
    }

    package {'libstdc++6-4.7-doc':
        ensure => installed,
    }

    package {'stl-manual':
        ensure => installed,
    }
}
