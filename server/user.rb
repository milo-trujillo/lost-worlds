#!/usr/bin/env ruby

=begin
On game nodes this class is used to associate buildings or units with a
particular username. On the master node it is also used for authentication.
=end

require 'digest'

class User

	attr_reader :username

	def initialize(username, password)
		@username = username
		@password = Digest::SHA256.hexdigest(password)
	end

	def validPassword(password)
		if( @password == Digest::SHA256.hexdigest(password) )
			return true
		else
			return false
		end
	end

end
