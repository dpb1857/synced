
class languages {

    package {'clisp':
        ensure => installed,
    }

    package {'clisp-doc':
        ensure => installed,
    }

    package {'clojure':
        ensure => installed,
    }

    package {'gambc':
        ensure => installed,
    }

    package {'gambc-doc':
        ensure => installed,
    }

    package {'octave3.2':
        ensure => installed,
    }

    package {'plt-scheme':
        ensure => installed,
    }

    package {'plt-scheme-doc':
        ensure => installed,
    }

    package {'jython':
        ensure => installed,
    }

    package {'jython-doc':
        ensure => installed,
    }

    package {'scala':
        ensure => installed,
    }

    package {'scala-doc':
        ensure => installed,
    }
}
