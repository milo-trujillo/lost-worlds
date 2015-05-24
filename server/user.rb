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

# Checks if a provided username and password are valid
def validLogin?(userlist, username, password)
	for u in userlist
		if( u.username == username )
			return u.validPassword(password)
		end
	end
	return false
end

# Checks if a given user is in a list
def userExists?(userlist, username)
	for u in userlist
		if( u.username == username )
			return true
		end
	end
	return false
end
