# Thread.new do
#   while line = STDIN.gets
#     @thing = line.chomp
#     break if @thing == 'x'
#   end
#   exit
# end

def say
  loop do
    p @thing
  end
end

def quit?
  begin
    while c = STDIN.read_nonblock(1)
      @thing = c
      return true
    end
    false
  rescue Errno::EINTR
    false
  rescue Errno::EAGAIN
    false
  rescue EOFError
    true
  end
end

@thing = 'test'

# Thread.new do
#   loop do
#     begin
#       system("stty raw -echo")
#       @thing = STDIN.getc
#     ensure
#       system("stty -raw echo")
#     end
#   end
# end

def looping
  loop do
    quit?
    case @thing
    when 't'
      p 'non-looping case'
    when 'r'
      p 'another non-loop'
    when 'l'
      say
    when 'x'
      exit
    end
    sleep 1
  end
end

looping
