#!/usr/bin/env ruby

=begin
This file defines the actual game board and how to update the board when a new
turn is executed. It has no interaction with the network, solely maintaining
internal state for each game node.
=end

require_relative 'config'
require_relative 'random'
require_relative 'user'
require_relative 'tile'
require_relative 'log'

$board = [] # Stores the actual board data

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

	probpool = []
	diff = 0
	while( probpool.length() < getTotalTiles() )
		probpool.push(Midroll + diff)
		if( probpool.length < getTotalTiles() && diff != 0 )
			probpool.push(Midroll - diff)
		end
		diff += 1
		if( 7 + diff > Maxroll )
			diff = 0
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
			prob = extractRandomElement(probpool)
			row.push(Tile.new(type, r, x, prob))
		end
		$board.push(row)
	end
end

# Returns a textual description of each tile on the board
def getBoardDescription()
	log("Returning board description")
	descr = []
	for row in 0 .. ($board.length - 1)
		for col in 0 .. ($board[row].length - 1)
			descr.push($board[row][col].getIDString())
		end
	end
	vertexes = Hash.new
	for row in 0 .. ($board.length - 1)
		for col in 0 .. ($board[row].length - 1)
			for vertex in (0 .. TileVertexes - 1)
				vertexes[standardizeCoordinate(row, col, vertex)] = 1
			end
		end
	end
	for coord in vertexes.keys
		unit = $board[coord[0]][coord[1]].vertexes[coord[2]].getUnitID()
		building = $board[coord[0]][coord[1]].vertexes[coord[2]].getBuildingID()
		if( unit != "empty" )
			descr.push(["Unit", coord[0], coord[1], coord[2], unit].join(':'))
		end
		if( building != "empty" )
			descr.push(["Building", coord[0], coord[1], coord[2], building].join(':'))
		end
	end

	return descr
end

# Process the orders on the board and update board state
def updateBoard(orders)
	log("Processing " + orders.length.to_s + " orders")
end
