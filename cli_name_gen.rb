# The encounter input module for CLI NPCg
  
def name_gen

  # Get name type
	puts "\nEnter name type:"
	puts "0: Human male   1: Human female   2: Dwarven male   3: Dwarven female   4: Elven male   5: Elven female   6: Lizardfolk   7: Araxi"
	print "> "
	c = gets.chomp.to_i
	c = 0 if c < 0 or c > 7
	case c
	  when 0
		name_type = "human_male_first.txt"
	  when 1
		name_type = "human_female_first.txt"
	  when 2
		name_type = "dwarven_male.txt"
	  when 3
		name_type = "dwarven_female.txt"
	  when 4
		name_type = "elven_male.txt"
	  when 5
		name_type = "elven_female.txt"
	  when 6
		name_type = "lizardfolk.txt"
	  when 7
		name_type = "lizardfolk.txt"
	end

	10.times do
	  if /human/ =~ name_type
		print `name_generator/name_generator_main.rb -d #{name_type}`.chomp + " "
		print `name_generator/name_generator_main.rb -d human_last.txt`
	  else
		puts `name_generator/name_generator_main.rb -d #{name_type}`
	  end
	end
end
