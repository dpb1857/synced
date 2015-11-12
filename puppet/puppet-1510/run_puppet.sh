#!/bin/sh

set -x
sudo puppet apply --confdir=$HOME/synced/puppet/puppet-1510 manifests/site.pp
