
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

}
