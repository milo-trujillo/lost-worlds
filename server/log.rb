#!/usr/bin/env ruby

# For now logging consists of dumping to a terminal, but we may later
# want a more detailed log file, or log over the network to a centralized
# location. This makes it easy to transition later.
def log(s)
	puts(s)
end
