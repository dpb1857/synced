
class network-filesystems-server {

      package {'nfs-kernel-server':
          ensure => installed,
      }
}