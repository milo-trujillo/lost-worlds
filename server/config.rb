#!/usr/bin/env ruby

=begin
This file holds global configuration options for the game, both in terms of
gameplay and technical configuration.
=end

require_relative 'log'

module Configuration
	#
	# Gameplay section
	#

	# This describes the number of rows, and the number of columns on each row
	# The board is hexagonal, which makes describing it with arrays challenging
	BoardWidth = 200
	BoardHeight = 200
	Tiletypes = ["coal", "iron", "shrooms"] 
	# There is also an 'empty' type, not included so it isn't used during generation
	Turnduration = 60 # Seconds between turn executions

	#
	# Architecture configuration
	#
	Thread.abort_on_exception = true
	DebugMode = true

	#
	# Network configuration
	#
	ListenPort = 2345

	#
	# Paths 
	#
	StateDir = "./state"
	UserPath = StateDir + "/users.db"
	BoardPath = StateDir + "/board.db"
	StateFiles = [UserPath, BoardPath]

	# Creates state directory if needed
	def Configuration.prepareState
		unless( File.directory?(StateDir) )
			begin
				Dir.mkdir(StateDir)
			rescue
				Log.log(Log::Error, "Unable to create state directory!")
				return false
			end
		end
		return true
	end

	def Configuration.clearState
		for f in StateFiles
			if( File.exists?(f) )
				begin
					File.delete(f)
				rescue
					Log.log(Log::Warning, "Unable to delete file '" + f + "'!")
			end
		end
	end

	# Returns true if all state files exist
	def Configuration.stateExists?()
		for f in StateFiles
			unless( File.exists?(f) )
				return false
			end
		end
		return true
	end
end
