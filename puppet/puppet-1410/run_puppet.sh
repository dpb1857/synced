#!/bin/sh

set -x
sudo puppet apply --confdir=$HOME/synced/puppet/puppet-1410 manifests/site.pp
