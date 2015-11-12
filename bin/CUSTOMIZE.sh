#!/bin/bash

USER=`whoami`

# do_packages function_name [package1 package2 ...]
function do_packages() {
    group_name=$1
    shift
    echo
    echo "***"
    echo "*** Function: $group_name"
    echo "***"
    echo
    echo -n "Install packages $* [y/N]? "
    read var
    if [ "$var" == "y" ]; then
	sudo apt-get install $*
	return 0
    fi
    return 1
}

function do_packages_with_config() {
    package=$1
    do_packages $*
    if [ $? -eq 0 ]; then
	return 0
    fi
    
    echo -n "Install configuration files for $package [y/N]? "
    read var
    if [ "$var" == "y" ]; then
	return 0
    fi
    return 1
}

function setup_filesystems() {
    echo
    echo "***"
    echo "*** Function: setup_filesystem"
    echo "***"
    echo
    if [ ! -d /home/dpb-stuff ]; then
        echo -n "Add fstab entries for /home/vbox, /home/scratch, /home/dpb-stuff? "
        read var
        if [ "$var" == "y" ]; then
            sudo mkdir /home/vbox
            sudo mkdir /home/scratch
            sudo mkdir /home/dpb-stuff
            sudo chown $USER:$USER /home/vbox /home/scratch /home/dpb-stuff
            cat > /tmp/fstab-additions.txt << EOF
# /home/dpb-stuff was on /dev/sda8 during installation
UUID=08f67da9-ae3e-4804-8f90-cde248d542d0 /home/dpb-stuff ext3    relatime        0       2
# /home/scratch was on /dev/sda9 during installation
UUID=ff88e5d5-9b33-4616-8ef6-bbafe8238dbb /home/scratch   ext3    relatime        0       2
# /home/vbox was on /dev/sda11 during installation
UUID=33236d08-fab9-4a7b-98a2-b98dea91ebc4 /home/vbox      ext3    relatime        0       2
EOF
            sudo sh -c "cat >> /etc/fstab < /tmp/fstab-additions.txt"
            rm -f /tmp/fstab-additions.txt
        fi
    fi
}

function setup_crypt_filesystems() {
    do_packages setup_crypt_filesystems ecryptfs-utils cryptsetup
}

function setup_system_ui() {
    echo
    echo "***"
    echo "*** Function: setup_system_ui"
    echo "***"
    echo
    echo "Now would be a good time to make the CapsLock to Control..."
    echo "System->Preferences->Keyboard, [Layouts]->Options->CtrlKeyPosition->Make CapsLock an addiitonal Control;"
    echo "(UNITY) search for 'keyboard'";
    echo "Hit return when finished..."
    read var

    echo "Now, adjust the power settings.  Don't sleep when the lid closes..."
    echo "System->Preferences->PowerManagement; On AC Power/On Battery power, don't sleep when the lid is closed."
    echo "(UNITY) search for 'power'";
    echo "Press <return> to continue"
    read var

    echo "Don't lock the screen when screensaver kick in..."
    echo "System->Preferences->Screensaver[uncheck 'lock screen when screensaver active']"
    echo "(UNITY) search for 'screensaver'";
    echo "Press <return> to continue"
    read var

    echo "Setup some keyboard shortcuts..."
    echo "System->Preferences->KeyboardShortcuts - "
    echo "  Launch web browser: c-m-w"
    echo "  Launch shell window: c-m-s"
    echo "(UNITY) search for 'keyboard'";
    echo "Press <return> to continue"
    read var

    do_packages setup_system_ui compizconfig-settings-manager
    echo "Setup compiz keyboard shortcuts"
    echo "compizconfig[Commands] → General → Commands → Commands/Keybindings"
    echo "  Command 0: emacs -geometry =80×50"
    echo "  Command 1: gnome-terminal –geometry(two dashes!) =100×50"
    echo "  bind command 0 to c-m-x"
    echo "  bind command 1 to c-m-s"
    echo "Press <return> to continue"
    read var

    echo "Add /usr/bin/gconf-editor to the system->preferences menu."
    echo "Press <return> to continue"
    read var
    
    echo "Move window buttons back to the right (if you want them on the right)"
    echo "gconf-editor:apps/metacity/general/button_layout: just move the colon to the far left"
    # echo "also, reorder to put close on the right;"
    # echo "Press <return> to continue"
    # read var
    echo "I'll take care of that now..."
    set -x
    gconftool-2 --type string --set /apps/metacity/general/button_layout ":minimize,maximize,close"
    set +x
    sleep 1

    echo "Add emacs editing to gnome..."
    set -x
    gconftool-2 --type string --set /desktop/gnome/interface/gtk_key_theme Emacs
    set +x
    sleep 1
}

function setup_system_utilities() {
    do_packages setup_system_utilities sysstat iotop filelight rdiff-backup gparted cpulimit
}

function setup_system_crontab() {
    echo "***"
    echo "*** Add backup crontab entry"
    echo "***"
    echo "Install system crontab job to do dpb-specific backups?"
    echo "Press "y" to add crontab entry"
    read var

    if [ "$var" = "y" ]; then
	set -x
	sudo sh -c "echo '0 22 * * * root /home/dpb-stuff/stuff/bin/backup' >> /etc/crontab"
	set +x
    fi

}

function setup_shell() {
    echo "***"
    echo "*** Function: setup_shell"
    echo "***"
    echo
    if [ -f $HOME/synced/dot-files/dot-bashrc-dpb ]; then
	if grep dot-bashrc $HOME/.bashrc>/dev/null; then
	    return
	fi
	echo "Hooks to dot-bashrc-dpb, dot-profile-dpb not installed yet, doing so now..."
	echo ". $HOME/synced/dot-files/dot-bashrc-dpb" >> $HOME/.bashrc
	echo ". $HOME/synced/dot-files/dot-profile-dpb" >> $HOME/.profile
	sleep 2
    fi
}

function setup_editors() {
    # Need to install makeinfo to build magit;
    do_packages_with_config setup_editors mg emacs zile texinfo python-mode
    if [ $? -eq 0 -a -f $HOME/synced/dot-files/dot-emacs -a ! -h .emacs ]; then
	echo "Creating the symlink for .emacs..."
        ln -s $HOME/synced/dot-files/dot-emacs .emacs

	# Make sure we've got git so we can clone these emacs packages...
	sudo apt-get install git-core

	echo "Installing magit package..."
	(cd /tmp && git clone http://github.com/philjackson/magit.git)
	(cd /tmp/magit && make)
	(cd /tmp/magit && sudo make install)
	(cd /tmp && rm -rf magit)
	
	mkdir $HOME/elisp
	echo "clone git-emacs..."
	(cd $HOME/elisp && git clone https://github.com/tsgates/git-emacs.git)
	echo "clone gitsum..."
	(cd $HOME/elisp && git clone https://github.com/chneukirchen/gitsum.git)
	echo "downloading ipython.el"
	(cd $HOME/elisp && curl http://ipython.scipy.org/dist/ipython.el > ipython.el)
	# XXX how about python-mode?  in 11.04, I have it in my ~/elisp directory;
	# should we download it here or what?
	(cd $HOME/elisp && curl http://dishevelled.net/elisp/lambda-mode.el > lambda-mode.el)
    fi
}

function setup_browsers() {
    echo
    echo "***"
    echo "*** Function: setup_browsers"
    echo "***"
    echo
    echo "SKIPPING, do by hand for now"
    return
    # XXX fixme
    if [ ! -h .mozilla -a -d /mnt/shared/dpb/dot-files/dot-mozilla36 ]; then
	echo -n ".mozilla is not a symlink; remove it and link it to .../dot-mozilla36? [y/N] "
	read var
	if [ "$var" == "y" ]; then
	    set -x
	    rm -rf .mozilla
            ln -s /mnt/shared/dpb/dot-files/dot-mozilla36 .mozilla
	    set +x
	fi
    fi

    if [ ! -h .config/chromium -a -d /mnt/shared/dpb/dot-files/dot-chromium ]; then
	echo -n ".config/chromium is not a symlink; remove it and link it to .../dot-chromium? [y/N] "
	read var
	if [ "$var" == "y" ]; then
	    set -x
	    rm -rf .config/chromium
            ln -s /mnt/shared/dpb/dot-files/dot-chromium .config/chromium
	    set +x
	fi
    fi

    do_packages setup_browsers chromium-browser
}

function setup_webservers() {
    do_packages setup_webservers nginx apache2 apache2-doc
}

function setup_linkeddirs() {
    for srcdir in /home/dpb-stuff/linked-dirs /mnt/shared/dpb/linked-dirs /mnt/shared/dpb-x100/linked-dirs; do 
	if [ -d $srcdir ]; then
	    echo
	    echo "***"
	    echo "*** Function: setup_linked_dirs"
	    echo "***"
	    echo

	    echo -n "Link to directories in $srcdir [y/N] "
	    read var
	    if [ "$var" == "y" ]; then
		echo
		dirs=`cd $srcdir && echo *`
		for dir in $dirs; do
		    if [ -h $dir ]; then
			rm -f $dir
		    fi
		    if [ -d $dir ]; then
			rmdir $dir
		    fi	
		    if [ -d $dir ]; then
			echo "***** Could not remove existing directory $dir, skipping..."
		    else
			ln -s $srcdir/$dir $dir
			echo "Linking $dir to $srcdir/$dir"
		    fi
		done
	    fi
	fi
    done
}

function setup_private_dir() {
    echo "***"
    echo "*** Configure Private Directory..."
    echo "***"
    echo
    echo "Setup ~/Private directory [y/N]? "
    read var
    if [ "$var" == "y" ]; then
	if [ ! -d Private ]; then
	    ecryptfs-setup-private
	    echo "You will need to logout and re-login for your Private directory to be mounted..."
	    echo "Hit <return> to continue"
	    read var
	fi
    fi
}

function setup_desktop() {
    do_packages_with_config setup_desktop jpilot jpilot-plugins
    if [ $? -eq 0 -a ! -h .jpilot -a -d /home/dpb-stuff/dot-files/dot-jpilot ]; then
	set -x
	ln -s /home/dpb-stuff/dot-files/dot-jpilot .jpilot
	set +x
    fi
}

function setup_office() {
    # scribus: DTP
    # lprof: color profiles
    # krita: kde paint program

    PACKAGES="
	abiword
	antiword
	dia-gnome
	gnucash
	gnucash-docs
	inkscape
	krita
	ksnapshot
	lprof
	lyx
	pdfjam
	pdfposter
	pdftk
	scribus
	thunderbird
    "

    do_packages_with_config setup_office $PACKAGES
    if [ $? -eq 0 ]; then
        if [ -d /home/dpb-stuff/dot-files/dot-gnucash -a ! -h .gnucash ]; then
	    set -x
	    ln -s /home/dpb-stuff/dot-files/dot-gnucash .gnucash
	    set +x
	fi
	sudo add-apt-repository ppa:vincent-c/nevernote
	sudo apt-get update
	sudo apt-get install nevernote

	if [ ! -h .nevernote -a -d $HOME/Private ]; then
	    set -x
	    rm -rf .nevernote
	    mkdir -p $HOME/Private/dot-nevernote
	    ln -s $HOME/Private/dot-nevernote .nevernote
	    set +x
	fi
    fi
}

function setup_database() {
    NOTNOW="
	postgresql
	postgresql-doc
	postgresql-contrib
	pgadmin3
	python-psycopg2
	ptop
        "
    PACKAGES="
	sqlite3 
	sqlite3-doc 
	sqliteman 
	sqliteman-doc
	mysql-client
	mysql-server
	mysql-admin
        memcached
	redis-doc
	redis-server
	python-redis
        libdb4.8
	db4.8-doc
	db4.8-util
	xqilla
	"
    # pgpool2
    # mariadb

    echo "For now, getting postgres from: ppa:pitti/postgresql (see https://launchpad.net/~pitti/+archive/postgresql)"
    do_packages setup_database $PACKAGES
    grep -q "^postgres.*$USER" /etc/group
    if [ $? -ne 0 ]; then
	sudo adduser $USER postgres
    fi
}

function setup_network_filesystems() {
    do_packages setup_network_filesystems sshfs curlftpfs autofs nfs-common
    if [ $? -eq 0 -a ! -d /mnt/stmarks ]; then
	sudo mkdir /mnt/stmarks
	sudo mkdir /mnt/stuff
	sudo chown $USER:$USER /mnt/stmarks /mnt/stuff
	sudo adduser $USER fuse

	echo "Copy ssh host keys from a previous instance via:"
	echo "  rsync -av ssh_host* /etc/ssh"
	echo "Press <return> to continue"
	read var
	# XXX is the installed /etc/auto.master good enough, or do we need to change it?
	echo "To enable the automounter, edit /etc/auto.master and uncomment the line"
	echo "that starts with /net".
	echo "Press <return> to continue"
	read var
    fi
}

function setup_network_connectivity() {
    do_packages setup_network_connectivity openssh-server 
    if [ $? -eq 0 ]; then
	grep 'XXX dpb' /etc/ssh/sshd_config > /dev/null 2>&1
	if [ $? -ne 0 ]; then
	    echo -n "Add sshd listener on port 32022 [y/N]? "
	    read var
	    if [ "$var" == "y" ]; then
		set -x
	    	sudo sh -c "echo '' >> /etc/ssh/sshd_config"
	    	sudo sh -c "echo '# XXX dpb add an additional high-numbered port;' >> /etc/ssh/sshd_config"
	    	sudo sh -c "echo 'Port 32022' >> /etc/ssh/sshd_config"
	    	set +x
	    fi
	fi
    fi

    if [ ! -h .ssh -a -d $HOME/Private ]; then
	set -x
	rm -rf .ssh
	mkdir $HOME/Private/dot-ssh
	chmod 700 $HOME/Private/dot-ssh
	ln -s $HOME/Private/dot-ssh .ssh
	set +x
    fi

    if [ ! -d /usr/NX ]; then
	echo -n "Download and install NX, then hit <return> to continue..."
	echo -n "You will need to install libaudiofile0 before installing NX."
	read var
    fi
}

function setup_network_utilities() {
    do_packages setup_network_utilities ntp ntp-doc curl wireshark traceroute
}

function setup_java() {
    # sun-java6 packages moved to partner repositories - to install, use:
    # add-apt-repository "deb http://archive.canonical.com/ lucid partner"

    PACKAGES="
	ant 
	ant-doc 
	antlr 
	antlr-doc 
	javacc 
	javacc-doc 
	jmeter
	junit 
	liblog4j1.2-java 
	liblog4j1.2-java-doc
	libsaxon-java 
	libsaxon-java-doc 
	openjdk-6-demo 
	openjdk-6-doc 
	openjdk-6-jdk
"
    do_packages setup_java $PACKAGES
}

function setup_cpp() {
    PACKAGES="
	c++-annotations
	cpp-doc 
	g++ 
	gcc-doc 
	libboost-all-dev
	libboost-doc
	libstdc++6-4.4-doc
	stl-manual
	"
    do_packages setup_c++ $PACKAGES
}

function setup_devtools() {
    PACKAGES="
	autoconf
	eclipse
        git-core 
	git-cvs 
	git-doc 
	git-gui
	git-svn 
	gitk 
	libtool
	subversion"
    do_packages_with_config setup_devtools $PACKAGES
    if [ ! -f .gitconfig -a -f $HOME/synced/dot-files/dot-gitconfig ]; then
	set -x
	ln -s $HOME/synced/dot-files/dot-gitconfig $HOME/.gitconfig
	set +x
    fi

    echo "Possible eclipse plugins to download and install:"
    echo "  subversive (svn support)"
    read var
}

function setup_doctools() {
    do_packages setup_doctools texi2html texinfo
}

function setup_misc_utilities() {
    PACKAGES="
	apcalc
	qalculate-gtk
	python-chardet
        gpsbabel
        gpsbabel-doc
        gpsbabel-gui
	pdfgrep
    "
    do_packages setup_misc_utilities $PACKAGES
}

function setup_extra_docs() {
    do_packages setup_extra_docs bash-doc binutils-doc diff-doc make-doc manpages-dev tar-doc
}

function setup_phototools() {
    PACKAGES="
	digikam 
	digikam-doc 
	gimp 
	gimp-help-en
	gscan2pdf
	hugin
	imagemagick 
	kipi-plugins 
	showfoto
	xsane
    "
    # XXX not in 10.10? kipi-plugins-doc
    do_packages setup_phototools $PACKAGES
}

# OpenShot & H.264: 
# from: http://www.openshotusers.com/forum/viewtopic.php?f=12&t=912
# Solved. Went to Synaptic and installed libavformat-extra-52 and that did it.


function setup_multimedia() {
    PACKAGES="
	amarok
	audacity
	avidemux
	easytag
	kino
	libxine1-ffmpeg
	mjpegtools
	libavformat-extra-52
	openshot
	ripperx
    "
    do_packages_with_config setup_multimedia $PACKAGES
    if [ $? -eq 0 ]; then
	set -x
	if [ -d /home/dpb-stuff/dot-files/dot-gnome2-rhythmbox -a ! -h .gnome2/rhythmbox ]; then
	    ln -s /home/dpb-stuff/dot-files/dot-gnome2-rhythmbox .gnome2/rhythmbox
	fi
	if [ -f /home/dpb-stuff/dot-files/dot-ripperXrc -a ! -h .ripperXrc ]; then
	    ln -s /home/dpb-stuff/dot-files/dot-ripperXrc .ripperXrc
	fi
	set +x
    fi
}

function setup_python() {
    # Even if we later download and install the latest pylint, actually 
    # installing the Ubuntu pylint package adds the stuff to emacs Python mode to 
    # run pylint from emacs.
    PACKAGES="
	ipython
        pylint
	python-bsddb3
	python-bsddb3-doc
	python-doc
	python-virtualenv
	python3
    "
    UNUSED_PACKAGES="
	python-django
	python-django-doc
	python-django-debug-toolbar
	python-django-djblets
	python-django-extensions
	python-django-filebrowser
	python-django-lint
	python-django-registration
	python-django-swordfish
	python-epydoc
	python-levenshtein
	python-lxml
	python-lxml-doc
	python-memcache
	python-mysqldb
	python-numpy
	python-numpy-doc
	python-pexpect
	python-pqueue
	python-psycopg2
	python-pycurl
	python-pyrss2gen
	python-setuptools
	python-sphinx
	python-sqlalchemy
	python-sqlalchemy-doc
	python-werkzeug
    "
    do_packages setup_python $PACKAGES

    # Using ipython:
    # 
    # pip install the latest ipython - command line options have changed, we can't easily
    # drive it from ipython.el when 0.10 uses '-' for options and 0.11 uses '--' .
    # To use it in a virtualenv, install ipython again so it uses the virtual python and its packages.
    #
    # XXX revisit this in a future release, see if they've updated the shipped ipython file.

    sudo pip install ipython --upgrade
}

function setup_languages() {
    PACKAGES="
	clisp
	clisp-doc
	clojure
	gambc
	gambc-doc
	plt-scheme
	plt-scheme-doc
	jython 
	jython-doc
	scala
	scala-doc
    "
    do_packages setup_languages $PACKAGES
}

function setup_virtualbox() {
    echo
    echo "***"
    echo "*** Setup virtualbox... ***"
    echo "***"
    echo 
    echo -n "Install Virtualbox [y/N]? "
    read var
    if [ "$var" == "y" ]; then
	echo "Adding download site for virtualbox..."
	sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian natty contrib' >> /tmp/testing.list"
	echo "Adding  the Oracle public key:"
	sudo wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
	echo "Running apt-get update"
	sudo apt-get update
	sudo apt-get install dkms virtualbox-4.0
    fi
    echo -n "Link to Virtualbox config directory [y/N]? "
    read var
    if [ "$var" == "y" ]; then
	set -x
	ln -s /home/vbox/dot-VirtualBox .VirtualBox
	set +x
    fi
}

function setup_cloud() {
    PACKAGES="
	rubygems
    "

    echo
    echo "***"
    echo "*** Cloud support: ***"
    echo "***"

    do_packages setup_cloud $PACKAGES
    if [ $? -eq 0 ]; then
	gem install vagrant
    fi
}

function setup_restricted_extras() {
    echo
    echo "***"
    echo "*** Restricted extras setup: ***"
    echo "***"
    echo 
    echo "Start synaptic, goto Settings->Repositories->[OtherSoftware], check both, then shutdown."
    echo "press <enter> to continue..."
    read var
    do_packages setup_restricted_extras ubuntu-restricted-extras
}

function setup_toys() {
    do_packages setup_toys gnudoq googleearth-package
}

function setup_games() {
    do_packages tuxmath
}

cd $HOME

setup_restricted_extras

# emacs (editors) needs texinfo (doctools)
setup_doctools
setup_editors
setup_filesystems
setup_system_ui
setup_system_utilities
setup_system_crontab
setup_crypt_filesystems
setup_network_filesystems
setup_private_dir
setup_network_connectivity
setup_network_utilities

setup_shell
setup_browsers
setup_webservers
setup_linkeddirs

setup_desktop
setup_office

setup_java
setup_cpp
setup_devtools
setup_python
setup_languages

setup_database
setup_misc_utilities
setup_extra_docs

setup_phototools
setup_multimedia

setup_virtualbox
setup_cloud
setup_games
# Simplest solution for installing GoogleEarth would appear to be to add the medibuntu repositories...
# setup_toys
