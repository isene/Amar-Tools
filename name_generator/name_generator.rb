class NameGenerator
  def initialize(follower_letters, min_length = 3, max_length = 9)
    @min_word_length = min_length
    @max_word_length = max_length
    @follower_letters = follower_letters
  end

  def generate_name(word)
    last_pair = word[-2, 2]
    letter = @follower_letters[last_pair].slice(rand(@follower_letters[last_pair].length), 1)
    if word =~ /\s$/
      return word[0, @max_word_length] unless word.length <= @min_word_length
      return generate_name(word[-1, 1]+letter)
    else
      word = word.gsub(/^\s/, '')
      return generate_name(word+letter)
    end
  end

  def generate_names(start_pairs, count = 10)
    names = []
    count.times do |i|
		names.push(generate_name(start_pairs[rand start_pairs.length]).capitalize.rstrip)
    end
    return names
  end
end
