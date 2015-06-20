#!/usr/bin/env ruby

=begin
Buildings are just named tuples of a type and owner.
=end

class Building
	attr_reader :type
	attr_reader :user
	
	def initialize(t, u)
		@type = t
		@user = u
	end
end
