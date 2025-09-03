# The CLI town input module for Amar Tools
  
def town_input

  prompt = TTY::Prompt.new

	# Get Town name
  town_name = prompt.ask("\nEnter Village/Town/City name:".c(@t))

  # Get Town size
  town_size = prompt.ask("\nEnter number of houses (default=1):".c(@t)).to_i
	town_size = 1 if town_size < 1

  # Get Town variations
  puts "\n0 = Only humans   1 = Few non-humans   2 = Several non-humans   3 = Crazy place".c(@t)
  puts "4 = Only Dwarves  5 = Only Elves       6 = Only Lizardfolk".c(@t)
  town_var = prompt.ask("Enter race variation (default=0):".c(@t)).to_i
	town_var = 0 if town_var < 0 
	town_var = 6 if town_var > 6
  puts

	return town_name, town_size, town_var

end
