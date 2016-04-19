require "socket"

require "./engine/user.rb"

require "./world/config.rb"

module Rube
  class Server
    def initialize
      @server = TCPServer.open(Rube::Config::IP, Rube::Config::PORT)
      @count = 0
      @clients = []
    end

    def start
      puts "Starting '#{Rube::Config::NAME}' on port '#{Rube::Config::PORT}'"
      loop {
        Thread.start(@server.accept) do |client|
          puts "Someone connected..."
          client.write(File.read(Rube::Config::FLASH))

          username = ""

          while username.length < Rube::Config::USERNAMELENGTH
            client.write(Rube::Config::GETUSERNAME)
            username = client.gets
            username = username.gsub("\r", "")
            username = username.gsub("\n", "")
          end

          user = User.new
          user.name = username
          user.x = 0
          user.y = 0
          user.client = client
          @clients.push(user)

          @count += 1

          client.puts Rube::Config::WELCOMEUSERNAME.sub("{USERNAME}", username)
          client.puts("There are currently [#{@count}] player(s)!\r\n")

          while true
            msg = client.gets.gsub("\r", "").gsub("\n", "")
            cmd = msg.split(" ")

            if cmd[0] == "help"
              client.puts(File.read(Rube::Config::HELP))
            elsif cmd[0] == "quit"
              @count -= 1
              client.puts(Rube::Config::THANKS)
              client.close
              Thread.kill self
            elsif cmd[0] == "look" or cmd[0] == "l"
              # client.puts("X:#{user.x}, Y:#{user.y}\r\n")
              path = "world/rooms/#{user.x}|#{user.y}.txt"
              if File.exists?(path)
                client.puts(File.read(path))
              else
                client.puts(Rube::Config::NOROOM)
              end

              other_users = []
              names = ""

              @clients.each_with_index { |u, i|
                if user.x == u.x && user.y == u.y
                  if u.name != user.name
                    other_users.push(u)

                    if i == 0 || names == ""
                      names += u.name
                    else
                      names += ", " + u.name
                    end
                  end
                end
              }

              if other_users.length == 1
                client.puts("You see #{other_users.length} other person; " + names)
              else
                client.puts("You see #{other_users.length} other people; " + names)
              end
            elsif cmd[0] == "global"
              chatmsg = cmd[1...cmd.length].join(" ")
              @clients.each { |c|
                c.client.puts("#{user.name} yelled '#{chatmsg}'\r\n")
              }
            elsif cmd[0] == "north" || cmd[0] == "n"
              path = "world/rooms/#{user.x}|#{user.y-1}.txt"
              if File.exists?(path)
                client.puts(File.read(path))
                user.y -=1
              else
                client.puts(Rube::Config::NOROOM)
              end
            elsif cmd[0] == "south" || cmd[0] == "s"
              path = "world/rooms/#{user.x}|#{user.y+1}.txt"
              if File.exists?(path)
                client.puts(File.read(path))
                user.y += 1
              else
                client.puts(Rube::Config::NOROOM)
              end
            elsif cmd[0] == "east" || cmd[0] == "e"
              path = "world/rooms/#{user.x+1}|#{user.y}.txt"
              if File.exists?(path)
                client.puts(File.read(path))
                user.x += 1
              else
                client.puts(Rube::Config::NOROOM)
              end
            elsif cmd[0] == "west" || cmd[0] == "w"
              path = "world/rooms/#{user.x-1}|#{user.y-1}.txt"
              if File.exists?(path)
                client.puts(File.read(path))
                user.x -= 1
              else
                client.puts(Rube::Config::NOROOM)
              end
            else
              client.puts("That command isn't implemented yet!\r\n")
            end
          end
        end
      }
    end
  end
end

server = Rube::Server.new
server.start
