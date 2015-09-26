#!/usr/bin/env ruby

=begin
	The Orders module contains all of the code for verifying that orders make
	sense, and evaluating those orders at regular intervals.
=end

require 'thread'

require_relative 'board'
require_relative 'user'
require_relative 'tile'

module Orders
	$orders = []
	$orderlock = Mutex.new
	$turnNumber = 0

	# These are the available types of orders
	Move = 1 # [user, row, col]

	def Orders.move(username, location)
		if( location < 0 || location > 5 )
			return "Error: Destination invalid"
		else
		u = Users.getUser(username)
		if( u == nil )
			return "Error: User does not exist"
		end
		(row, col) = adjoiningTile(u.row, u.col)
		if( not Board.locationPassable?(row, col) )
			return "Error: Destination impossible"
		end
		$orderlock.synchronize {
			$orders.push(Move, [username, row, col])
			return "Success: Move command accepted"
		}
	end

	def Orders.evaluate()
		# STOP! Hammer time.
		$orderlock.synchronize {
			while( order = $orders.shift )
				type = order[0]
				args = order[1]
				case type
					when Move
						u = Users.getUser(args[0])
						if( u != nil )
							u.row = args[1]
							u.col = args[2]
						end
					else
						raise "Unknown command entered!"
				end
			end
			Log.log(Log::Debug, "Processing turn " + $turnNumber.to_s)
			# TODO: Maybe make a non-debug announcement when an hour has passed?
			$turnNumber++
		}
	end
	
end
