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
	$userlock.synchronize {
		case auth
			# login:username:password
			when /^login:[\w]+:[\w]+$/
				username, password = auth.split(':')[1,2]
				if( validLogin?($users, username, password) )
					Log.log(Log::Info, "User " + username + " logged in")
					return username
				else
					return nil
				end
			# register:username:password
			when /^register:[\w]+:[\w]+$/
				username, password = auth.split(':')[1,2]
				Log.log(Log::Debug, "Registering user: " + username)
				if( userExists?($users, username) )
					return nil
				else
					$users.push(User.new(username, password))
					Log.log(Log::Info, "Registered user: " + username)
					return username
				end
		end
		return nil
	}
end

def handleCommand(s, command)
	case command
		# description
		when /^description+$/
			getDescription(s)
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
		loggedIn = false # We'll handle some kind of account system later
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
			handleCommand(s, command)
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

