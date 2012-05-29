require 'pd-connect'

# this should set up a port into pd
sock = PureData.connection

if sock
  # Sets the playback speed
  puts "what speed? (1 to 10)"
  onetoten = gets.to_f
  unless onetoten >= 1 && onetoten <= 10 
    onetoten = 10.0
    puts "defaulted to 10!"
  end
  speed = (1 / onetoten)
  
  loop do
    puts 'Phrase:'
    Character.send_string(gets.gsub('\n',''), sock, speed)
  end

else
  puts "Quit because I couldn't get a connection to PureData"
end
