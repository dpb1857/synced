# -*- Makefile -*-

default: help

################################################################################
# Makefile for creating Python virtual environments. It will:
#
# (a) Download, compile, and install a python into /usr/local/python-$(PYTHON_VERSION)
#     and install additional packages into the base distribution to support the use of
#     virtualenv; (make python)
#
# (b) Create python virtual environments (make virtual)
#
################################################################################

PYTHON_VERSION = 3.2.2
# PYTHON_VERSION = 2.7.2

PIP_VERSION = 1.1
DISTRIBUTE_VERSION = 0.6.25

PREFIX = /usr/local/python-$(PYTHON_VERSION)

# If version is 2.x.y, PYTHON is 'python';
# If version is 3.x.y, PYTHON is 'python3';
PYTHON = "python$(subst 2,,$(firstword $(subst ., ,$(PYTHON_VERSION))))"

######################################################################
# Install RHEL packages to compile python and extensions
######################################################################

RH_DEVEL_PACKAGES = zlib-devel 		\
		 openssl-devel		\
		 gdbm-devel		\
		 sqlite-devel		\
		 ncurses-devel		\
		 bzip2-devel		\
		 tcl-devel		\
		 tk-devel		\
		 readline-devel		\
		 db4-devel		\
		 mysql-devel

#		 Percona-SQL-client	\
#		 Percona-SQL-devel
#
# PERCONA_REPO_FILE = /etc/yum.repos.d/Percona.repo
#
# $(PERCONA_REPO_FILE):
# 	sudo $(MAKE) do_percona_repo
#
# do_percona_repo:
# 	echo '[percona]' > $(PERCONA_REPO_FILE)
# 	echo 'name=CentOS-$$releasever - Percona' >> $(PERCONA_REPO_FILE)
# 	echo 'baseurl=http://repo.percona.com/centos/$$releasever/os/$$basearch/' >> $(PERCONA_REPO_FILE)
# 	echo 'gpgcheck=0' >> $(PERCONA_REPO_FILE)
#
#
# $(RH_DEVEL_PACKAGES): # /etc/yum.repos.d/Percona.repo
# 	@sudo yum install -y $@

$(RH_DEVEL_PACKAGES):
	@sudo yum install -y $@

redhat-packages: $(DEVEL_PACKAGES)


######################################################################
# Install Debian/Ubuntu packages to compile python and extensions
######################################################################

# XXX or maybe libpqxx-dev for older releases?

DEB_DEVEL_PACKAGES = 	libmysqlclient-dev \
			libpqxx3-dev \
			libdb4.8-dev \
			libreadline6-dev \
			libbz2-dev \
			libgdbm-dev \
			libsqlite3-dev


$(DEB_DEVEL_PACKAGES):
	@sudo apt-get install -y $@

debian-packages: $(DEB_DEVEL_PACKAGES)

######################################################################
# Rules to build a python version in /usr/local.
######################################################################

python:
	@echo -n "Version of python to build (default is $(PYTHON_VERSION)): "; \
	read version; \
	if [ -z "$$version" ]; then version=$(PYTHON_VERSION); fi; \
	exec $(MAKE) PYTHON_VERSION=$$version do_python

do_python: $(PREFIX)/.prereq $(PREFIX)/bin/$(PYTHON) $(PREFIX)/.install_tools

python_shared: $(PREFIX)-shared/bin/$(PYTHON) $(PREFIX)-shared/.install_tools

$(PREFIX)/.prereq:
	if [ ! -d $(PREFIX) ]; then sudo mkdir -p $(PREFIX); fi
	if [ -f /etc/debian_version ]; then $(MAKE) debian-packages; fi
	sudo touch $@

$(HOME)/Downloads/Python-$(PYTHON_VERSION).tgz:
	(cd $(HOME)/Downloads && wget http://www.python.org/ftp/python/$(PYTHON_VERSION)/Python-$(PYTHON_VERSION).tgz)

force_python $(PREFIX)/bin/$(PYTHON): $(HOME)/Downloads/Python-$(PYTHON_VERSION).tgz
	cd /tmp &&							\
	tar xvzf $(HOME)/Downloads/Python-$(PYTHON_VERSION).tgz &&	\
	cd Python-$(PYTHON_VERSION) &&					\
	./configure --prefix=$(PREFIX) &&				\
	$(MAKE) 2>&1 | tee make.log &&					\
	sudo $(MAKE) install &&						\
	sudo sh -c "cd /tmp && rm -rf Python-$(PYTHON_VERSION)"

force_python_shared $(PREFIX)-shared/bin/$(PYTHON): $(HOME)/Downloads/Python-$(PYTHON_VERSION).tgz
	cd /tmp &&							\
	tar xvzf $(HOME)/Downloads/Python-$(PYTHON_VERSION).tgz &&	\
	cd Python-$(PYTHON_VERSION) &&					\
	./configure --prefix=$(PREFIX)-shared --enable-shared &&	\
	$(MAKE) 2>&1 | tee make.log &&					\
	sudo $(MAKE) install &&						\
	sudo sh -c "cd /tmp && rm -rf Python-$(PYTHON_VERSION)"

.PHONY: python force_python

$(PREFIX)/.install_tools:
	$(MAKE) distribute
	$(MAKE) pip
	$(MAKE) virtualenv
	sudo touch $@

$(PREFIX)-shared/.install_tools:
	$(MAKE) PREFIX=$(PREFIX)-shared distribute
	$(MAKE) PREFIX=$(PREFIX)-shared pip
	$(MAKE) PREFIX=$(PREFIX)-shared virtualenv
	sudo touch $@

distribute:
	cd /tmp &&	\
	wget http://pypi.python.org/packages/source/d/distribute/distribute-$(DISTRIBUTE_VERSION).tar.gz && 	\
	tar xvzf distribute-$(DISTRIBUTE_VERSION).tar.gz && \
	cd distribute-$(DISTRIBUTE_VERSION) && sudo LD_LIBRARY_PATH=$(PREFIX)/lib $(PREFIX)/bin/$(PYTHON) setup.py install && \
	cd /tmp && \
	sudo rm -rf distribute-$(DISTRIBUTE_VERSION) && \
	rm distribute-$(DISTRIBUTE_VERSION).tar.gz

pip:
	cd /tmp &&	\
	wget http://pypi.python.org/packages/source/p/pip/pip-$(PIP_VERSION).tar.gz && 	\
	tar xvzf pip-$(PIP_VERSION).tar.gz && \
	cd pip-$(PIP_VERSION) && sudo LD_LIBRARY_PATH=$(PREFIX)/lib $(PREFIX)/bin/$(PYTHON) setup.py install && \
	cd /tmp && \
	sudo rm -rf pip-$(PIP_VERSION) && \
	rm pip-$(PIP_VERSION).tar.gz

virtualenv:
	sudo LD_LIBRARY_PATH=$(PREFIX)/lib $(PREFIX)/bin/easy_install virtualenv

################################################################################
# Create a virtualenv python with $(REQUIREMENTS) packages added to
# the base distribution.
################################################################################

VIRTUAL_LOCATION = python

# SQLALCHEMY_VERSION = 0.5.8
SQLALCHEMY_VERSION = 0.6.5

REQUIREMENTS = \
	"pylint>=0.21.2" 			\
	"simplejson"				\
	"sqlalchemy==$(SQLALCHEMY_VERSION)"	\
	"sphinx>=1.0"				\

	# "MySQL-python"
	# "psycopg2"

PATH := $(abspath $(VIRTUAL_LOCATION))/bin:$(PREFIX)/bin:$(PATH)

download:
	mkdir download

$(VIRTUAL_LOCATION)/bin/$(PYTHON): download
	virtualenv $(VIRTUAL_LOCATION)

clean:
	-rm *~ 2>/dev/null

distclean: clean
	-rm -rf download 2>/dev/null

virtual: python $(VIRTUAL_LOCATION)/bin/$(PYTHON)
	pip install --download-cache=download $(REQUIREMENTS)

################################################################################
# Help
################################################################################

help:
	@echo "type 'make python' to build and install python in /usr/local/python-(VERSION), default version is $(PYTHON_VERSION)."
	@echo "type 'make virtual' to create a virtual python environment with the modules:"
	@echo "     " $(REQUIREMENTS)
	@echo "     in the directory $(abspath $(VIRTUAL_LOCATION))."
	@echo
