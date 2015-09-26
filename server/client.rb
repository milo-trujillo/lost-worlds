=begin
	This file contains the code for handling client network connections.
	For information about each user, try user.rb.
=end

require 'thread'
require 'socket'

require_relative 'user'
require_relative 'log'

# Returns a description of the current game board
def getDescription(s)
	begin
	rescue
		Log.log(Log::Error, "Error getting description")
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
			getDescription(s)
		when /^move:\d$/
			result = Orders.move(username, command.split(':')[1])
			s.puts(result)
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

