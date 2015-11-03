#!/usr/bin/env ruby

=begin
	The User class stores authentication data for each account.
	The Users module stores the database of users and provides methods to 
	interact with that database.
=end

require 'base64'
require 'digest'
require 'thread'
require 'zlib'
require 'yaml'

require_relative 'config'

class User
	attr_accessor :row
	attr_accessor :col

	def initialize(username, password)
		@username = Base64.strict_encode64(username)
		@password = Digest::SHA256.hexdigest(password + Users::Salt)
		# For now, player starting location is a random spot on the board
		# In the future we may want a more intelligent start point,
		# or at least make sure not to spawn on top of someone else.
		@row = rand(Configuration::BoardHeight)
		@col = rand(Configuration::BoardWidth)
	end

	def validPassword(password)
		if( @password == Digest::SHA256.hexdigest(password + Users::Salt) )
			return true
		else
			return false
		end
	end

	# We store the username base64 encoded so we can safely use YAML later
	def username()
		return Base64.strict_decode64(@username)
	end
end

module Users
	Salt = "jk}ldh1qVzMT~E.p"
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
	def Users.addUser(user)
		if( user.class != User )
			raise TypeError, "Can only add users to the userlist!"
		end
		$userlock.synchronize {
			# WARNING: Don't check using userExists?, you'll make a deadlock!
			for u in $users
				if( u.username == user.username )
					return false
				end
			end
			begin
				$users.push(user)
			rescue
				Log.log(Log::Error, "Cannot add user to end of list!")
				return false
			end
		}
		return true
	end

	# Note: Accessing member variables of a user is *not* threadsafe, do so at your
	# peril! This was really added so at order evaluation time we can change the
	# user coordinates.
	def Users.getUser(username)
		$userlock.synchronize {
			for u in $users
				if( u.username == username )
					return u
				end
			end
		}
		return nil
	end

	def Users.position(username)
		$userlock.synchronize {
			for u in $users
				if( u.username == username )
					return [u.row, u.col]
				end
			end
			return nil
		}
	end

	def Users.save(filename)
		f = File.open(filename, "w")
		userblob = ""
		$userlock.synchronize {
			userblob = YAML.dump($users)
		}
		f.puts(Zlib::Deflate.deflate(userblob))
		f.close()
		Log.log(Log::Info, "Saved users to file '" + filename + "'")
	end

	def Users.load(filename)
		f = File.open(filename, "r")
		userblob = Zlib::Inflate.inflate(f.read)
		$userlock.synchronize {
			$users.clear()
			$users = YAML.load(userblob)
		}
		f.close()
		Log.log(Log::Info, "Restored users from file '" + filename + "'")
	end
end
