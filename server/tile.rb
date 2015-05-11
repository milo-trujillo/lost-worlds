#!/usr/bin/env ruby

=begin
This describes how a tile works, and provides some functionality for game-nodes
=end

class Tile

	attr_reader :row
	attr_reader :column
	attr_reader :vertexes
	attr_accessor :type

	def initialize(type, row, column)
		@type = type
		@row = row
		@column = column
		@vertexes = ["empty", "empty", "empty", "empty", "empty", "empty"]
	end

	def getIDString()
		return ("Tile" + ":" + type + ":" + row.to_s + ":" + column.to_s + ":0")
	end

end

def getTotalTiles()
	total = 0
	for x in Boardsize
		total += x
	end
	return total
end
