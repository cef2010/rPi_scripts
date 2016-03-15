loop do
  begin
    system("stty raw -echo")
    str = STDIN.getc
  ensure
    system("stty -raw echo")
  end
  p str.chr
  break if str.chr == "d"
end
