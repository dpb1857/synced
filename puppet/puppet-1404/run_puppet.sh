#!/bin/sh

set -x
sudo puppet apply --confdir=$HOME/synced/puppet/puppet-1404 manifests/site.pp
