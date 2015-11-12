
class virtual {

  package {'virtualbox':
    ensure => installed
  }

  package {'vagrant':
    ensure => installed
  }

}
