#!/usr/bin/env ruby

=begin
This code will run on one computer - the master game node that orders the other
game nodes around. It is the only piece of code that directly interacts with 
users or any of the other game nodes.
=end

# Module imports
require 'socket'
require 'thread'
require_relative 'user'
require_relative 'network'
require_relative 'config'
require_relative 'log'

# Non constant globals
$users = []

def getDescription(s, world)
	begin
		gn = contactNode(world.to_i)
		gn.puts("description")
		forwardResponse(s, gn)
	rescue
		log("Error getting description")
	end
end

def buildStructure(s, info)
	# building_type:continent:row:column:vertex
	begin
		gn = contactNode(info[1].to_i)
		gn.puts("build:"+info[0]+":"+(info[2..4].join(':')))
		forwardResponse(s, gn)
	rescue
		log("Error placing build order")
	end
end

def handleCommand(s, command)
	case command
		# login:username:password
		when /^login:[\w]+:[\w]+$/
			# Login stuff goes here
			s.puts("LOGIN NOT YET IMPLEMENTED")
		# description:continent_number
		when /^description:[\d]+$/
			world = command.split(':').last.to_i
			getDescription(s, world)
		# build:building_type:continent:row:column:vertex
		when /^build:[\w]+:[\d]+:[\d]+:[\d]+:[\d]+$/
			buildStructure(s, command.split(':')[1..5])
		else
			s.puts("UNKNOWN COMMAND")
	end
	s.close()
end

#
# handleClient - Parses a single user command, then exits
#
def handleClient(s)
	begin
		log("New client connected!")
		s.puts("Hello user. Welcome to Lost Worlds.")
		loggedIn = false # We'll handle some kind of account system later
		if( (! s.closed?) && command = s.gets )
			command = command.gsub(/[^\w\d :]/, '') # Strip unwanted chars
			handleCommand(s, command)
		end
		unless( s.closed? )
			s.close()
		end
		log("Client disconnected")
	rescue
		log("Client failure")
		unless( s.closed? )
			s.close()
		end
	end
end

def listen()
	server = TCPServer.open(MasterListenPort)
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
