
class languages {

    package {'clisp':
        ensure => installed,
    }

    package {'clisp-doc':
        ensure => installed,
    }

    package {'clojure1.4':
        ensure => installed,
    }

    package {'gambc':
        ensure => installed,
    }

    package {'gambc-doc':
        ensure => installed,
    }

    package {'gdc':
        ensure => installed,
    }

    package {'golang':
        ensure => installed,
    }

    package {'golang-doc':
        ensure => installed,
    }

    package {'golang-go.tools':
        ensure => installed,
    }

    package {'octave':
        ensure => installed,
    }

    package {'racket':
        ensure => installed,
    }

    package {'racket-doc':
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
