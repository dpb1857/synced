#!/bin/sh

set -x
sudo puppet apply --confdir=$HOME/synced/puppet/puppet-1310 manifests/site.pp
