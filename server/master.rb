#!/usr/bin/env ruby

=begin
This code will run on one computer - the master game node that orders the other game nodes around
It is the only piece of code that directly interacts with users or any of the other game nodes.
=end

# Module imports
require 'socket'
require 'thread'

# Global constants and config
ListenPort = 2345
Thread.abort_on_exception = true

def log(msg)
	puts msg
end

def handleClient(s)
	log("New client connected!")
	s.puts("Hello user.")
	msg = s.gets
	msg = msg.gsub(/[^\w\d ]/, '') # Strip unwanted chars
	s.puts("I read: " + msg)
	s.puts("Goodbye user")
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
