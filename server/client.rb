=begin
	This file contains the code for handling client network connections.
	For information about each user, try user.rb.
=end

require 'thread'
require 'socket'
require 'set'

require_relative 'user'
require_relative 'log'

# Returns a description of the current game board
# To get a description we try a depth-2 recursive search from the player
# location, adding each adjacent tile to a set
def getDescription(s, username)
	begin
		tiles = Set.new
		(row, col) = Users.position(username)
		tiles.add([row, col])
		for d in (0 .. 5)
			tiles.add(adjoiningTile(row, col, d))
		end
		tmp = tiles.clone() # Make a shallow copy
		tmp.each do |t|
			for d in (0 .. 5)
				tiles.add(adjoiningTile(t[0], t[1], d))
			end
		end
		for t in tiles
			tile = Board.getTile(t[0], t[1])
			s.puts(["Tile", tile.type, t[0], t[1], tile.probability].join(':'))
		end
	rescue => e
		Log.log(Log::Error, "Error getting description: " + e.message)
	end
end

# Interprets logging in or creating a new user
def handleLogin(auth)
	case auth
		# login:username:password
		when /^login:[\w]+:[\w]+$/
			username, password = auth.split(':')[1,2]
			if( Users.validLogin?(username, password) )
				Log.log(Log::Info, "User '" + username + "' logged in")
				return username
			else
				return nil
			end
		# register:username:password
		when /^register:[\w]+:[\w]+$/
			username, password = auth.split(':')[1,2]
			Log.log(Log::Debug, "Registering user: " + username)
			if( Users.userExists?(username) )
				return nil
			else
				if( Users.addUser(User.new(username, password)) )
					Log.log(Log::Info, "Registered user: " + username)
					return username
				else
					return nil
				end
			end
	end
	return nil
end

def handleCommand(s, username, command)
	case command
		# description
		when /^description+$/
			getDescription(s, username)
		when /^move:\d$/
			begin
				result = Orders.move(username, command.split(':')[1].to_i)
				s.puts(result)
			rescue => e
				puts "Exception during movement: " + e.message
				puts "Backtrace: " + e.backtrace.to_s
			end
		else
			s.puts("UNKNOWN COMMAND")
	end
	s.close()
end

#
# handleClient - Parses a single user command, then exits
#
def handleClient(s)
	username = ""
	begin
		Log.log(Log::Info, "New client connected!")
		s.puts("Hello user. Welcome to Lost Worlds.")
		username = nil
		if( (! s.closed?) && command = s.gets )
			command = command.gsub(/[^\w\d :]/, '') # Strip unwanted chars
			username = handleLogin(command)
			if( username == nil )
				Log.log(Log::Debug, "User login failed")
				s.puts("Invalid login.")
				s.close()
				return
			else
				s.puts("Login successful.")
			end
		end
		if( (! s.closed?) && command = s.gets )
			command = command.gsub(/[^\w\d :]/, '') # Strip unwanted chars
			handleCommand(s, username, command)
		end
		unless( s.closed? )
			s.close()
		end
		Log.log(Log::Debug, "Client disconnected")
	rescue
		Log.log(Log::Warning, "Client failure")
		unless( s.closed? )
			s.close()
		end
	end
end

