#!/usr/bin/env ruby

=begin
This code will be run on every non-master game server node.
It will accept connections only from the server and localhost (for debugging).
It is responsible for maintaining data about its own individual world state,
but not for validating any input.
=end

require 'socket'
require 'thread'
require_relative 'config'
require_relative 'network'
require_relative 'user'
require_relative 'tile'

$board = [] # Stores the actual board data
$boardlock = Mutex.new # For freezing all orders while we update board

def initBoard()
	for r in 0 .. (Boardsize.length - 1)
		row = []
		for x in 0 .. (Boardsize[r] - 1)
			row.push(Tile.new("hex", r, x))
		end
		$board.push(row)
	end
end

def getBoardDescription()
	descr = []
	for row in 0 .. ($board.length - 1)
		for col in 0 .. ($board[row].length - 1)
			descr.push($board[row][col].getIDString())
		end
	end
	return descr
end

def handleConnection(conn)
	while( command = conn.gets.chomp )
		if( command == "description" )
			response = getBoardDescription()
			for r in response
				conn.puts(r)
			end
		end
	end
	conn.close()
end

def listen()
	server = TCPServer.open(NodeListenPort)
	loop {
		Thread.start(server.accept) do |conn|
			handleConnection(conn)
		end
	}
end

if __FILE__ == $0
	puts "Starting game node..."
	initBoard()
	Thread.start() do listen end
	loop {
		# Does nothing, but eventually time updates will occur here
	}
end
