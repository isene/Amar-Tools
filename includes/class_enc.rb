# The Amar Tool class for generating random encounters
#
# When the class is initialized, a random encounter is generated
# using data from the imported tables (hashes and arrays)
#
# This class is pretty straight forward and shouldn't need much comments

class Enc

	attr_reader :encounter, :enc_attitude, :enc_number

	Inf = 1.0/0

	def initialize(enc_spec, enc_number)

		$Terraintype = 8 if $Terraintype == nil
		$Level = 0 if $Level == nil

		@enc_spec = enc_spec.to_s
		@enc_number = enc_number.to_i

		@enc_spec == "" ? @enc = false : @enc = true 
		@enc_type = ""
		if @enc == false
			@enc_terrain = {}
			$Enc_type.each do |key,value|
				@enc_terrain[key] = value[$Terraintype]
			end
			@enc_type = randomizer(@enc_terrain)
		end

		@encounter = []
		
		if @enc_type =~ /NO ENCOUNTER/
			@encounter[0] = {}
			@encounter[0]["string"] = "NO ENCOUNTER"
			return
		end

		@enc_attitude = ""
		case d6
			when 1
				@enc_attitude = "HOSTILE"
			when 2
				@enc_attitude = "ANTAGONISTIC"
			when 3..4
				@enc_attitude = "NEUTRAL"
			when 5
				@enc_attitude = "POSITIVE"
			when 6
				@enc_attitude = "FRIENDLY"
		end

		if @enc == false
			@enc_terrain2 = {}
			$Enc_specific[@enc_type].each do |key,value|
				@enc_terrain2[key] = value[$Terraintype]
			end
		end

		if @enc_number == 0
			case oD6
				when -Inf..3
					@enc_number = 1
				when 4
					@enc_number = dX (3)
				when 5
					@enc_number = d6
				when 6..7
					@enc_number = 2*d6
				else
					@enc_number = 3*d6
			end
			@enc_number = 5 if @enc_number > 5 and @enc_type =~ /onster/
		end
		
		@enc_number.times do |i|
			@encounter[i] = {}
			@enc == true ? @encounter[i]["string"] = @enc_spec : @encounter[i]["string"] = randomizer(@enc_terrain2)
			if @encounter[i]["string"] =~ /Event:/
				break
			else
			begin
				@stats = $Encounters[@encounter[i]["string"]].dup
				
				@encounter[i]["level"] = dX(@stats[0]) + $Level
				@encounter[i]["level"] += 2 if @encounter[i]["string"] =~ /Elf/
				@encounter[i]["level"] += 1 if @encounter[i]["string"] =~ /Dwarf/
				@level = @encounter[i]["level"]
				
				case rand(2).to_i
					when 0
						@encounter[i]["sex"] = "F"
					else
						@encounter[i]["sex"] = "M"
				end
				@encounter[i]["sex"] = "M" if @encounter[i]["string"] =~ /officer/ and rand(6) != 0
				@encounter[i]["sex"] = "F" if @encounter[i]["string"] =~ /Prostitute/ and rand(10) != 0
				@encounter[i]["sex"] = "F" if @encounter[i]["string"] =~ /Nanny/ and rand(10) != 0
				@encounter[i]["sex"] = "F" if @encounter[i]["string"] =~ /wife/

				@encounter[i]["race"] = ""
				case @encounter[i]["string"]
				when /Human/
					@encounter[i]["race"] = "Human"
				when /Dwarf/
					@encounter[i]["race"] = "Dwarf"
				when /Elf/, /Faerie/
					@encounter[i]["race"] = "Elf"
				when /Troll/
					@encounter[i]["race"] = "Troll"
				when /Arax/
					@encounter[i]["race"] = "Arax"
				when /Lizardman/
					@encounter[i]["race"] = "Lizardfolk"
				else
					@encounter[i]["race"] = "Other"
				end

				@encounter[i]["name"] = naming(@encounter[i]["race"], @encounter[i]["sex"])

				@encounter[i]["size"] = @stats[1] + (rand(10 * @stats[1]+1) + rand(10 * @stats[1]+1) - 10 * @stats[1])/20
				@encounter[i]["size"] = 1 if @encounter[i]["size"] < 1

				@encounter[i]["strength"] = ((@stats[2] * @level + 1) / 3 - 2 + aD6)
				@encounter[i]["strength"] = 1 if @encounter[i]["strength"] < 1

				@db = (@encounter[i]["strength"] + @encounter[i]["size"]) / 3

				@wpnmax = 0
				case @encounter[i]["strength"]
					when 1
						@wpnmax = 2
					when 2
						@wpnmax = 4
					when 3
						@wpnmax = 11
					when 4
						@wpnmax = 18
					when 5
						@wpnmax = 22
					when 7..8
						@wpnmax = 28
					else
						@wpnmax = 30
				end

				@mslmax = 0
				case @encounter[i]["strength"]
					when 1
						@mslmax = 2
					when 2
						@mslmax = 5
					when 3
						@mslmax = 7
					when 4..5
						@mslmax = 9
					when 6..7
						@mslmax = 10
					when 8..9
						@mslmax = 11
					else
						@mslmax = 12
				end

				@encounter[i]["endurance"] = ((@stats[3] * @level + 1) / 3 - 2 + aD6)
				@encounter[i]["endurance"] = 1 if @encounter[i]["endurance"] < 1

				@encounter[i]["bp"] = 2 * @encounter[i]["size"] + (@encounter[i]["endurance"] / 3)

				@encounter[i]["awareness"] = ((@stats[4] * @level + 1) / 3 - 2 + aD6)
				@encounter[i]["awareness"] = 1 if @encounter[i]["awareness"] < 1

				@encounter[i]["dodge"] = ((@stats[5] * @level + 1) / 3 - 2 + aD6)
				@encounter[i]["dodge"] = 0 if @encounter[i]["dodge"] < 0

				@stats[9] > 0 ? @encounter[i]["mag"] = ((@stats[9] * @level + 1) / 3 - 2 + aD6) : @encounter[i]["mag"] = 0
				@encounter[i]["mag"] = 0 if @encounter[i]["mag"] < 0

        @arax = 0
        if @encounter[i]["race"] == "Arax"
          case rand(24).to_i
            when 0
              @encounter[i]["size"] += d6 - 1
            when 1
              @encounter[i]["strength"] += oD6 + 3
              @encounter[i]["strength"] = 3 if @encounter[i]["strength"] < 3
            when 2
              @encounter[i]["endurance"] += oD6 + 3
              @encounter[i]["endurance"] = 2 if @encounter[i]["endurance"] < 2
            when 3
              @encounter[i]["awareness"] += oD6 + 3
              @encounter[i]["awareness"] = 0 if @encounter[i]["awareness"] < 0
            when 4
              @encounter[i]["mag"] += oD6
              @encounter[i]["mag"] = 1 if @encounter[i]["mag"] < 1
            when 5
              @encounter[i]["dodge"] += oD6
              @encounter[i]["dodge"] = 5 if @encounter[i]["dodge"] < 5
            when 6
					    @encounter[i]["mag_lore"] = ((@stats[10] * @level + 1) / 3 - 2 + aD6)
					    @encounter[i]["spells"] = 1
							@encounter[i]["mag_type"] = randomizer(
								"Black"			=> 3,
								"Earth"			=> 3,
								"Prot."			=> 2,
                "Perc."			=> 2)
            when 7..12
              @arax = 1
          end
        end

				if @stats[10] > 0
					@encounter[i]["mag_lore"] = ((@stats[10] * @level + 1) / 3 - 2 + aD6)
					@encounter[i]["mag_lore"] = 1 if @encounter[i]["mag_lore"] < 1
					@encounter[i]["spells"] = ((@encounter[i]["mag_lore"] * @level + 1) / 5 - 2 + aD6)
					@encounter[i]["spells"] = 0 if @encounter[i]["spells"] < 0
					@encounter[i]["mag_type"] = ""
					case @encounter[i]["string"]
						when /black/
							@encounter[i]["mag_type"] = "Black"
						when /white/
							@encounter[i]["mag_type"] = "White"
						when /air/
							@encounter[i]["mag_type"] = "Air"
						when /earth/
							@encounter[i]["mag_type"] = "Earth"
						when /fire/
							@encounter[i]["mag_type"] = "Fire"
						when /water/
							@encounter[i]["mag_type"] = "Water"
						when /prot/
							@encounter[i]["mag_type"] = "Prot."
						when /Summoner/
							@encounter[i]["mag_type"] = "Summ."
						else
							@encounter[i]["mag_type"] = randomizer(
								"Black"			=> 3,
								"White"			=> 8,
								"Air"				=> 5,
								"Earth"			=> 5,
								"Fire"			=> 5,
								"Water"			=> 5,
								"Prot."			=> 5,
								"Summ."			=> 4,
								"Magic"			=> 3)
					end
				end

				@wpn = $Melee[rand(@wpnmax) + 1].dup
				@wpn = $Melee[1].dup if @stats[6] < 0
				@encounter[i]["wpn_name"] = @wpn[0]
				@encounter[i]["wpn_skill"] = ((@stats[6].abs * @level + 1) / 3 - 2 + aD6)
				@encounter[i]["wpn_skill"] = 1 if @encounter[i]["wpn_skill"] < 1
        # Reaction speed is calculated as weighted average between Awareness and Melee skill
        if @encounter[i]["wpn_skill"] < @encounter[i]["awareness"]
          @encounter[i]["reaction"] = (@encounter[i]["wpn_skill"] * 2 + @encounter[i]["awareness"]) / 3 + d6 - 3
        else
          @encounter[i]["reaction"] = (@encounter[i]["awareness"] * 2 + @encounter[i]["wpn_skill"]) / 3 + d6 - 3
        end
        @encounter[i]["reaction"] = @encounter[i]["awareness"] / 3 if @encounter[i]["reaction"] < @encounter[i]["awareness"] / 3
				@encounter[i]["wpn_ini"] = @wpn[4] + @encounter[i]["reaction"]
				@encounter[i]["wpn_off"] = @encounter[i]["wpn_skill"] + @wpn[5]
				@encounter[i]["wpn_def"] = @encounter[i]["wpn_skill"] + @wpn[6] + @encounter[i]["dodge"] / 5
				@encounter[i]["wpn_dam"] = @db + @wpn[3]
					 
				if @stats[8] < 0
					@encounter[i]["ap"] = @stats[8].abs
				elsif @stats[8] > 0
					@encounter[i]["ap"] = rand(@stats[8])
				else
					@encounter[i]["ap"] = 0
				end

				@encumberance = 3 + @encounter[i]["ap"] * 7
				if @encounter[i]["strength"] * 2 > @encumberance
					@encounter[i]["status"] = 0
				elsif @encounter[i]["strength"] * 5 > @encumberance
					@encounter[i]["status"] = -1
				elsif @encounter[i]["strength"] * 10 > @encumberance
					@encounter[i]["status"] = -3
				else 
					@encounter[i]["status"] = -5
				end

				if @stats[7] != 0
					@msl = $Missile[rand(@mslmax) + 1].dup
					@encounter[i]["msl_name"] = @msl[0]
					@encounter[i]["msl_skill"] = ((@stats[7] * @level + 1) / 3 - 2 + aD6)
					@encounter[i]["msl_skill"] = 1 if @encounter[i]["msl_skill"] < 1
					@encounter[i]["msl_ini"] = @msl[7] + @encounter[i]["reaction"]
					@encounter[i]["msl_off"] = @encounter[i]["msl_skill"] + @msl[4]
					@encounter[i]["msl_dam"] = @msl[3]
					@encounter[i]["msl_rng"] = @msl[5]
					if @msl[1] !~ /bow/
						@encounter[i]["msl_dam"] += @encounter[i]["strength"] / 5
					end
				end

        if @arax == 1
          case rand(11).to_i
            when 0
              @encounter[i]["ap"] += d6
            when 1..3
              @tmp = oD6 + 3
              @encounter[i]["wpn_skill"] += @tmp
              @encounter[i]["wpn_off"]   += @tmp
              @encounter[i]["wpn_def"]   += @tmp
            when 4..5
              @tmp = oD6 + 3
              @encounter[i]["msl_skill"] += @tmp
              @encounter[i]["msl_off"]   += @tmp 
            when 6
              @encounter[i]["msl_name"] = "Poison spit"
              @encounter[i]["msl_skill"] = ((@stats[7] * @level + 1) / 3 - 2 + aD6)
              @encounter[i]["msl_skill"] = 1 if @encounter[i]["msl_skill"] < 1
              @encounter[i]["msl_off"] = @encounter[i]["msl_skill"]
              @encounter[i]["msl_dam"] = 2
              @encounter[i]["msl_rng"] = 10
            when 7
              @encounter[i]["msl_name"] = "Poison breath"
              @encounter[i]["msl_skill"] = ((@stats[7] * @level + 1) / 3 + aD6)
              @encounter[i]["msl_skill"] = 1 if @encounter[i]["msl_skill"] < 1
              @encounter[i]["msl_off"] = @encounter[i]["msl_skill"]
              @encounter[i]["msl_dam"] = 0
              @encounter[i]["msl_rng"] = 3
            else
              @encounter[i]["string"] += " [Chaos feature, GM's discr.]"
          end
        end

				rescue # Result for corner cases
					@encounter[0] = {}
					@encounter[0]["string"] = "NO ENCOUNTER"
					return
				end
			end
			@enc_terrain2[@encounter[i]["string"]] += 20 if @encounter[i]["string"] =~ /Human/ and @enc == false
		end
	end
end
