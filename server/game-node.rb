#!/usr/bin/env ruby

=begin
This code will be run on every non-master game server node.
It will accept connections only from the server and localhost (for debugging).
It is responsible for maintaining data about its own individual world state,
but not for validating any input.
=end

require 'socket'
require 'thread'

if __FILE__ == $0
	puts "Server node started..."
end
