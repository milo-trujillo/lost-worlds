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

def getTotalTiles()
	total = 0
	for x in Boardsize
		total += x
	end
	return total
end
