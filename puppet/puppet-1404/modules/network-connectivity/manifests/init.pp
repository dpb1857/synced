
class network-connectivity($node_type='client') {

    package {'libaudiofile1':
        ensure => installed,
    }

    package {'network-manager-vpnc-gnome':
      ensure => installed,
    }

    package {'vpnc':
      ensure => installed,
    }

    $dl_dir = '/usr/local/download'

    $nx_dl = 'http://64.34.161.181'
    $nx_version = '3.5.0'

    if $architecture == "x86_64" {
        $nx_arch = 'amd64'
    } else {
        $nx_arch = 'i386'
    }

    file {"nx_download_dir":
        path   => $dl_dir,
	ensure => directory
    }

    define nx_package($pkg,$subversion,$subdir="") {
	exec {"nx-download-$pkg":
	    command => "/usr/bin/curl ${nx_dl}/download/${nx_version}/Linux/$subdir/${pkg}_${nx_version}-${subversion}_${nx_arch}.deb > ${dl_dir}/${pkg}.deb",
	    creates => "${dl_dir}/${pkg}.deb",
	    require => File[$dl_dir],
	    notify => Exec["nx-dpkg-$pkg"],
	}
	exec {"nx-dpkg-$pkg":
	    command => "/usr/bin/dpkg -i ${dl_dir}/${pkg}.deb",
	    require => Exec["nx-download-$pkg"],
	    refreshonly => true,
	}
    }

#    nx_package {'nxclient':
#        pkg => "nxclient",
#	subversion => "7",
#    }

    if $node_type == 'server' {

	package {'openssh-server':
	    ensure => installed,
	}

#	nx_package {'nxnode':
#	    pkg => 'nxnode',
#	    subversion => "7",
#	    require => Nx_package['nxclient'],
#	}

#	nx_package {'nxserver':
#	    pkg        => 'nxserver',
#	    subversion => "9",
#	    subdir     => "FE",
#	    require => Nx_package['nxnode'],
#	}

    }
}
