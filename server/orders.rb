#!/usr/bin/env ruby

=begin
	The Orders module contains all of the code for verifying that orders make
	sense, and evaluating those orders at regular intervals.
=end

require 'thread'
require 'zlib'
require 'yaml'

require_relative 'board'
require_relative 'user'
require_relative 'tile'
require_relative 'log'

module Orders
	$orders = []
	$orderlock = Mutex.new
	$turnNumber = 0

	# These are the available types of orders
	Move = 1 # [user, row, col]

	def Orders.move(username, location)
		if( location < 0 || location > 5 )
			return "Error: Destination invalid"
		end
		u = Users.getUser(username)
		if( u == nil )
			return "Error: User does not exist"
		end
		(row, col) = adjoiningTile(u.row, u.col, location)
		if( not Board.locationMoveable?(row, col) )
			return "Error: Destination impossible"
		end
		Log.log(Log::Debug, "Attempting move from #{u.row},#{u.col} to #{row},#{col}")
		$orderlock.synchronize {
			$orders.push([Move, [username, row, col]])
			return "Success: Move command accepted"
		}
	end

	def Orders.evaluate
		# STOP! Hammer time.
		$orderlock.synchronize do
			while( true )
				order = $orders.shift
				if( order == nil )
					break
				end
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
			$turnNumber += 1
		end
	end

	def Orders.save(filename)
		f = File.open(filename, "w")
		orderblob = ""
		$orderlock.synchronize {
			orderblob = YAML.dump([$orders, $turnNumber])
		}
		f.puts(Zlib::Deflate.deflate(orderblob))
		f.close()
		Log.log(Log::Info, "Saved orders to file '" + filename + "'")
	end

	def Orders.load(filename)
		f = File.open(filename, "r")
		orderblob = Zlib::Inflate.inflate(f.read)
		$orderlock.synchronize {
			$orders.clear()
			($orders, $turnNumber) = YAML.load(orderblob)
		}
		f.close()
		Log.log(Log::Info, "Restored orders from file '" + filename + "'")
	end
end
