class PiLight
  attr_accessor :leds, :strip_length

  def initialize(length)
    @strip_length = length
    @leds = Apa102.new(@strip_length)
    @array = []
  end

  def c
    @leds.clear!
    @array = []
  end

  def self.rgb(length) # returns red, green, and blue array for length
    a = []
    (length / 3).times { |x| a << rgb(x + 1, 0, 0) }
    (length / 3).times { |x| a << rgb(0, x + 1, 0) }
    (length / 3).times { |x| a << rgb(0, 0, x + 1) }
    a
  end

  def self.spectrum(length) # returns full spectrum array for length
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

  def self.custom(arr, length) # returns spectrum based on hex colors from array arr, for length
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

  def set_spectrum
    @array = PiLight.spectrum(@strip_length)
    self.cycle
  end

  def set_rgb
    @array = PiLight.rgb(@strip_length)
    self.cycle
  end

  def set_custom(colors)
    @array = PiLight.custom(colors, @strip_length)
    self.cycle
  end

  def cycle(a = @array) # cycles through array given as a
    loop do
      a.each_with_index { |x, i| @leds.set_pixel(i, x) }
      @leds.show!
      a.unshift(a.pop)
    end
  end

end
