
class system-qdesktop-don {

   ############################################################
   # Add dbennett to fuse group;
   ############################################################

   exec { 'add-to-fuse':
     command => "/usr/sbin/adduser don fuse",
     unless  => "/bin/grep ^fuse:.*:dpb /etc/group"
   }

   ############################################################
   # Extra packages;
   ############################################################

   package {'compizconfig-settings-manager': ensure=>installed}

   package {'redis-server': ensure => installed }

   package {'fabric': ensure => installed }

   package {'supervisor': ensure => installed }

   package {'libmemcached11': ensure => installed }

   user {'quixey':
     groups => 'quixey',
     ensure => 'present'
   }

   group {'quixey':
     ensure => 'present'
   }

   ############################################################
   # Add sudoers file so dpb can run mount/umount without a password;
   ############################################################

   file {"/etc/sudoers.d/don-mount":
        source => "puppet:///modules/system-qdesktop-don/etc/sudoers.d/don-mount",
        owner => "root",
        group => "root",
        mode => 0440
   }
}
