
class system-utilities {

   package {'cpulimit':
       ensure => installed
   }

   package {'dconf-editor':
       ensure => installed
   }

   package {'filelight':
       ensure => installed
   }

   package {'gparted':
       ensure => installed
   }

   package {'iotop':
       ensure => installed
   }

   package {'rdiff-backup':
       ensure => installed
   }

   package {'sysstat':
       ensure => installed
   }

   package {'traceroute':
       ensure => installed
   }

   package {'wireshark':
       ensure => installed
   }

}
