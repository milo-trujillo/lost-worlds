#!/usr/bin/env ruby

=begin
	This file defines how messages should be logged.
=end

require 'thread'

module Log
	$logLock = Mutex.new
	$debugMode = true

	Debug   = 1
	Info    = 2
	Warning = 3
	Error   = 4

	def Log.log(level, msg)
		case level
			when Debug
				if( $debugMode == true )
					$logLock.synchronize {
						puts "Debug: " + msg.to_s
					}
				end
			when Info
				$logLock.synchronize {
					puts "Info: " + msg.to_s
				}
			when Warning
				$logLock.synchronize {
					puts "WARNING: " + msg.to_s
				}
			when Error
				$logLock.synchronize {
					puts "ERROR: " + msg.to_s
				}
			else
				$logLock.synchronize {
					Log.log(Warning, "Log message has improper log level")
				}
		end
	end

	# If we want to set debug mode based on a command line argument...
	def Log.setDebugMode(bool)
		# Only want to set valid booleans
		if( bool == true )
			$debugMode = true
		elsif( bool == false )
			$debugMode = false
		end
	end
end
