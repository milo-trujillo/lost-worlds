#!/usr/bin/env ruby

=begin
This file holds global configuration options for the game, both in terms of
gameplay and technical configuration.

It is in its own file to make it easy to configure the master and game nodes
simultaneously.
=end

#
# Gameplay section
#

# This describes the number of rows, and the number of columns on each row
# The board is hexagonal, which makes describing it with arrays challenging
Boardsize = [3, 4, 5, 4, 3]
Tiletypes = ["coal", "iron", "shrooms"]

#
# Architecture configuration
#
Thread.abort_on_exception = true

