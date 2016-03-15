Thread.new do
  while line = STDIN.gets
    @thing = line.chomp
    break if @thing == 'x'
  end
  exit
end

@thing = 'hello'

loop do
  p @thing
  sleep 0.5
  # begin
  #   system("stty raw -echo")
  #   str = STDIN.getc
  # ensure
  #   system("stty -raw echo")
  # end
  # # logic here
  # case str.chr
  #   when "h"
  #     p "self.cycle"
  #   when "l"
  #     p "self.cycle(true)"
  #   when "j"
  #     p "#faster"
  #   when "k"
  #     p "#slower"
  #   when "s"
  #     p "self.set_spectrum"
  #   when "a"
  #     p "self.set_rgb"
  #   when "c"
  #     p "self.c"
  #   end
  # break if str.chr == "d"
end
