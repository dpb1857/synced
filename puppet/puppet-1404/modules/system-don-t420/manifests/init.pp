
class system-don-t420 {

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
   # Add dpb to fuse group;
   ############################################################

   exec { 'add-to-fuse':
     command => "/usr/sbin/adduser dpb fuse",
     unless  => "/bin/grep ^fuse:.*:dpb /etc/group"
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

   ############################################################
   # Extra packages;
   ############################################################

   package {'compizconfig-settings-manager': ensure=>installed}

}
