#
# Andrew James Faraday - April 2013
#
# This script is an attempt to progressively vary and change a string over
# time allowing the user to hear a provess of string transforms taking
# place with the text-to-music algorithm.
#
# It's a string slicer, which will take an opening string and a number,
# then divide the string into groups of that number and increase the
# last character of the string.
#
# Every 8 instances the slicing factor will increase
#

# A string transform method
class String
  # Increases one character in the middle of a string
  def slice_and_increase(groups_of)
    self.scan(/.{1,#{groups_of}}/).collect{|x|x.succ}.join
  end
end

# creates a string of a given length with hashes at given intervals
def demo_string(length,interval)
  result = ''
  until result.length >= length
    (interval - 1).times{result << ' '}
    result << '#'
  end
  result[0...length]
end



# Add TTM library
require './lib/pd-connect'

# Set up port into pure data
pd = PureData.new

# Acquire a string from the user
puts 'Phrase:'
string = gets
string = string.chomp

puts "Choose a number:"
number = gets.to_i


puts demo_string(string.length, number)
i = 1
loop do
  # Send the string to PD
  pd.send_string(string, 0.1)
  puts ''
  # Every 8 instances increase the slicing factor
  if i % 8 == 0
    number = number+1
    puts "Slice increased to #{number}"
    puts demo_string(string.length, number)
  end
  if number > string.length
    puts "Slices are bigger than your string."
    puts "Let's just say it came to a natural ending."
    break
  end
  # every time. perform the transform
  string = string.slice_and_increase(number)
  i += 1
end

