
class system-castle {

    ############################################################
    # Mount filesystems on dpb-w500;
    ############################################################

    file {'/mnt/backup':
      ensure => directory,
      owner  => root,
      group  => root,
      notify => Exec['castle-fstab']
    }

    file {'/mnt/nas':
      ensure => directory,
    }

    file {'/mnt/nas/backup':
      ensure => directory,
      require => File['/mnt/nas'],
    }

    file {'/mnt/nas/family':
      ensure => directory,
      require => File['/mnt/nas'],
    }

    file {'/mnt/nas/media':
      ensure => directory,
      require => File['/mnt/nas'],
    }

    file {'/mnt/nas/photos':
      ensure => directory,
      require => File['/mnt/nas'],
    }

    file {'/mnt/nas/photos-raw':
      ensure => directory,
      require => File['/mnt/nas'],
    }

    file {'/mnt/nas/software':
      ensure => directory,
      require => File['/mnt/nas'],
    }

    file {'/mnt/nas/home':
      ensure => directory,
      require => File['/mnt/nas'],
    }

    exec {'castle-fstab':
        command => "/bin/echo \"\n\
# /mnt/backup\n\
UUID=856cbf37-61ad-43e1-95fe-8a4a517f2417 /mnt/backup	ext4	defaults	0	3\n\
\n\
nas:/backup		/mnt/nas/backup		nfs	rw		0 0\n\
nas:/family		/mnt/nas/family		nfs	rw		0 0\n\
nas:/media		/mnt/nas/media		nfs	rw		0 0\n\
nas:/photos		/mnt/nas/photos		nfs	ro		0 0\n\
nas:/photos-raw		/mnt/nas/photos-raw	nfs	ro		0 0\n\
nas:/software		/mnt/nas/software	nfs	rw		0 0\n\
nas:/castle_home	/mnt/nas/home		nfs	rw		0 0\n\
\" >> /etc/fstab",
        unless => '/bin/grep /mnt/backup /etc/fstab',
	refreshonly => true
      }

  ############################################################
  # Configure static networking for eth0;
  ############################################################

  file {"/etc/network/interfaces":
    ensure => file,
    source => "puppet:///modules/system-castle/etc/network/interfaces",
  }

  file {"/etc/resolv.conf":
    ensure => file,
    source => "puppet:///modules/system-castle/etc/resolv.conf",
  }

   ############################################################
   # Enable /net access to network hosts;
   ############################################################

   exec {'save-original-automounter':
     command => "/bin/mv auto.master auto.master.orig",
     creates => "/etc/auto.master.orig",
     cwd => "/etc",
    }

   exec {'enable-network-automounter':
     command => "/bin/sed 's|^#/net|/net|' < auto.master.orig > auto.master",
     require => Exec["save-original-automounter"],
     cwd => "/etc",
    }

   ############################################################
   # Disable guest login;
   ############################################################

   exec {'save-original-lightdm-conf':
     command => "/bin/cp lightdm.conf lightdm.conf.orig",
     creates => "/etc/lightdm/lightdm.conf.orig",
     cwd => "/etc/lightdm",
    }

   exec {'disable-guest-login':
     command => "/bin/echo \"allow-guest=false\n\" >> lightdm.conf",
     require => Exec["save-original-lightdm-conf"],
     unless => '/bin/grep allow-guest lightdm.conf',
     cwd => "/etc/lightdm",
    }

    ############################################################
    # Configure postfix;
    ############################################################

    package {'postfix':
      ensure => installed,
    }

     exec {'save-original-maincf':
       command => "/bin/mv main.cf main.cf.orig",
       creates => "/etc/main.cf.orig",
       cwd => "/etc/postfix",
       require => Package['postfix']
     }

     file {'/etc/postfix/main.cf':
       ensure => file,
       source => "puppet:///modules/system-castle/etc/postfix/main.cf",
       require => Exec['save-original-maincf'],
     }

     file {'/etc/mailname':
       ensure => file,
       source => "puppet:///modules/system-castle/etc/mailname",
     }

     file {'/etc/aliases':
       ensure => file,
       source => "puppet:///modules/system-castle/etc/aliases",
       owner  => root,
       group  => root,
       mode   => 0644,
     }

    ################################################################################
    # install rsnapshot crontab file;
    ################################################################################

    package {'rsnapshot':
      ensure => installed,
    }

    package {'sshpass':
      ensure => installed,
    }

    file {"/etc/cron.d/rsnapshot":
      ensure => file,
      source => "puppet:///modules/system-castle/etc/cron.d/rsnapshot",
      owner  => root,
      group  => root,
      mode   => 0644,
      require => Package['rsnapshot'],
    }

    file {"/etc/rsnapshot.conf":
      ensure => file,
      source => "puppet:///modules/system-castle/etc/rsnapshot.conf",
      owner  => root,
      group  => root,
      mode   => 0644,
      require => Package['rsnapshot'],
    }

    file {'/usr/local/bin/backup-rusa.sh':
      ensure => file,
      source => "puppet:///modules/system-castle/usr/local/bin/backup-rusa.sh"
    }

    ############################################################
    # Load programs we use to save and process audio streams
    ############################################################

    package {'lame':
      ensure => installed,
    }

    package {'streamripper':
      ensure => installed,
    }

    package {'mp3info':
      ensure => installed,
    }

    ############################################################
    # Add dpb to fuse group;
    ############################################################

    exec { 'add-to-fuse':
        command => "/usr/sbin/adduser dpb fuse",
	unless  => "/bin/grep ^fuse:.*:dpb /etc/group"
    }

    ############################################################
    # Add a high-numbered ssh port listener;
    ############################################################

    exec {'ssh-high-port-listener':
        command => "/bin/echo \"\n\
# XXX dpb add an additional high-numbered port;\n\
Port 22022\n\
AllowUsers dpb deborah nx\n\
GatewayPorts yes\n\
\" >> /etc/ssh/sshd_config",
        unless => '/bin/grep "Port 22022" /etc/ssh/sshd_config',
	require => Package['openssh-server'],
        }

    ############################################################
    # INSTALL LOGITECH MEDIA SERVER;
    # logitechmediaserver_7.7.1_all.deb installs OK on Ubuntu 11.10
    # goto http://castle:9000/ after installation to configure.
    ############################################################
}
