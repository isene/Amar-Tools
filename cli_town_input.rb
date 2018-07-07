# The town input module for CLI NPCg
  
def town_input

  # Get Town size
	town_size = 10

  	puts "\nEnter number of houses:"
    print "> "
	town_size = gets.chomp.to_i

  # Get Town variations
	town_var = 0
  	puts "\nEnter race variation: 0 = Only humans   1 = Few non-humans   2 = Several non-humans   3 = Crazy place"
    print "> "
	town_var = gets.chomp.to_i
	town_var = 0 if town_var < 0 
	town_var = 3 if town_var > 3

	return town_size, town_var

end
