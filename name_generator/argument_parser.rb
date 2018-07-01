require 'getoptlong'

class ArgumentParser
  attr_reader :data_file, :words_to_generate
  
  def initialize
    @opts = GetoptLong.new(
      ["--datafile", "-d", GetoptLong::OPTIONAL_ARGUMENT],
      ["--number-of-words", "-n", GetoptLong::OPTIONAL_ARGUMENT]
    )
    @data_file = "data.txt"
    @words_to_generate = 1
  end

  def parse_arguments
    @opts.each do |opt, arg|
      case opt
      when '--datafile'
        @data_file = arg
      when '--number-of-words'
		  @words_to_generate = arg.to_i
      end
    end
  end

end
