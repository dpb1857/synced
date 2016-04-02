
class postgresql {

    # Install postgresql;
    package {'postgresql':
	ensure  => installed,
    }

    package {'postgresql-client':
	ensure  => installed,
    }

    package {'postgresql-contrib':
	ensure  => installed,
    }

    package {'postgresql-doc':
	ensure  => installed,
    }

    package {'pgadmin3':
        ensure => installed,
    }

    package {'ptop':
	ensure  => installed,
    }

    package {'python-psycopg2':
	ensure  => installed,
    }

#    package {'pgpool2':
#        ensure => installed,
#    }
}
