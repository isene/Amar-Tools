# Random name generator input module for CLI NPCg
  
def name_gen

	n = ["Human male", "Human female", "Dwarven male", "Dwarven female", "Elven male", "Elven female", "Lizardfolk", "Troll", "Araxi"]
	f = ["human_male_first.txt", "human_female_first.txt", "dwarven_male.txt", "dwarven_female.txt", "elven_male.txt", "elven_female.txt", "lizardfolk.txt", "troll.txt", "araxi.txt"]

  # Get name type
	puts "\nEnter name type:"
	n.each_with_index do |value,index|
		print "#{index}: #{value}   "
	end
	print "\n> "
	c = gets.chomp.to_i
	c = 0 if c < 0 or c > 8

	puts n[c] + " names:"

	10.times do
	  print `name_generator/name_generator_main.rb -d #{f[c]}`.chomp + " "
	  if /human/ =~ f[c]
		print `name_generator/name_generator_main.rb -d human_last.txt`.chomp
	  else
		print `name_generator/name_generator_main.rb -d #{f[c]}`.chomp
	  end
	  print "\n"
	end
end
