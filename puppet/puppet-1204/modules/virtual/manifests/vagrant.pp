

class vagrant {

    if $lsbdistcodename == "lisa" {
       # Mint12
       $gemdir = "/usr/local/bin"
    } else {
       # Ubuntu 1104, others?
       $gemdir = "/var/lib/gems/1.8/bin"
    }

    package {'rubygems':
        ensure => installed,
    }

    exec {'/usr/bin/gem install vagrant':
        require => Package["rubygems"],
	creates => "$gemdir/vagrant",
    }

}
