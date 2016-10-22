
class office {

#    package {'antiword':
#        ensure => installed,
#    }

    # inspired by Visio
    package {'dia-gnome':
        ensure => installed,
    }

#    package {'gnucash':
#        ensure => installed,
#    }

#    package {'gnucash-docs':
#        ensure => installed,
#    }

    package {'inkscape':
        ensure => installed,
    }

    # KDE paint program
    package {'krita':
        ensure => installed,
    }

    package {'ksnapshot':
        ensure => installed,
    }

    package {'kmag':
    	ensure => installed,
    }

    package {'lyx':
        ensure => installed,
    }

    package {'pdfjam':
        ensure => installed,
    }

    package {'pdfposter':
        ensure => installed,
    }

    package {'pdftk':
        ensure => installed,
    }

    # DTP
    package {'scribus':
        ensure => installed,
    }

#    package {'thunderbird':
#        ensure => installed,
#    }

}
