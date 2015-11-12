
class system-qdesktop-don {

   ############################################################
   # Add dbennett to fuse group;
   ############################################################

   exec { 'add-to-fuse':
     command => "/usr/sbin/adduser dbennett fuse",
     unless  => "/bin/grep ^fuse:.*:dpb /etc/group"
   }

   ############################################################
   # Extra packages;
   ############################################################

   package {'compizconfig-settings-manager': ensure=>installed}

   package {'redis-server': ensure => installed }

   package {'fabric': ensure => installed }

   package {'supervisor': ensure => installed }

   package {'libmemcached10': ensure => installed }

   user {'quixey':
     groups => 'quixey',
     ensure => 'present'
   }

   group {'quixey':
     ensure => 'present'
   }
}
