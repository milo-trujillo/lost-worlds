#!/usr/bin/env ruby

=begin
This file holds global configuration options for the game, both in terms of
gameplay and technical configuration.
=end

module Configuration
	#
	# Gameplay section
	#

	# This describes the number of rows, and the number of columns on each row
	# The board is hexagonal, which makes describing it with arrays challenging
	BoardWidth = 200
	BoardHeight = 200
	Tiletypes = ["coal", "iron", "shrooms"] 
	# There is also an 'empty' type, not included so it isn't used during generation
	Turnduration = 60 # Seconds between turn executions

	#
	# Architecture configuration
	#
	Thread.abort_on_exception = true
	DebugMode = true

	#
	# Network configuration
	#
	ListenPort = 2345
end
