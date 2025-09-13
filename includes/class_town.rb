# The Amar Tool class for generating random castles/villages/towns/cities.
#
# When the class is initialized, a random settlement (village/town/city) is generated.
#
# A pretty straight forward class, not in need of much comments

class Town

	attr_reader :town, :town_name, :town_size, :town_residents

	# Although there is a generic name function, the town creator needs to
	# modify it to cater for a high chance of a household having the same surname
	def name(race)
		new_name = naming(race, @r_sex)
		name_split = new_name.split
		$Last_name = name_split[1].to_s if $Last_name == "" or /Soldier/ =~ @town[@h_index][0] or /residents/ =~ @town[@h_index][0]
		name_split[1] = $Last_name if rand(1..4) > 1
		new_name = name_split.join(" ").strip
		return new_name
	end

	# Using the generic randomizer function to get random races based on weighted input
	def race(var)
		case var
			when 0
				@race = randomizer(
					"Human"					=> 10,
					"Other"					=> 1)
			when 1
				@race = randomizer(
					"Human"					=> 10,
					"Dwarf"					=> 4,
					"Half-elf"			=> 2,
					"Lizardfolk"		=> 1,
					"Other"					=> 1)
			when 2
				@race = randomizer(
					"Human"					=> 10,
					"Dwarf"					=> 5,
					"Half-elf"			=> 3,
					"Lizardfolk"		=> 2,
					"Lesser troll"  => 2,
					"Half-giant"		=> 1,
					"Other"					=> 2)
			when 3
				@race = randomizer(
					"Human"					=> 10,
					"Dwarf"					=> 7,
					"Half-elf"			=> 5,
					"Lizardfolk"		=> 3,
					"Lesser troll"  => 3,
					"Half-giant"		=> 2,
					"Elf"						=> 1,
					"Troll"					=> 1,
					"Arax"					=> 1,
					"Other"					=> 2)
			when 4
				@race = randomizer(
					"Dwarf"					=> 15,
					"Other"					=> 1)
			when 5
				@race = randomizer(
					"Elf"						=> 12,
					"Half-elf"			=> 3,
					"Other"					=> 1)
			when 6
				@race = randomizer(
					"Lizardfolk"		=> 15,
					"Other"					=> 1)
			end
		return @race
	end

	# The function to add residents to houses
	def add_resident(age)
		@town_residents += 1
		# Get race
		if $Race == ""
			@r_race = race(@town_var)
			$Race = @r_race unless /residents/ =~ @town[@h_index][0]
		elsif rand(5).to_i == 0
			@r_race = race(@town_var)
		else
			@r_race = $Race
		end
		# Get sex
		if $Sex == ""
			@r_sex = randomizer( "M" => 1, "F" => 1 )
		elsif $Sex == "M"
			@r_sex = randomizer( "M" => 1, "F" => 3 )
		elsif $Sex == "F"
			@r_sex = randomizer( "M" => 3, "F" => 1 )
		end
		$Sex = @r_sex
		# Get age
		case age
			when 0
				@r_age = rand(70).to_i + 15
			when 1
				@r_age = rand(35).to_i + 50
			when 2
				@r_age = rand(30).to_i + 20
			when 3
				@r_age = rand(20).to_i
		end
		@r_age = @r_age*2 if $Race == "Dwarf"
		@r_age = @r_age*1.5 if $Race == "Half-elf"
		@r_age = @r_age*3 if $Race == "Elf"
		@r_age = @r_age*0.8 if $Race == "Lizardfolk"
		@r_age = @r_age*1.5 if $Race == "Lesser troll"
		@r_age = @r_age*2 if $Race == "Troll"
		@r_age = @r_age*0.5 if $Race == "Arax"
		@r_age = @r_age.to_i
		# Get name
		@r_name = name(@r_race)
		# Get personality
		@r_pers = randomizer($Personality)
		# Get skill
		@r_skill = (rand(6) + rand(6) + @r_age/20).to_i
		@r_skill += (@r_age/15).to_i if /Stronghold/ =~ @town[@h_index][0]
		@r_skill += (@r_age/20).to_i if /Noble/ =~ @town[@h_index][0]
		@town[@h_index][@r] = "#{@r_name} (#{@r_sex} #{@r_age}) #{@r_race} [#{@r_skill}] #{@r_pers}"
		@r += 1
	end

	# The initializing method - generates houses
	def initialize(town_name, town_size, town_var)

		@town_size = town_size.to_i
		@town_var  = town_var.to_i
		@town_name = town_name.to_s
		if @town_name == ""
			case @town_size
			when 1..5
				@town_name = naming("castle")
			when 6..25
				@town_name = naming("village")
			when 26..99
				@town_name = naming("town")
			else
				@town_name = naming("city")
			end
		end
		@town_residents = 0

		# Temple types (Amar Gods) used for randomizing temples
		$Temple_types = {
			"Walmaer"							=> 4,
			"Alesia"							=> 4,
			"Ikalio"							=> 3,
			"Shalissa"						=> 3,
			"Ielina"							=> 2,
			"Cal Amae"						=> 2,
			"Anashina"						=> 3,
			"Gwendyll/MacGillan"  => 4,
			"Juba"								=> 1,
			"Taroc"								=> 5,
			"Recolar"							=> 1,
			"Maleko"							=> 1,
			"Fal Munir"						=> 2,
			"Moltan"							=> 4,
			"Kraagh"							=> 4,
			"Lesser God"					=> 1}
		#Initiate the Temple hash to be used if/when temples are picked
		t = $Temple_types.dup

		@town = []
		@h_index = 0

		# Load town table if not loaded
		unless defined?($Town)
			load File.join($pgmdir, "includes/tables/town.rb")
		end

		$Town[1..-1].each do | h_type |
			#Iterate over the whole $Town array picking houses as we go and populating @town
			h_number = ((rand(h_type[2]) + rand(h_type[2]) + rand()) * town_size / 100).to_i
			h_number = h_type[3] if h_number < h_type[3]
			h_number = h_number.to_i
			# create that house types h_number of times
			next if h_number == 0
			h_number.times do
				@town[@h_index] = []
				@town[@h_index][0] = h_type[0]
				#Pick opening hours if shop
				if /Inn/ =~ h_type[0]
					@town[@h_index][0] += ": Open 7/7, 06-00"
				end
				if h_type[1] == 1
					@town[@h_index][0] += ": Open "
					@town[@h_index][0] += randomizer(
						"5/7, "  => 1,
						"6/7, "  => 2,
						"7/7, "  => 1)
					@town[@h_index][0] += randomizer(
						"07-" => 1,
						"08-" => 2,
						"09-" => 1)
					@town[@h_index][0] += randomizer(
						"16"    => 1,
						"17"    => 2,
						"18"    => 1)
				end
				if @town[@h_index][0] == "Temple"
					t_type =  randomizer(t)
					@town[@h_index][0] += ": " + t_type unless t.empty?
					t.delete(t_type)
				end
				r = 1 #residents counter
				# Make the next into a function with age of no 1 as "0", then 1, 2, 3
				$Race = ""
				$Sex = ""
				$Last_name = ""
				@r = 1
				add_resident(0)
				(rand(h_type[4]) + rand(h_type[4])).to_i.times {add_resident(1)}
				(rand(h_type[5]) + rand(h_type[5])).to_i.times {add_resident(2)}
				((town_size / 40) + 1).to_i.times {add_resident(2)} if /Stronghold/ =~ @town[@h_index][0] 
				(rand(h_type[6]) + rand(h_type[6])).to_i.times {add_resident(3)}
				@h_index += 1
				# Output progress for monitoring - EXACTLY like CLI
				$stdout.puts "House #{@h_index}" if defined?($stdout) && $stdout.respond_to?(:puts)
				break if @h_index > town_size
			end
			break if @h_index > town_size
		end
	end
end
