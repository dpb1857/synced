# git/manifests/init.pp - install git
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class git
{
	package {
		# primary git packages
		["git-core", "git-svn"]: ensure => installed;
		# this is needed to clone http:// repos
		curl: ensure => installed;
	}
}

define git::clone ($source, $pull = 'origin') {

	include git

	$clone_command = "/usr/bin/git clone ${source} ${name}"

	$needed = gsub($source, '^/.*', 'is_path') ? { 
					'is_path' => [ Class['git'], File[$source] ],
					# let's assume this comes from the network and let's assume that
					# git will figure it out
					default => Class['git']
				}

	exec {
		$clone_command:
			creates => "${name}/.git",
			require => $needed;
	}

	case $pull {
		false: {}
		nothing: {}
		true: { # pull the default origin
			exec { "/usr/bin/git pull # cwd: ${name}":
				require => Exec[$clone_command],
				cwd => $name;
			}
		}
		default: { # pull the specified origin
			exec { "/usr/bin/git pull $pull # cwd: ${name}":
				require => Exec[$clone_command],
				cwd => $name;
			}
		}
	}

	file { $name: checksum => mtime }

}

define git::repo( $bare = false, $default_branch = 'master' ) {
	include git

	$bare_opt = $bare ? { true => '--bare', default => '' }
	$bare_creates = $bare ? { true => "${name}/HEAD", false => "${name}/.git" }

	file { $name: ensure => directory }

	exec { "/usr/bin/git init ${name}":
		command => "git ${bare_opt} init",
		cwd => $name,
		creates => $bare_creates,
	}

	if $bare {
		case $default_branch {
			'master': {}
			default: { debug("bare repository: no checkout available") }
		}
	} else {
		file { "${name}/.git/HEAD":
			ensure => present,
			content => template("git/HEAD")
		}
	}
}

class git::daemon
{
	# adjust here to your local setup
	$git_basepath = "/srv/davids/git"

	include git

	file { $git_basepath:
		ensure => directory,
		mode => 2775, owner => root, group => davids_admins,
	}

	file { "/etc/init.d/git-daemon":
		source => "puppet:///modules/git/init.d.git",
		mode => 0755, owner => root, group => root,
		notify => Service[git-daemon],
	}

	user { 
		git:
			provider => useradd,
			uid => 207,
			gid => nogroup,
			comment => "Git Daemon User",
			shell => "/bin/false",
			home => $git_basepath,
			before => Service[git-daemon],
	}

	service {
		git-daemon:
			ensure => running,
			enable => true,
			hasstatus => true,
			hasrestart => true,
	}

}

class git::web
{
	include git
	include apache

	package { gitweb: ensure => installed, require => Package["apache"] }

	apache::site {
		gitweb:
			ensure => present,
			content => template("git/gitweb-site"),
			require_package => gitweb
	}
}

# creates an appropriate symlink to export the repo via gitweb
define git::web::export($bare = false, $description = "undescribed", $cloneurl = '', $repobasedir) {
	include git::web

	$repopath_real = $bare ? {
		true => "${repobasedir}/${name}",
		false => "${repobasedir}/${name}/.git"
	}

	git::repo { $repopath: bare => $bare }
	file {
		"/var/cache/git/${name}": ensure => $repopath;
		"${repopath}/git-daemon-export-ok": ensure => present;
		"${repopath}/description": ensure => present, content => "${description}\n";
		"${repopath}/cloneurl":
			ensure => $cloneurl ? {
				'' => absent,
				default => present,
			},
			content => $cloneurl ? {
				'' => undef,
				default => "${cloneurl}\n",
			};
		# the default post-update hook calls git-update-server-info
		# to avoid overwriting local changes, I only set the executable bit here
		"${repopath}/hooks/post-update": mode => 0755;
	}
}


