# Random name generator input module for Amar Tools
  
def name_gen

  prompt = TTY::Prompt.new

  # Get name type
  $Names.each_with_index do |value,index|
    puts index.to_s.rjust(2).c(@N) + ": ".c(@N) + value[0].c(@N)
  end
  c = prompt.ask("\nEnter name type:".c(@N)).to_i
  c = 0 if c < 0 or c > $Names.length

  puts $Names[c][0].c(@N) + " names:\n".c(@N)

  # Output 10 names of the selected type
  10.times do 
    puts naming($Names[c][0]).c(@N)
  end

end
