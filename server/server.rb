#!/usr/bin/env ruby

=begin
	This code is the 'main' for the server. It starts all major subsystems,
	does any overall initialization we need, and saves / restores state from
	disk.
=end

# Module imports
require 'socket'
require 'thread'
require_relative 'config'
require_relative 'board'
require_relative 'log'
require_relative 'client'

# This is a hack for handling repeated signals, as described here:
# http://www.sitepoint.com/the-self-pipe-trick-explained/
SIGNAL_QUEUE = []
[:INT, :QUIT, :TERM].each do |signal|
	Signal.trap(signal) do
		SIGNAL_QUEUE << signal
	end
end

def handleInt
	puts("") # My terminal prints '^C' when I press it, so let's clear that
	Log.log(Log::Info, "Saving state...")
	Configuration.prepareState()
	Board.save(Configuration::BoardPath)
	Users.save(Configuration::UserPath)
	Log.log(Log::Info, "Quitting...")
	exit(0)
end

if __FILE__ == $0
	Log.log(Log::Info, "Starting game server...")

	# Restore from disk or create new universe
	if( Configuration.stateExists? )
		Board.load(Configuration::BoardPath)
		Users.load(Configuration::UserPath)
		Configuration.clearState
	else
		Board.generate
	end

	# Start up networking and let the users inside
	server = TCPServer.open(Configuration::ListenPort)
	while(true)
		case SIGNAL_QUEUE.pop
		when :INT
			handleInt
		else
			begin
				client = server.accept_nonblock
				Thread.start do
					Log.log(Log::Debug, "Client connected")
					handleClient(client)
				end
			rescue
				# accept_nonblock throws an exception upon failure
				# we don't really care, so wait a second and try again
				sleep(1)
			end
		end
	end
end
