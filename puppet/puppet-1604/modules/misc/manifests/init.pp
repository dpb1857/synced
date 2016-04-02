
class misc {

    package {'apcalc':
        ensure => installed,
    }

    package {'qalculate-gtk':
        ensure => installed,
    }

    package {'python-chardet':
        ensure => installed,
    }

    package {'gpsbabel':
        ensure => installed,
    }

    package {'gpsbabel-doc':
        ensure => installed,
    }

    package {'gpsbabel-gui':
        ensure => installed,
    }

    package {'pdfgrep':
        ensure => installed,
    }
}
