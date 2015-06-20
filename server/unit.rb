#!/usr/bin/env ruby

=begin
Units are very simple, currently only storing their type and the user that owns
them. Later they may be expanded upon.
=end

class Unit
	attr_reader :type
	attr_reader :user
	
	def initialize(t, u)
		@type = t
		@user = u
	end
end
