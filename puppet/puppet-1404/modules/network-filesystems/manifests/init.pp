
class network-filesystems {

      package {'sshfs':
          ensure => installed,
      }

      package {'curlftpfs':
          ensure => installed,
      }

      package {'autofs':
          ensure => installed,
      }

      package {'nfs-common':
          ensure => installed,
      }
}