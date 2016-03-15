require 'apa102_rbpi'
require 'pry'
include Apa102Rbpi

def rgb(r, g, b)
  [r, g, b].map { |x| 0 <= x && x <= 255 ? x.to_s(16).rjust(2, '0') : x < 0 ? '00' : 'ff' }.join('').to_i(16)
end

@strip_length = 144

@leds = Apa102.new(@strip_length)

@colors = []

def rgb_arr
  a = []
  (@strip_length / 3).times { |x| a << rgb(x + 1, 0, 0) }
  (@strip_length / 3).times { |x| a << rgb(0, x + 1, 0) }
  (@strip_length / 3).times { |x| a << rgb(0, 0, x + 1) }
  a
end

def rose(target, length)
  length.times do |x|
    target.set_pixel(x, 'f7cac9'.to_i(16))
  end
  target.show!
end

def set_rgb
  rgb_arr.each_with_index { |x, i| @leds.set_pixel!(i, x) }
end

def cycle_rgb(a)
  loop do
    a.each_with_index { |x, i| @leds.set_pixel(i, x) }
    @leds.show!
    a.unshift(a.pop)
  end
end

def spectrum(length)
  a = []
  height = length / 3
  r, g, b = height, 0, 0
  length.times do |i|
    a << rgb(r, g, b)
    if i < height
      r -= 1
      g += 1
    elsif i > height && i < height * 2
      g -= 1
      b += 1
    else
      b -= 1
      r += 1
    end
  end
  a  
end

def custom(arr, length)
  result = []
  height = length / arr.length
  a = arr.map { |x| x.to_i(16) }
  diff = a[1] - a[0]
  step = diff / height
  a.each_with_index do |color, i|
    c = color
    height.times do |s|
      result << c
      c -= step
    end
    diff = color - a[i-1]
  end
  result
end


binding.pry


