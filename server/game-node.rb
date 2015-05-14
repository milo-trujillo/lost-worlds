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
require_relative 'random'
require_relative 'user'
require_relative 'tile'

$board = [] # Stores the actual board data
$boardlock = Mutex.new # For freezing all orders while we update board

#
# We want a fairly even distribution of resources across the continent
# We also want a fairly even distribution of dice rolls for our tiles.
# We'll get this by generating numbers from the center of 2..12 outwards
# in both directions, repeated until we run out of tiles.
#
# Note to self: Start at die roll 7 and work outwards
#
def initBoard()
	tilepool = []
	tiledistribution = (getTotalTiles() / Tiletypes.length).to_i
	for type in Tiletypes
		for x in (1 .. tiledistribution)
			tilepool.push(type)
		end
	end

	for r in 0 .. (Boardsize.length - 1)
		row = []
		for x in 0 .. (Boardsize[r] - 1)
			type = ""
			if( tilepool.length > 0 )
				type = extractRandomElement(tilepool)
			else
				type = getRandomElement(Tiletypes)
			end
			row.push(Tile.new(type, r, x))
		end
		$board.push(row)
	end
end

def log(s)
	puts(s)
end

def getBoardDescription()
	log("Returning board description")
	descr = []
	for row in 0 .. ($board.length - 1)
		for col in 0 .. ($board[row].length - 1)
			descr.push($board[row][col].getIDString())
		end
	end
	return descr
end

def handleConnection(conn)
	command = conn.gets.chomp()
	if( command == "description" )
		response = getBoardDescription()
		for r in response
			conn.puts(r)
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
