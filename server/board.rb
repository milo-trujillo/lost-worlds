#!/usr/bin/env ruby

require 'thread'
require 'zlib'
require 'yaml'
# The last two are for saving / restoring from disk.

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
		return Tile.new("empty", 0)
	end

	def Board.save(filename)
		f = File.open(filename, "w")
		boardblob = ""
		$boardLock.synchronize {
			boardblob = YAML.dump($board)
		}
		f.puts(Zlib::Deflate.deflate(boardblob))
		f.close()
		Log.log(Log::Info, "Saved board to file '" + filename + "'")
	end

	def Board.load(filename)
		f = File.open(filename, "r")
		boardblob = Zlib::Inflate.inflate(f.gets)
		$boardLock.synchronize {
			$board.clear()
			$board = YAML.load(boardblob)
		}
		f.close()
		Log.log(Log::Info, "Restored board from file '" + filename + "'")
	end
end
