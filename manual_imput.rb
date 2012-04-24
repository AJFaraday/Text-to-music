# this should set up a port into pd
require 'socket'
require 'character'
hostname = '127.0.0.1'
port = '3939'
sock = TCPSocket.open hostname, port
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
  Character.send_string(gets.gsub('\n',''), sock, sleep)
end

#loop do
#  puts 'Ready for input:'
#  str = gets.gsub "\n", ""
#  str.each_with_index do |c,i|
#    pdpitch = str[i]
#    case pdpitch
#      # Upper case
#      when 65..90
#     print "#{str[i..i]}"
#     sock.puts "#{pdpitch} ;"
#   # letters, lower case
#   when 97..122 
#     pdpitch = pdpitch - 47
#     print "#{str[i..i]}"
#     sock.puts "#{pdpitch} ;"
#    # punctuation responses
#   when 32
#     print " " unless ['.', '!', '?'].include? str[(i - 1)..(i - 1)]
#     pdpitch = 0
#     sock.puts "#{pdpitch} ;"
#   when 46 
#     puts "." 
#     punctuation_sock.puts "1 ;"
#   when 44 
#     print "," 
#     punctuation_sock.puts "2 ;"
#   when 39
#     print "'"
#     punctuation_sock.puts "2 ;"
#   when 33
#     puts "!" 
#     punctuation_sock.puts "3 ;"
#   when 63
#     puts "?" 
#     punctuation_sock.puts "4 ;"
#   when 40
#     print "(" 
#     punctuation_sock.puts "5 ;"
#   when 41
#     print ")" 
#     punctuation_sock.puts "6 ;"
#   when 91
#     print "[" 
#     punctuation_sock.puts "7 ;"  
#    when 93
#     print "]" 
#     punctuation_sock.puts "8 ;"
#   when 123
#     print "{" 
#     punctuation_sock.puts "9 ;"
#   when 125
#     print "}" 
#     punctuation_sock.puts "10 ;"
#   when 35
#     print "#"
#     punctuation_sock.puts "11 ;"
#   when 61
#     print "="
#     punctuation_sock.puts "12 ;"
#    when 95
#     print "_"
#     punctuation_sock.puts "13 ;"
#   when 60
#     print "<"
#     punctuation_sock.puts "14 ;"
#   when 62
#     print ">"
#     punctuation_sock.puts "15 ;"
#   when 34
#     print '"'
#     punctuation_sock.puts "16 ;"
#   when 45
#     print '-'
#     punctuation_sock.puts "17 ;"
#   when 43 
#     print '+'
#     punctuation_sock.puts "18 ;"
#   when 47
#     print '/'
#     punctuation_sock.puts "19 ;"
#   # Number responses
#   when 48..57
#     print "#{str[i..i]}"
#     numindex = str[i..i].to_f
#     pdpitch = numberarray[numindex]
#     numbsock.puts "#{pdpitch} ;"
#  end
#  $stdout.flush
#  sleep speed
# }
# puts ""
# puts "" unless str[-1] < 65
#end
