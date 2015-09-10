#!/usr/bin/env ruby

=begin
	This file provides RNG utilities for world generation and resource 
	generation. It should *not* be considered cryptographically secure.
=end

# Useful exported constants
Dieminroll = 1
Diemaxroll = 6
Midroll = 7
Minroll = 2*Dieminroll
Maxroll = 2*Diemaxroll

# Simulates a double dice roll
def getDiceRoll()
	die1 = rand(Diemaxroll - (Dieminroll - 1)) + Dieminroll
	die2 = rand(Diemaxroll - (Dieminroll - 1)) + Dieminroll
	return die1 + die2
end

# Removes a ranom element from a list and returns the element
def extractRandomElement(list)
	index = rand(list.length)
	item = list[index]
	list.delete_at(index)
	return item
end

# Returns a single random element without removing it from the list
def getRandomElement(list)
	return list[rand(list.length)]
end
