#
# Andrew James Faraday - May 2012
#
# This script is to allow direct manual control of the text-to-music algorithm.
# After a simple check of speed (1 divided by numbers 1 to 10 = number of seconds between characters) the user is prompted to provide textual input which is then sonified.
# This is recommended as a first experience of the text-to-music system, so new users can see the correlation between their use of text and the resulting sound.
# press ctrl+c to exit the script
#

#
# Update, 11 Jun 2012
#
# The script, with a surprisingly simple set of changes, can now be fed a file, which it reads. This opens the rather mind-blowing possibility of running this line:
#
# ruby scripts/manual-input.rb scripts/manual-input.rb
#
# The above command will use this file to read and sonify this file including this comment about reading and sonifying this file.
#

require './lib/pd-connect'

# If the first argument is a valid file, place a flag to skip prompts
begin
  file = File.new(ARGV[0])
  puts "Reading file: #{file.path}"
rescue
  # a convenience rescue to keep the process silent when a file is not present.
end

# Set up a port into pd
pd = PureData.new

if file and file.is_a? File
  # Automatically set the playback speed
  speed = 0.15
  show_prompt = false
else
  # Manually set the playback speed
  puts "what speed? (1 to 10)"
  onetoten = gets.to_f 
  unless onetoten && onetoten >= 1 && onetoten <= 10 
    onetoten = 10.0 
    puts "defaulted to 10!"
  end
  speed = (1 / onetoten)
  show_prompt = true
end

# Repeatedly prompt the user to provide some text to sonify.
phrase = ''
until phrase.nil? do
  puts 'Phrase:' if show_prompt
  phrase = nil
  phrase = gets
  pd.send_string(phrase.chomp, speed) if phrase
  puts '' 
end
