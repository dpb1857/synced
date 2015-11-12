
class crypt-filesystems {

    package {'ecryptfs-utils':
        ensure => installed,
    }

    package {'cryptsetup':
        ensure => installed,
    }
}
