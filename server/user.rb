#!/usr/bin/env ruby

=begin
	The user class stores authentication data for each account.
=end

require 'base64'
require 'digest'

PasswordSalt = "jk}ldh1qVzMT~E.p"

class User

	def initialize(username, password)
		@username = Base64.strict_encode64(username)
		@password = Digest::SHA256.hexdigest(password + PasswordSalt)
	end

	def validPassword(password)
		if( @password == Digest::SHA256.hexdigest(password + PasswordSalt) )
			return true
		else
			return false
		end
	end

	# We store the username base64 encoded so we can safely use YAML later
	def username
		return Base64.strict_decode64(@username)
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
