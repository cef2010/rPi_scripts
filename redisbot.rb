# https://github.com/redis/redis-rb
require 'redis'
require 'pry'

class RedisBot
  attr_accessor :connection, :stream
  def initialize(url = "redis://127.0.0.1:6379/0")
    @connection = Redis.new(url: url)
    @stream = 'stream'
  end

  def pub(message)
    @connection.publish @stream, message
  end

  def publish
    loop do
      m = gets.chomp
      if m == 'quit'
        pub('Closing...')
        break
      else
        pub(m)
      end
    end
  end

  def subscribe(sub_stream = '*')
    connection.psubscribe sub_stream do |on|
      on.pmessage do |query, channel, msg|
        if msg == 'Closing...'
          break
        else
          puts "#{query}: #{channel} -- #{msg}"
        end
      end
    end
  end
end

# puts 'Run RedisBot.new("redis://127.0.0.1:6379/0") for local channel'
# puts 'Run RedisBot.new("redis://192.168.1.29:6379/0") for Labs5g server connection'
#
# binding.pry
# puts 0
