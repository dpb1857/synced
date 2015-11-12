
class games {

    package {'gnudoq':
        ensure => installed,
    }

    package {'tuxmath':
        ensure => installed,
    }

    package {'stellarium':
      ensure => installed,
    }

    # William found this...
    package {'simutrans':
       ensure => installed,
    }

}
