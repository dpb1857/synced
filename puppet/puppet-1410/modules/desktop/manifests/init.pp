
class desktop {
      package {'cinnamon':
              ensure => installed,
      }
      package {'cinnamon-bluetooth':
              ensure => installed,
      }
}
