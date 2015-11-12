

class emacs-magit($emacs = 'emacs', $creates) {

    git::clone {"/usr/local/magit":
	source => "http://github.com/magit/magit.git",
	pull   => false,
    }

    exec {
        "/usr/bin/git checkout 1.2.0 && /usr/bin/make install # installing magit into $emacs":
	require => Git::Clone['/usr/local/magit'],
	cwd     => "/usr/local/magit",
	creates => $creates,
    }
}
