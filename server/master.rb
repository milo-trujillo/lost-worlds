#!/usr/bin/env ruby

=begin
This code will run on one computer - the master game node that orders the other game nodes around
It is the only piece of code that directly interacts with users or any of the other game nodes.
=end

# Module imports
require 'socket'
require 'thread'
require_relative 'user'
require_relative 'network'

# Global constants and config
ListenPort = 2345
Thread.abort_on_exception = true

# Non constant globals
users = []

def log(msg)
	puts msg
end

def getDescription(s, world)
	s.puts("This is a description of the world.")
end

def handleCommand(s, command)
	case command
		when /^login:[\w+]:[\w+]$/
			# Login stuff goes here
			s.puts("LOGIN NOT YET IMPLEMENTED")
		when /^description:[\d+]$/
			world = command.split(':').last.to_i # Currently unused
			getDescription(s, world)
		when /^quit$/
			s.puts("Goodbye.")
			s.close()
		else
			s.puts("UNKNOWN COMMAND")
	end
end

def handleClient(s)
	log("New client connected!")
	s.puts("Hello user.")
	loggedIn = false # We'll handle some kind of account system later
	while( command = s.gets )
		command = command.gsub(/[^\w\d :]/, '') # Strip unwanted chars
		handleCommand(s, command)
	end
	log("Client disconnected")
	s.close()
end

def listen()
	server = TCPServer.open(ListenPort)
	loop {
		Thread.start(server.accept) do |client|
			handleClient(client)
		end
	}
end

if __FILE__ == $0
	puts "Starting master server..."
	Thread.start() do listen end
	puts "Master server started."
	loop {
		# Does nothing, but we need to stay open to listen for connections
	}
end
