
include common-system

package {'ruby':
  ensure => installed,
}

package {'rubygems':
  ensure => installed,
}

package {'puppet':
  ensure => installed,
}

package {'chef':
  ensure => installed,
}

package {'openssh-server':
  ensure => installed,
}
