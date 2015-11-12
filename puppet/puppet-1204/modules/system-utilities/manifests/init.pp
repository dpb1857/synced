
class system-utilities {

   package {'sysstat': 
       ensure => installed
   }

   package {'iotop': 
       ensure => installed
   }

   package {'filelight': 
       ensure => installed
   }

   package {'rdiff-backup': 
       ensure => installed
   }

   package {'gparted': 
       ensure => installed
   }

   package {'cpulimit': 
       ensure => installed
   }

   package {'wireshark': 
       ensure => installed
   }

   package {'traceroute': 
       ensure => installed
   }

}
