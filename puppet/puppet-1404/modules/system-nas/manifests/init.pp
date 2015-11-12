
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
	notify => Exec['nas-fstab']
    }

    exec {'nas-fstab':
        command => "/bin/echo \"\n\
# /srv was on /dev/sda7 during installation
UUID=31209888-2cf9-4a3a-ad5f-8d9147ef474c /srv            ext4    defaults        0       2
# /backup
UUID=0ae9a824-5000-4b3e-b29b-c45b39f43701 /backup         btrfs   defaults        0       2
# /photos
UUID=856cbf37-61ad-43e1-95fe-8a4a517f2417 /photos         ext4    defaults        0       2
\" >> /etc/fstab",
        unless => '/bin/grep /srv /etc/fstab',
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
    # Backup rusa website;
    ############################################################

    file {'/usr/local/bin/backup-linode-rusa.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup-linode-rusa.sh"
    }

    file {'/usr/local/bin/backup-linode-rusa-www.sh':
      ensure => file,
      source => "puppet:///modules/system-nas/usr/local/bin/backup-linode-rusa-www.sh"
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
      source => "puppet:///modules/system-nas/usr/local/bin/backup-linode.sh"
    }

    file {'/etc/cron.d/backup-linode':
      ensure => file,
      source => "puppet:///modules/system-nas/etc/cron.d/backup-linode",
      owner => root,
      group => root,
      mode => 0644,
    }

}
