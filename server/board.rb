#!/usr/bin/env ruby

require 'thread'
require 'zlib'

require_relative 'config'
require_relative 'tile'
require_relative 'random'
require_relative 'log'

=begin
	This module manages the game board, creating it, saving it to disk,
	restoring it, etc.
=end

module Board
	$board = []
	$boardLock = Mutex.new

=begin
	Right now our worldgen just throws random tiles into a grid of the right size.
	Eventually we'll want something more complex to make contiguous forests, 
	continents, etc.
=end
	def Board.generate
		$boardLock.synchronize {
			$board.clear()
			for row in (0 .. Configuration::BoardHeight)
				$board.push([])
				for col in (0 .. Configuration::BoardWidth)
					type = getRandomElement(Configuration::Tiletypes)
					$board[row].push(Tile.new(type, getDiceRoll()))
				end
				if( Configuration::DebugMode )
					tiles = ((row + 1) * Configuration::BoardWidth).to_s
					Log.log(Log::Debug, "Created " + tiles + " tiles")
				end
			end
			Log.log(Log::Info, "World generation complete.")
		}
	end

	# Returns a tile if it's on the board, otherwise returns an empty tile
	def Board.getTile(row, col)
		if( row > 0 && row < Configuration::BoardHeight )
			if( col > 0 && col < Configuration::BoardWidth )
				$boardLock.synchronize {
					return $board[row][col];
				}
			end
		end
		return Tile.new("water", 0)
	end

	def Board.save(filename)
		f = File.open(filename, "w")
		boardblob = ""
		$boardLock.synchronize {
			boardblob = Marshal.dump($board)
		}
		f.puts(Zlib::Deflate.deflate(boardblob))
		f.close()
		Log.log(Log::Info, "Saved board to file '" + filename + "'")
	end

	def Board.load(filename)
		f = File.open(filename, "r")
		boardblob = Zlib::Inflate.inflate(f.read)
		$boardLock.synchronize {
			$board.clear()
			$board = Marshal.load(boardblob)
		}
		f.close()
		Log.log(Log::Info, "Restored board from file '" + filename + "'")
	end

	# Returns if a location is on the board and can be moved to
	def Board.locationMoveable?(row, col)
		if( row < 0 || row >= Configuration::BoardHeight )
			return false
		end
		if( col < 0 || col >= Configuration::BoardWidth )
			return false
		end
		return true
	end

	def Board.getTotalTiles()
		return Configuration::BoardHeight * Configuration::BoardWidth
	end
end

# This centers the coordinates of a tile around the location of the user,
# such that the player is at 2,2, and rows and columns start at 0
def centerCoordinates(row, col, userRow, userCol)
	originRow = userRow - 2
	originCol = userCol - 2
	# Originrow and col will be '0,0' for our centered player map
	return [row-originRow, col-originCol]
end
