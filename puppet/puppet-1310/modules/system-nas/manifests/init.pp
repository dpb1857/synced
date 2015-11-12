
class system-nas {

  ############################################################
  # Add user/group for deborah;
  ############################################################


   user {'deborah':
     groups => 'deborah',
     ensure => 'present'
   }

   group {'deborah':
     ensure => 'present'
   }

  ############################################################
  # Configure static networking for eth0;
  ############################################################

  file {"/etc/network/interfaces":
    ensure => file,
    source => "puppet:///modules/system-nas/etc/network/interfaces",
  }

  file {"/etc/resolv.conf":
    ensure => file,
    source => "puppet:///modules/system-nas/etc/resolv.conf",
  }


  # Btrfs tools;
  package {'btrfs-tools':
    ensure => installed,
  }

    ############################################################
    # Add a high-numbered ssh port listener;
    ############################################################

    exec {'ssh-high-port-listener':
        command => "/bin/echo \"\n\
# XXX dpb add an additional high-numbered port;\n\
Port 32022\n\
AllowUsers dpb deborah nx\n\
GatewayPorts yes\n\
\" >> /etc/ssh/sshd_config",
        unless => '/bin/grep "Port 32022" /etc/ssh/sshd_config',
	require => Package['openssh-server'],
        }


    ############################################################
    # Backup script to backup a directory in /srv to /backup;
    ############################################################

    file {'/usr/local/bin/backup.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup.sh"
    }

    ############################################################
    # Backup folders in /srv;
    ############################################################

    file {'/etc/cron.d/backup-folders':
      ensure => file,
      source => "puppet:///modules/system-nas/etc/cron.d/backup-folders",
      owner => root,
      group => root
    }

    ############################################################
    # Backup rusa website;
    ############################################################

    package {'sshpass':
      ensure => installed,
    }

    file {'/usr/local/bin/backup-rusa.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup-rusa.sh"
    }

    file {'/etc/cron.d/backup-rusa':
      ensure => file,
      source => "puppet:///modules/system-nas/etc/cron.d/backup-rusa",
      owner => root,
      group => root
    }

    ############################################################
    # Backup linode website;
    ############################################################

    file {'/usr/local/bin/backup-linode.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup-linode.sh"
    }

    file {'/etc/cron.d/backup-linode':
      ensure => file,
      source => "puppet:///modules/system-nas/etc/cron.d/backup-linode",
      owner => root,
      group => root
    }

}
