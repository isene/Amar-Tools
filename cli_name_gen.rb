# Random name generator input module for Amar Tools
  
def name_gen

  # Get name type
	puts "\nEnter name type:"
	$Names.each_with_index do |value,index|
		puts index.to_s.rjust(2) + ": " + value[0]
	end
	print "\n> "
	c = gets.chomp.to_i
	c = 0 if c < 0 or c > $Names.length

	puts $Names[c][0] + " names:\n\n"

	# Output 10 names of the selected type
	10.times do 
		puts naming($Names[c][0])
	end

end
