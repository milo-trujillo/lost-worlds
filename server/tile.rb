#!/usr/bin/env ruby

=begin
This describes how a tile works, and provides some functionality for game-nodes
=end

class Tile

	attr_reader :row
	attr_reader :column
	attr_reader :vertexes
	attr_reader :probability
	attr_accessor :type

	def initialize(type, row, column, probability)
		@type = type
		@row = row
		@column = column
		@probability = probability
		@vertexes = ["empty", "empty", "empty", "empty", "empty", "empty"]
	end

	def getIDString()
		return ["Title", type, row.to_s, column.to_s, probability.to_s].join(":")
	end

end

# Calculates the coordinates and verices overlapping a particular tile/vertex
def adjoiningTiles(tile, vertex)
	if( tile.is_a?(Tile) && vertex.is_a?(Integer) )
		case vertex
			when 0
				return [[tile.row - 1,tile.col - 1, 2],
					[tile.row - 1, tile.col, 4]]
			when 1
				return [[tile.row - 1, tile.col, 3],
					[tile.row, tile.col + 1, 5]]
			when 2
				return [[tile.row, tile.col + 1, 4],
					[tile.row + 1, tile.col, 0]]
			when 3
				return [[tile.row + 1, tile.col - 1, 1],
					[tile.row + 1, tile.col, 5]]
			when 4
				return [[tile.row, tile.col - 1, 2],
					[tile.row + 1, tile.col - 1, 0]]
			when 5
				return [[tile.row - 1, tile.col - 1, 3],
					[tile.row, tile.col - 1, 1]]
			else
				raise "Invalid vertex!"
		end
	else
		raise "Expected a tile and an integer vertex"
	end
end

def getTotalTiles()
	total = 0
	for x in Boardsize
		total += x
	end
	return total
end
