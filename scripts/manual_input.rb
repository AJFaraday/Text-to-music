#
# Andrew James Faraday - May 2012
#
# This script is to allow direct manual control of the text-to-music algorithm.
# After a simple check of speed (1 divided by numbers 1 to 10 = number of seconds between characters) the user is prompted to provide textual input which is then sonified.
# This is recommended as a first experience of the text-to-music system, so new users can see the correlation between their use of text and the resulting sound.
# press ctrl+c to exit the script
#

require 'lib/pd-connect'

# Set up a port into pd
pd = PureData.new

# Set the playback speed
puts "what speed? (1 to 10)"
onetoten = gets.to_f
unless onetoten >= 1 && onetoten <= 10 
  onetoten = 10.0
  puts "defaulted to 10!"
end
speed = (1 / onetoten)
 
# Repeatedly prompt the user to provide some text to sonify.
loop do
  puts 'Phrase:'
  pd.send_string(gets.chomp, speed)
  puts ''
end
