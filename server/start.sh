#!/bin/sh

NAME=`hostname`

if [ "$NAME" = "dream1" ]; then
	./master.rb
else
	./game-node.rb
fi
