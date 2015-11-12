
class java-dev {

    package {'ant':
        ensure => installed,
    }

    package {'ant-doc':
        ensure => installed,
    }

    package {'antlr':
        ensure => installed,
    }

    package {'antlr-doc':
        ensure => installed,
    }

    package {'javacc':
        ensure => installed,
    }

    package {'javacc-doc':
        ensure => installed,
    }

    package {'jmeter':
        ensure => installed,
    }

    package {'junit':
        ensure => installed,
    }

    package {'liblog4j1.2-java':
        ensure => installed,
    }

    package {'liblog4j1.2-java-doc':
        ensure => installed,
    }

    package {'openjdk-6-demo':
        ensure => installed,
    }

    package {'openjdk-6-doc':
        ensure => installed,
    }

    package {'openjdk-6-jdk':
        ensure => installed,
    }
}
