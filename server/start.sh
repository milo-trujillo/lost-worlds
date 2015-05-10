#!/bin/sh

#
# In our testing environment the master node is named "dream1"
# and all nodes are controlled simultaneously. This script makes
# it easy to start all nodes in unison.
#

NAME=`hostname`

if [ "$NAME" = "dream1" ]; then
	./master.rb
else
	./game-node.rb
fi
