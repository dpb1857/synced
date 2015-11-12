
class media-server {

  include common-system

  exec {'add-java8-ppa':
    command => "/usr/bin/add-apt-repository ppa:webupd8team/java && /usr/bin/apt-get update",
    creates => "/etc/apt/sources.list.d/webupd8team-java-$lsbdistcodename.list",
    require => Class['common-system']
  }

  # Install java8;  Can't really do this from puppet;
  # after puppet, run: apt-get install oracle-java8-installer

  package {'oracle-java8-installer':
    ensure => installed,
    require => Exec["add-java8-ppa"],
  }

  exec {'add-ffmpeg-ppa':
    command => "/usr/bin/add-apt-repository ppa:kirillshkrogalev/ffmpeg-next && /usr/bin/apt-get update",
    creates => "/etc/apt/sources.list.d/kirillshkrogalev-ffmpeg-next-$lsbdistcodename.list",
    require => Class['common-system']
  }

  # Install ffmpeg;
  package {'ffmpeg':
    ensure => installed,
    require => Exec["add-ffmpeg-ppa"],
  }
}
