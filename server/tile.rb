#!/usr/bin/env ruby

=begin
This describes how a tile works, and provides some functionality for game-nodes
=end

require_relative('config')
require_relative('unit')
require_relative('building')

# In case the board later changes shape
TileVertexes = 5

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
		@vertexes = Array.new(6, Vertex.new)
	end

	def getIDString()
		return ["Tile", type, row.to_s, column.to_s, probability.to_s].join(":")
	end

	def col
		return column
	end

	# TODO: Throw some exception here if unit and building aren't correct types
	def setVertexUnit(vertex, unit)
		@vertexes[vertex].unit = unit
	end
	
	def setVertexBuilding(vertex, building)
		@vertexes[vertex].building = building
	end

end

=begin
Every vertex on a board can contain a unit, building, or both. This class
simplifies that task.
=end
class Vertex
	attr_accessor :unit
	attr_accessor :building

	def initialize()
		@unit = "empty"
		@building = "empty"
	end

	def getUnitID()
		if( @unit == "empty" )
			return "empty"
		else
			return [@unit.type, @unit.user].join(":")
		end
	end

	def getBuildingID()
		if( @building == "empty" )
			return "empty"
		else
			return [@building.type, @building.user].join(":")
		end
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
				raise "Invalid vertex (" + vertex.to_s + ")!"
		end
	else
		raise "Expected a tile and an integer vertex"
	end
end

# Every coordinate has, at maximum, two additional overlapping points.
# Given a coordinate, this function returns the most upper left version as
# an array.
def standardizeCoordinate(row, col, vertex)
	coords = []
	coords.push([row, col, vertex])
	coords += adjoiningTiles(Tile.new("hex", row, col, 0), vertex)
	valid = []
	for c in coords
		if( validTile?(c[0], c[1], c[2]) )
			puts "Found valid coordinates at " + c.to_s
			valid.push(c)
		end
	end
	puts "For run: " + row.to_s + " " + col.to_s
	puts "Valid is calibrated, contains: " + valid.to_s # Debugging
	topRow = valid[0][0] # Crashes here
	leftCol = valid[0][1]
	vert = valid[0][2]
	for v in valid
		if( v[0] < topRow )
			topRow = v[0]
			leftCol = v[1]
			vert = v[2]
		elsif( v[0] == topRow && v[1] < leftCol )
			leftCol = v[1]
			vert = v[2]
		end
	end
	return [topRow, leftCol, vert]
end

# Checks if a given [row, col, vertex] exists on our board
def validTile?(row, col, vertex)
	if( row.is_a?(Integer) && col.is_a?(Integer) && vertex.is_a?(Integer) )
		if( row >= 0 && row < Boardsize.length )
			if( col >= 0 && col < Boardsize[row] )
				if( vertex >= 0 && vertex < TileVertexes )
					return true
				end
			end
		end
		return false
	else
		raise "Expected [row, col, vertex] as integers"
	end
end

# Returns total number of tiles on the board
def getTotalTiles()
	total = 0
	for x in Boardsize
		total += x
	end
	return total
end
