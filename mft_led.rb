require 'redisbot.rb'
require 'midifightertwister.rb'
require 'pilight.rb'

def color_twist(color)
  @pilight.strip_length.times {|i| @pilight.leds.set_pixel!(i, color)}
end

def publisher
  @pub = RedisBot.new
  @mft = MidiFighterTwister.new
  def @mft.stream_redis
    data = []
    while data != @mft.stop
      data = @mft.input.gets_data
      @pub.pub("#{data[0]}, #{data[1]}, #{data[2]}")
    end
    pub('Closing...')
  end
  @mft.stream_redis
end

def subscriber
  @pilight = PiLight.new(144)
  # @sub = RedisBot.new("redis://192.168.1.29:6379/0")
  @rgb = [0, 0, 0]
  @sub.subscribe
end

def main
  puts "0:  Publisher"
  puts "1: Subscriber"
  puts "-------------"
  selection = gets.chomp

  if selection == '0'
    publisher
  elsif selection == '1'
    subscriber
  end
end
