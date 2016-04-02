#!/bin/sh

set -x
sudo puppet apply --confdir=$HOME/synced/puppet/puppet-1604 manifests/site.pp
