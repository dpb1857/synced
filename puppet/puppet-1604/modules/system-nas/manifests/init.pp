
class system-nas {

  ############################################################
  # Add user/group for deborah;
  ############################################################


   user {'deborah':
     ensure => 'present',
     managehome => true,
     shell => "/bin/bash",
     groups => 'deborah',
   }

   group {'deborah':
     ensure => 'present'
   }

  file {"/home/deborah":
      source => "puppet:///modules/system-nas/home/deborah",
      owner => "deborah",
      group => "deborah",
      recurse => true,
  }

  ############################################################
  # Mount additional file systems;
  ############################################################
    file {'/srv':
        ensure => directory,
	owner  => root,
	group  => root,
	notify => Exec['nas-fstab']
    }

    file {'/backup':
        ensure => directory,
	owner  => root,
	group  => root,
	notify => Exec['nas-fstab']
    }

    file {'/photos':
        ensure => directory,
	owner  => root,
	group  => root,
	notify => Exec['nas-fstab', 'nas-exports']
    }

    exec {'nas-fstab':
        command => "/bin/echo \"\n\
# /srv was on /dev/sda7 during installation
UUID=31209888-2cf9-4a3a-ad5f-8d9147ef474c /srv            ext4    defaults        0       2
# /backup
UUID=b2d16bb0-9657-476d-abf1-049b4c5b4830 /backup         btrfs   defaults        0       2
# /photos
UUID=856cbf37-61ad-43e1-95fe-8a4a517f2417 /photos         ext4    defaults        0       2
\" >> /etc/fstab",
        unless => '/bin/grep /srv /etc/fstab',
	refreshonly => true
      }

  ############################################################
  # Export filesystems via nfs;
  ############################################################

    exec {'nas-exports':
        command => "/bin/echo \"\n\

/photos	*(ro,sync,no_subtree_check)
\" >> /etc/exports",
        unless => '/bin/grep /photos /etc/exports',
	refreshonly => true
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
      group => root,
      mode => 0644,
    }

    ############################################################
    # Backup rusa websites;
    ############################################################

    package {'sshpass':
      ensure => installed,
    }

    file {'/usr/local/bin/backup-rusa.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup-rusa.sh",
      owner => root,
      group => root,
      mode => 0755,
    }

    file {'/usr/local/bin/backup-linode-rusa.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup-linode-rusa.sh",
      owner => root,
      group => root,
      mode => 0755,
    }

    file {'/usr/local/bin/backup-linode-rusa-www.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup-linode-rusa-www.sh",
      owner => root,
      group => root,
      mode => 0755,
    }

    file {'/etc/cron.d/backup-rusa':
      ensure => file,
      source => "puppet:///modules/system-nas/etc/cron.d/backup-rusa",
      owner => root,
      group => root,
      mode => 0644,
    }

    ############################################################
    # Backup linode website;
    ############################################################

    file {'/usr/local/bin/backup-linode.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup-linode.sh",
      owner => root,
      group => root,
      mode => 0755,
    }

    file {'/usr/local/bin/backup-linode2.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup-linode2.sh",
      owner => root,
      group => root,
      mode => 0755,
    }

    file {'/etc/cron.d/backup-linode':
      ensure => file,
      source => "puppet:///modules/system-nas/etc/cron.d/backup-linode",
      owner => root,
      group => root,
      mode => 0644,
    }
}
