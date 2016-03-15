require 'pry'
require_relative 'pilight'

def rgb(r, g, b) #returns numberic value of r, g, b input (remove .to_i for hex values)
  [r, g, b].map { |x| 0 <= x && x <= 255 ? x.to_s(16).rjust(2, '0') : x < 0 ? '00' : 'ff' }.join('').to_i(16)
end

# @strip_length = 144
# @leds = Apa102.new(@strip_length)

@pilight = PiLight.new(144)

def rose(target, length) # turns on all leds at solid rose color
  length.times do |x|
    target.set_pixel(x, 'f7cac9'.to_i(16))
  end
  target.show!
end

def set_rgb # implements rgb_arr on strip
  rgb_arr.each_with_index { |x, i| @pilight.leds.set_pixel!(i, x) }
end

def cycle(a) # cycles through array given as a
  loop do
    a.each_with_index { |x, i| @pilight.leds.set_pixel(i, x) }
    @pilight.leds.show!
    a.unshift(a.pop)
  end
end

def stop
  @pilight.c
end

binding.pry
