
class system-dpb-w500 {

    ############################################################
    # Mount filesystems on dpb-w500;
    ############################################################

    file {'/home/vbox':
        ensure => directory,
	owner  => dpb,
	group  => dpb,
	notify => Exec['dpb-w500-fstab']
    }

    file {'/home/scratch':
        ensure => directory,
	owner  => dpb,
	group  => dpb,
	notify => Exec['dpb-w500-fstab']
    }

    file {'/home/dpb-stuff':
        ensure => directory,
	owner  => dpb,
	group  => dpb,
	notify => Exec['dpb-w500-fstab']
    }

    exec {'dpb-w500-fstab':
        command => "/bin/echo \"\n\
# /home/dpb-stuff was on /dev/sda8 during installation\n\
UUID=08f67da9-ae3e-4804-8f90-cde248d542d0 /home/dpb-stuff ext3    relatime        0       2\n\
# /home/scratch was on /dev/sda9 during installation\n\
UUID=ff88e5d5-9b33-4616-8ef6-bbafe8238dbb /home/scratch   ext3    relatime        0       2\n\
# /home/vbox was on /dev/sda11 during installation\n\
# UUID=33236d08-fab9-4a7b-98a2-b98dea91ebc4 /home/vbox      ext3    relatime        0       2\n\
\" >> /etc/fstab",
        unless => '/bin/grep /home/dpb-stuff /etc/fstab',
	refreshonly => true
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

#   exec {'save-original-lightdm-conf':
#     command => "/bin/cp lightdm.conf lightdm.conf.orig",
#     creates => "/etc/lightdm/lightdm.conf.orig",
#     cwd => "/etc/lightdm",
#    }

#   exec {'disable-guest-login':
#     command => "/bin/echo \"allow-guest=false\n\" >> lightdm.conf",
#     require => Exec["save-original-lightdm-conf"],
#     unless => '/bin/grep allow-guest lightdm.conf',
#     cwd => "/etc/lightdm",
#    }

    ################################################################################
    # Writes crontab entry to root user crontab file; /var/spool/cron/crontabs/root
    ################################################################################

    cron { 'backup':
        command => '/home/dpb-stuff/stuff/bin/backup',
	user    => root,
	hour    => 22,
	minute  => 0,
	ensure  => present
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
Port 32022\n\
\" >> /etc/ssh/sshd_config",
        unless => '/bin/grep "Port 32022" /etc/ssh/sshd_config',
	require => Package['openssh-server']
        }

   ############################################################
   # Extra packages;
   ############################################################

   package {'compizconfig-settings-manager': ensure=>installed}

   ############################################################
   # Add sudoers file so dpb can run mount/umount without a password;
   ############################################################

   file {"/etc/sudoers.d/dpb-mount":
        source => "puppet:///modules/system-dpb-w500/etc/sudoers.d/dpb-mount",
        owner => "root",
        group => "root",
        mode => 0440
   }

   # and run vpnc...

   file {"/etc/sudoers.d/dpb-vpnc":
        source => "puppet:///modules/system-dpb-w500/etc/sudoers.d/dpb-vpnc",
        owner => "root",
        group => "root",
        mode => 0440
   }

   ############################################################
   # Get Quixey VPN to (maybe) work;
   ############################################################

# 1: Install some prerequisites: sudo apt-get install libc:i386 zlib1g:i386
# 2:Download https://qvpn.quixey.net/dana-cached/nc/ncLinuxApp.jar from your browser.
# 3: Extract it to a new directory: mkdir ~/qvpn; cd ~/qvpn; jar -xvf ~/Downloads/ncLinuxApp.jar
# 4: Download the VPN Certificate: bash ./getx509certificate.sh qvpn.quixey.net quixey.net.der
# 5: Set up some permissions: sudo chown root:root ncsvc; sudo chmod 6711 ncsvc
# 6: Try running it: ./ncsvc -u adam -h qvpn.quixey.net -f quixey.net.der -r NC_Users

   package {'libc6-i386':
     ensure => installed
   }

   package {'zlib1g:i386':
     ensure => installed
   }

}
