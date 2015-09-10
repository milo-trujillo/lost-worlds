#!/usr/bin/env ruby

=begin
This file holds global configuration options for the game, both in terms of
gameplay and technical configuration.
=end

#
# Gameplay section
#

# This describes the number of rows, and the number of columns on each row
# The board is hexagonal, which makes describing it with arrays challenging
Boardsize = [3, 4, 5, 4, 3]
Tiletypes = ["coal", "iron", "shrooms"]
Turnduration = 60 # Seconds between turn executions

#
# Architecture configuration
#
Thread.abort_on_exception = true

#
# Network configuration
#
ListenPort = 2345
