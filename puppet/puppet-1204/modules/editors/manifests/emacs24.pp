
class emacs24 {

  include common-system

  # https://launchpad.net/~cassou/+archive/emacs
    
  exec {'add-emacs24-ppa':
    command => "/usr/bin/add-apt-repository ppa:cassou/emacs && /usr/bin/apt-get update",
    creates => "/etc/apt/sources.list.d/cassou-emacs-$lsbdistcodename.list",
    require => Class['common-system']
  }

  # Install emacs24 prerelease;
  package {'emacs-snapshot':
    ensure  => installed,
    require => Exec["add-emacs24-ppa"],
  }
}
