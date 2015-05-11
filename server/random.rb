#!/usr/bin/env ruby

=begin
This file provides random utilities for the master and game nodes.
=end

# Simulates a double dice roll
def getDiceRoll()
	die1 = rand(6) + 1
	die2 = rand(6) + 1
	return die1 + die2
end

# Removes a ranom element from a list and returns the element
def extractRandomElement(list)
	index = rand(list.length)
	item = list[index]
	list.delete_at(index)
	return item
end

def getRandomElement(list)
	return list[rand(list.length)]
end
