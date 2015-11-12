
class postgres91 {

    # Install postgresql;
    package {'postgresql-9.1':
	ensure  => installed,
    }

    package {'postgresql-client-9.1':
	ensure  => installed,
    }

    package {'postgresql-contrib-9.1':
	ensure  => installed,
    }

    package {'postgresql-doc-9.1':
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
