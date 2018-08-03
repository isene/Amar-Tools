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
	name_gen = "name_generator/name_generator_main.rb -d"
	10.times do
		print `#{name_gen} #{$Names.values[c]}`.chomp + " "
	  if /human/ =~ $Names.values[c]
			print `#{name_gen} human_last.txt`.chomp
	  elsif /fantasy/ =~ $Names.values[c]
	  else
			print `#{name_gen} #{$Names.values[c]}`.chomp
	  end
	  print "\n"
	end
end
