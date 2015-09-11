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
require_relative 'log'
require_relative 'client'

# Non constant globals
$users = []
$userlock = Mutex.new # So we don't create two identical users

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
	Log.log(Log::Info, "Quitting...")
	exit(0)
end

if __FILE__ == $0
	puts "Starting game server..."
	# Do initialization here
	#if( Configuration.stateExists )
		# Load and clear state
	#end
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
