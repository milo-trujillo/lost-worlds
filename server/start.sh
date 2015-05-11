#!/usr/bin/env bash

#
# In our testing environment the master node is named "dream1"
# and all nodes are controlled simultaneously. This script makes
# it easy to start all nodes in unison.
#

DIR=`dirname "$BASH_SOURCE"`
NAME=`hostname`

if [ "$NAME" = "dream1" ]; then
	$DIR/master.rb
else
	$DIR/game-node.rb
fi
