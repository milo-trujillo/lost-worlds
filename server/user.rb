#!/usr/bin/env ruby

=begin
	The user class stores authentication data for each account.
=end

require 'base64'
require 'digest'
require 'thread'

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

module Users
	$users = []
	$userlock = Mutex.new

	# Checks if a provided username and password are valid
	def Users.validLogin?(username, password)
		$userlock.synchronize {
			for u in $users
				if( u.username == username )
					return u.validPassword(password)
				end
			end
		}
		return false
	end

	def Users.userExists?(username)
		$userlock.synchronize {
			for u in $users
				if( u.username == username )
					return true
				end
			end
		}
		return false
	end

	# Attempts to add user to userlist, returns true on success
	def Users.addUser(u)
		if( u.class != User )
			raise TypeError, "Can only add users to the userlist!"
		end
		$userlock.synchronize {
			# WARNING: Don't check using userExists?, you'll make a deadlock!
			for u in $users
				if( u.username == username )
					return false
				end
			end
			begin
				$users.push(u)
			rescue
				Log.log(Log::Error, "Cannot add user to end of list!")
				return false
			end
		}
		return true
	end
end
