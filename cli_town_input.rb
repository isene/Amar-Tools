# The CLI town input module for Amar Tools
  
def town_input

	# Get Town name
	town_name = ""
 	puts "\nEnter Village/Town/City name:"
	print "> "
	town_name = gets.chomp.to_s

  # Get Town size
 	puts "\nEnter number of houses (default=1):"
  print "> "
	town_size = gets.chomp.to_i
	town_size = 1 if town_size < 1

  # Get Town variations
  	puts "\nEnter race variation (default=0):\n"
		puts "0 = Only humans   1 = Few non-humans   2 = Several non-humans   3 = Crazy place"
  	puts "4 = Only Dwarves  5 = Only Elves       6 = Only Lizardfolk"
    print "> "
	town_var = gets.chomp.to_i
	town_var = 0 if town_var < 0 
	town_var = 6 if town_var > 6

	return town_name, town_size, town_var

end
