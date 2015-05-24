#!/usr/bin/env ruby

=begin
This code will be run on every non-master game server node.
It will accept connections only from the server and localhost (for debugging).
It is responsible for maintaining data about its own individual world state,
but not for validating any input.
=end

require 'socket'
require 'thread'
require_relative 'config'
require_relative 'network'
require_relative 'random'
require_relative 'user'
require_relative 'tile'
require_relative 'world'
require_relative 'log'

#
# Global constants
#
ConfirmOrder = "Order received"
DenyOrder = "Order rejected"

#
# Global variables
#
$orders = [] # Stores orders between turn executions
$boardlock = Mutex.new # For freezing all orders while we update board
$turn = 1

def attemptBuild(info)
	# info is in format build:type:row:col:vertex
	log("Received build order")
	userRow = info[2]
	userCol = info[3]
	userVertex = info[4]
	if( validTile?(userRow, userCol, userVertex) )
		$oders.push(info) # TODO: Look into Ruby hash tables and clean up orders
		log("Order accepted")
		return ConfirmOrder
	else
		return (DenyOrder + ": Tile location invalid")
	end
end

def handleConnection(conn)
	command = conn.gets.chomp()
	response = []
	$boardlock.synchronize {
		case command
			when /^description$/
				response = getBoardDescription()
			# build:building_type:row:column:vertex
			when /^build:[\w]+:[\d]+:[\d]+:[\d]+$/
				response.push(attemptBuild(command.split(':')))
			else
				log("Received unknown command from master: " + command)
		end
	}
	for r in response
		conn.puts(r)
	end
	conn.close()
end

def listen()
	server = TCPServer.open(NodeListenPort)
	loop {
		Thread.start(server.accept) do |conn|
			handleConnection(conn)
		end
	}
end

if __FILE__ == $0
	puts "Starting game node..."
	initBoard()
	Thread.start() do listen end
	loop do
		sleep(Turnduration)
		$boardlock.synchronize {
			log("Turn heartbeat: " + $turn.to_s)
			updateBoard($orders)
			$orders = []
			$turn += 1
		}
	end
end
