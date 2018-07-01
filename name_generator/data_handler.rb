class DataHandler
  attr_reader :follower_letters, :start_pairs
  def initialize
    @start_pairs = []
    @follower_letters = Hash.new('')
  end

  def read_data_file(data_file)
	begin
      File.open(data_file, 'r') do |file|
        chars = file.read.chomp.downcase.gsub(/\s/, ' ').chars.to_a
        chars.push(chars[0], chars[1])
        populate_followers_and_start_pairs(chars)
	  end
	rescue
	  puts "No such data file"
    end
  end

  def populate_followers_and_start_pairs(chars)
    (chars.length-2).times do |i|
      if chars[i] =~ /\s/
        @start_pairs.push(chars[i+1, 2].join)
      end
      @follower_letters[chars[i, 2].join]=@follower_letters[chars[i,2].join]+chars[i+2,1].join
    end
  end

  private :populate_followers_and_start_pairs
end
