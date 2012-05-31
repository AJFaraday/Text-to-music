#
# Andrew James Faraday - May 2012
#
# The Character module handles single characters from a string of text and outputs a command which the pure data patch (ruby_interact.pd) responds to.
#
#
# Letters result in a chromatic scale, each letter being 1 semitone higher than the previous one.
# Character.command('a') #=> "letter 60 ;" 
# Character.command('b') => "letter 61 ;"
# 
# Upper case letters are the same notes but one octave higher.
# Character.command('A') => "letter 72 ;"
# 
# Numbers result in a diminished scale on a different synth.
# Character.command('1') #=> "num 53 ;"
# Character.command('2') #=> "num 56 ;"
#
# Punctuation results in a series of percussive and sliding sounds
#
# Character.command('!') #=> "punct 3 ;"
#


module Character

  TRANSPOSE = 10
  NUMBERS = [50, 53, 56, 59, 62, 65, 68, 71, 74, 77]
  PUNCTUATION =         ['.',',',"'",'!','?','(',')','[',']','{','}',  '#','=','_','<','>','"','-','+','/', '\\']
  PUNCTUATION_NUMBERS = [46, 44, 39, 33, 63, 40, 41, 91, 93, 123, 125, 35, 61, 95, 60, 62, 34, 45, 43, 47, 92]

  #
  # handles input of strings and numbers, converts the first character of a string to it's ascii number
  #
  def self.get_number(character)
    if character.is_a?(Integer)
      character
    elsif character.is_a?(String)
      character.bytes.first
    else
      raise WrongInput
    end
  end

  #
  # Converts a character (or rather, the first character of a string) and converts it into commands for the pure data patch.
  # See above for examples
  #
  def self.command(character)
    pre = 'letter'
    number = get_number(character)
    case number
      # Upper case
      when 65..90 
        comm = number + TRANSPOSE
      # Lower case
      when 97..122
        comm = (number-47) + TRANSPOSE
      # space
      when 32
        comm = 0
      when 48..57
        pre = 'num'
        comm = NUMBERS[character.to_i]
    end
    # punctuation
    if PUNCTUATION_NUMBERS.include? number
      pre = 'punct'
      comm = PUNCTUATION.index(character)
    end
    return "#{pre} #{comm} ;"
  end

end
