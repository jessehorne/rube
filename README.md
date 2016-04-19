Rube
====

Rube is a MUD server written in Ruby. The goal was to make it configurable and easy to modify. I focused less on gameplay and more on building a tool to let others build the world they wanted.

This is my first attempt to actually finish and release something like this, and my ignorance is probably going to show in quite a few areas, but seeing a sparse set of commits on my GitHub reminded me of the wasted time of not finishing and releasing my open-source projects.

This is a poor excuse for a MUD, because it's so limited. Currently all a user can do is move around and talk to other players. There isn't even a "say" command, or user accounts. I did what I set out to do however, which was to create a world that would let players explore and communicate with each other. If time and motivation permits, I will study a bit more into how MUDs operate, and extend this server. I will also need to refactor this a bit, and make some actions such as "look" more efficient, and dynamic. The room system could use some work as well.

# Requirements
[Ruby](https://www.ruby-lang.org) (tested with 2.1.5)

# Setup

## Config
Run through "world/config.txt" and change the values where you see fit. They can be accessed in "rube.rb" like "Rube::Config::IP", for example.
The current values are...
* IP
  * IP to bind to
* PORT
  * Port to bind to
* NAME
  * Name of your server
* FLASH
  * Path to .txt which has the message that is sent to the users client once they join
* HELP
  * Path to .txt which has the message that is sent to the users client once they type "help" in game
* GETUSERNAME
  * The message that is sent to the user, requesting their username
* USERNAMELENGTH
  * Minimum username length
* WELCOMEUSERNAME
  * The message that is sent to the user once they type a correct username
* THANKS
  * The message that is sent to the user if they type "quit" in game
* NOROOM
  * The message that is sent to the user if they attempt to go to a room that doesn't exist

## Creating the world
Since Rube is so simple and limited, you only have the option of creating static worlds for now. I hope that this changes in the future.

The world itself is made of a set of rooms. These rooms use a 2D coordinate system similar to what one would use when creating applications using SDL. The player starts at {X: 0, Y: 0}. If the player goes "north", the players coordinates would now be {X:0, Y: -1}. If the player goes "west" from that point, the players coordinates would be {X:-1, Y: -1}.

To create a room at {X:-1, Y: -1}, you would create a file called "-1|-1.txt" in the "world/rooms" directory. If a player attempts to move to a room that doesn't exist, the Rube::Config::NOROOM message will be delivered to their client.

# Run it
```
ruby rube.rb
```
