# The encounter input module for CLI NPCg
  
def name_gen

	n = ["Human male", "Human female", "Dwarven male", "Dwarven female", "Elven male", "Elven female", "Lizardfolk", "Troll", "Araxi"]
  # Get name type
	puts "\nEnter name type:"
	n.each_with_index do |value,index|
		print "#{index}: #{value}   "
	end
	print "\n> "
	c = gets.chomp.to_i
	c = 0 if c < 0 or c > 8
	case c
	  when 0
		name_file = "human_male_first.txt"
	  when 1
		name_file = "human_female_first.txt"
	  when 2
		name_file = "dwarven_male.txt"
	  when 3
		name_file = "dwarven_female.txt"
	  when 4
		name_file = "elven_male.txt"
	  when 5
		name_file = "elven_female.txt"
	  when 6
		name_file = "lizardfolk.txt"
	  when 7
		name_file = "troll.txt"
	  when 8
		name_file = "araxi.txt"
	end

	puts n[c] + " names:"

	10.times do
	  if /human/ =~ name_file
		print `name_generator/name_generator_main.rb -d #{name_file}`.chomp + " "
		print `name_generator/name_generator_main.rb -d human_last.txt`
	  else
		puts `name_generator/name_generator_main.rb -d #{name_file}`
	  end
	end
end
