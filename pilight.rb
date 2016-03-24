require 'apa102_rbpi'
require_relative 'controller.rb'
include Apa102Rbpi

class PiLight #Class controls array of APA102 Leds
  attr_accessor :leds, :strip_length, :array, :stream, :speed, :direction

  def initialize(length)
    @strip_length = length
    @leds = Apa102.new(@strip_length)
    @array = []
    @stream = ''
    @speed = 0
    @direction = false
  end

  def c
    @leds.clear!
    @array = []
    @stream = ''
  end

  def self.rgb_hex(r, g, b) #returns numberic value of r, g, b input (remove .to_i for hex values)
    [r, g, b].map { |x| 0 <= x && x <= 255 ? x.to_s(16).rjust(2, '0') : x < 0 ? '00' : 'ff' }.join('').to_i(16)
  end

  def self.rgb(length) # returns red, green, and blue array for length
    a = []
    (length / 3).times { |x| a << rgb_hex(x + 1, 0, 0) }
    (length / 3).times { |x| a << rgb_hex(0, x + 1, 0) }
    (length / 3).times { |x| a << rgb_hex(0, 0, x + 1) }
    a
  end

  def self.spectrum(length) # returns full spectrum array for length
    a = []
    height = length / 3
    r, g, b = height, 0, 0
    length.times do |i|
      a << rgb_hex(r, g, b)
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

  def self.custom(arr, length) # returns spectrum based on hex colors from array arr, for length
    result = []
    height = length / arr.length
    a = arr.map { |x| x.to_i(16) }
    diff = a[1] - a[0]
    a.each_with_index do |color, i|
      step = diff / height
      c = color
      height.times do |s|
        result << c
        c += step
      end
      diff = color - a[i-1]
    end
    result
  end

  def set_spectrum
    @array = PiLight.spectrum(@strip_length)
  end

  def set_rgb
    @array = PiLight.rgb(@strip_length)
  end

  def set_custom(colors)
    @array = PiLight.custom(colors, @strip_length)
  end

  def cycle(reverse = @direction) # cycles through array given as a
    @array.each_with_index { |x, i| @leds.set_pixel(i, x) }
    @leds.show!
    !reverse ? @array.unshift(@array.pop) : @array.push(@array.shift)
  end

  def keyboard_control
    @stream = Thread.new do
      while line = STDIN.gets
        @command = line.chomp
        break if @command == 'x'
      end
    end
    begin
      loop do
        case @command
        when "h"
          self.cycle
        when "l"
          @direction = !@direction
          @command = "h"
        when "j"
          p @speed += 1
          @command = "h"
        when "k"
          p @speed > 0 ? @speed -= 1 : 0
          @command = "h"
        when "s"
          self.set_spectrum
        when "a"
          self.set_rgb
        when "c"
          self.c
        when "x"
          break
        end
        sleep (@speed * 0.01)
      end
    rescue
      self.c
      p 'error'
    end
    self.c
  end

  def n64_control
    @controller = Controller.new(121, 6, 129, 7, 10)
    @stream = Thread.new do
      while control = @controller.raw_data
        @command = @controller.button if (control[5] != 15) || (control[6] != 0)
        break if @command == 'd-d'
      end
    end
    begin
      loop do
        case @command
        when "start"
          self.cycle
        when "z"
          @direction = !@direction
          @command = "start"
        when "l"
          p @speed += 1
          @command = "start"
        when "r"
          p @speed > 0 ? @speed -= 1 : 0
          @command = "start"
        when "a"
          self.set_spectrum
          @command = nil
        when "b"
          self.set_rgb
          @command = nil
        when "d-u"
          self.c
          @command = nil
        when "d-d"
          break
        end
        sleep (@speed * 0.01)
      end
    rescue
      self.c
      p 'error'
    end
    self.c
    @controller.close
  end
end
