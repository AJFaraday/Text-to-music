class Character

  attr_accessor :ascii

  TRANSPOSE = 10
  NUMBERS = [50, 53, 56, 59, 62, 65, 68, 71, 74, 77]
  PUNCTUATION =         ['.',',',"'",'!','?','(',')','[',']','{','}',  '#','=','_','<','>','"','-','+','/', '\\']
  PUNCTUATION_NUMBERS = [46, 44, 39, 33, 63, 40, 41, 91, 93, 123, 125, 35, 61, 95, 60, 62, 34, 45, 43, 47, 92]

  def initialize(input)
    if input.is_a?(Integer)
      self.ascii = number
    elsif input.is_a?(String)
      #self.ascii = input[0]
      self.ascii = input.bytes.first
    else
      raise WrongInput
    end
  end

  def command
    pre = 'letter'
    case ascii
      # Upper case
      when 65..90 
        comm = ascii + TRANSPOSE
      # Lower case
      when 97..122
        comm = (ascii-47) + TRANSPOSE
      # space
      when 32
        comm = 0
      when 48..57
        pre = 'num'
        comm = NUMBERS[ascii.chr.to_i]
    end
    # punctuation
    if PUNCTUATION_NUMBERS.include? ascii
      pre = 'punct'
      comm = PUNCTUATION.index(ascii.chr)
    end
    return "#{pre} #{comm} ;"
  end


end
