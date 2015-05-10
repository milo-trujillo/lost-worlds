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
