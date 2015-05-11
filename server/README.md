# Server Code

This is a distributed ruby project. It requires a number of servers (specified in network.rb), although technically it can be run on one machine.

One system acts as the 'game master', and handles all user interaction, facilitating communication between the users and the game servers themselves.

Each game server node simulates a single continent, with resources and factions galore. Eventually it will be possible for events on one continent to impact another, and things will start to get much more exciting.
