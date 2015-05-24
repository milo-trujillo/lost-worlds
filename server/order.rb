#!/usr/bin/env ruby

=begin
This file describes what an "order" looks like, and provides some utlity
code to make creating and parsing them a little easier.
=end

require_relative 'config'
require_relative 'tile'

# This is every valid type of order. An exception will be raised if you try
# to make an order not in this list.
OrderTypes = ["build", "move"]

# TODO: Expand Order to also track the user making the order and the type of
# building being made
def Order

	attr_reader :type	
	attr_reader :position
	attr_reader :user
	attr_reader :subtype

	def initialize(type, position)
		if( ! type.is_a?(String) )
			raise "Type must be a valid order type!"
		elsif( ! position.is_a?(Array) )
			raise "Must provide either [row, col, vertex] or [coord1, coord2]"
		end
		for t in OrderTypes
			if t == type
				@type = type
			end
			# Depending on the type of order we have either one or two
			# associated coordinates. We also want to normalize those points
			# so if two orders are given to overlapping vertices it's easy
			# to see the conflict.
			if( position.length == 3 )
				# TODO: See if there's a way we can make ruby expand the array
				# into arguments
				@position = standardizeCoordinate(position[0], position[1],
					position[2])
			elsif( position.length == 2 )
				start = standardizeCoordinate(position[0][0], position[0][1],
					position[0][2])
				finish = standardizeCoordinate(position[1][0], position[1][1],
					position[1][2])
				@position = [start, finish]
			end
		end
		if( @type != type )
			raise "Unexpected order type!"
		end
	end

end
