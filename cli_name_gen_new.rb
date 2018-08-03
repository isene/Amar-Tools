# Random name generator input module for Amar Tools
  
def name_gen

  # Get name type
	puts "\nEnter name type:"
	$Names.each_with_index do |(key,value),index|
		puts index.to_s.rjust(2) + ": #{key}"
	end
	print "\n> "
	c = gets.chomp.to_i
	c = 0 if c < 0 or c > 10

	puts $Names.keys[c] + " names:"
	# Output 10 names of the selected type
	10.times { puts name($Names.keys[c]) }
end
