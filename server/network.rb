#!/usr/bin/env ruby

=begin
This file at the moment only stores constants about the game's network
configuration. In the future we may want to add more functionality here,
or move it to some sort of generic "config" file.
=end

require 'socket'

Networkbase = "192.168.0."
Masternode = "201"
Gamenodes = ["202", "203", "204", "205", "206", "207"]

MasterListenPort = 2345 # This is the port users will connect to
NodeListenPort = 1111 # This is a port used for internal node communication

# Returns an open socket to the master game node
# I'm not sure if we'll ever need this ability
def contactMaster()
	return TCPSocket.open(Networkbase + Masternode, MasterListenPort)
end

# Returns a socket to the desired game node
def contactNode(nodenum)
	return TCPSocket.open(Networkbase + Gamenodes[nodenum], NodeListenPort)
end
