
class virtualbox {

    # Hack for Mint12;
    if $lsbdistcodename == "lisa" {
        $lsbdistcodename = 'oneiric'
    }

    $aptfile = "/etc/apt/sources.list.d/oracle-virtualbox-$lsbdistcodename.list"

    define virtualbox-repo  {

	file {$aptfile:
	    ensure => file,
	    source => "puppet:///modules/virtual/oracle-virtualbox-$lsbdistcodename.list",
	    notify => [Exec['add-oracle-key'], Exec['update-virtualbox-repo']]
	}

	exec {'add-oracle-key':
	    command     => "/usr/bin/curl http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc | /usr/bin/sudo apt-key add -",
	    require     => Package['curl'],
	    refreshonly => true,
	}

	exec {'update-virtualbox-repo':
	    command     => "/usr/bin/apt-get update",
	    require     => Exec['add-oracle-key'],
	    refreshonly => true,
	}	
    }

    virtualbox-repo {'virtualbox-repo': }
    
    package {'virtualbox-4.1':
        ensure => installed,
	require => Virtualbox-repo['virtualbox-repo']
    }

    package {'dkms':
        ensure => installed,
    }
}
