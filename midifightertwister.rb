require 'micromidi'
require 'pry'

class MidiFighterTwister
  attr_accessor :input
  def initialize
    @input = UniMIDI::Input.use(:first)
    @stop = [131, 13, 0]
  end

  def output_stream
    data = []
    while data != @stop
      data = @input.gets_data
      puts "[#{data[0]}, #{data[1]}, #{data[2]}]"
    end
  end
end

# mf = MidiFighter.new
#
# mf.output_stream
# puts 'done'
