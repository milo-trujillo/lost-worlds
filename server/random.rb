#!/usr/bin/env ruby

=begin
This file provides random utilities for the master and game nodes.
=end

# Useful exported constants
Dieminroll = 1
Diemaxroll = 6
Minroll = 2*Dieminroll
Maxroll = 2*Diemaxroll

# Simulates a double dice roll
def getDiceRoll()
	die1 = rand(Diemaxroll) + Dieminroll
	die2 = rand(Diemaxroll) + Dieminroll
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
