# The town input module for CLI NPCg
  
def enc_input

  # Get Town size
	town_size = 1

  	puts "\nEnter number of houses:"
    print "> "
	town_size = gets.chomp.to_i

  # Get Town variations
	town_var = 0
  	puts "\nEnter % variation in spieces (0 = only human, 100 = wide variety:"
    print "> "
	town_var = gets.chomp.to_i
	town_var = 100 if enc_var > 100

	return town_size, town_var

end
