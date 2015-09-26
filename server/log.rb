#!/usr/bin/env ruby

=begin
	This file defines how messages should be logged. At present it's just a
	wrapper around 'puts', but later *might* use files if our project ever
	gets that pro.
=end

require 'thread'

require_relative 'config'

module Log
	$logLock = Mutex.new

	# Define some constants for log messages
	# All messages must come with a log level to be printed
	Debug   = 1
	Info    = 2
	Warning = 3
	Error   = 4

	def Log.log(level, msg)
		case level
			when Debug
				if( Configuration::DebugMode == true )
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
end	
