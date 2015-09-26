#!/usr/bin/env ruby

=begin
This describes how a tile works, and provides some functionality for game-nodes
=end

require_relative('config')

# In case the board later changes shape
TileVertexes = 6

class Tile

	attr_reader :probability
	attr_accessor :type

	def initialize(type, probability)
		@type = type
		@probability = probability
	end

	def getIDString(row, column)
		return ["Tile", type, row.to_s, column.to_s, probability.to_s].join(":")
	end

end

# Calculates the row / column of an adjoining tile, based on the side
# 'sides' are numbered 0 through 5, with 0 being upper left, and moving 
# clockwise. Returns a tuple of [row, column] for the resulting tile.
def adjoiningTile(row, column, side)
	if( row.is_a?(Integer) && column.is_a?(Integer) && side.is_a?(Integer) )
		case side
			when 0
				return [row - 1, column - 1]
			when 1
				return [row - 1, column]
			when 2
				return [row, column + 1]
			when 3
				return [row + 1, column]
			when 4
				return [row + 1, column - 1]
			when 5
				return [row, column - 1]
			else
				raise "Invalid side (" + side.to_s + ")!"
		end
	else
		raise "Expected a (row, column, side) as (int, int, int)"
	end
end
