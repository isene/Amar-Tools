def enc_output(anENC)

	e = anENC.encounter

	f = "#################################<By NPCg 0.5>#################################\n"

	$Day == 1 ? f += "Day:   " : f += "Night: "
	case $Terrain
		when 0
			f += "City      "
		when 1
			f += "Rural     "
		when 2
			f += "Road      "
		when 3
			f += "Plains    "
		when 4
			f += "Hills     "
		when 5
			f += "Mountains "
		when 6
			f += "Woods     "
		when 7
			f += "Wilderness"
	end

	f += "    (Level=" + $Level.to_s + ")"
	f += "Created: #{Date.today.to_s}".rjust(49) + "\n\n"

  if e[0]["string"] == "NO ENCOUNTER"
		f += "\nNO ENCOUNTER\n\n"
	else
		f += anENC.enc_attitude
		f += ":\n"
		anENC.enc_number.times do |i|
			f += e[i]["string"].ljust(23)
			if e[i]["string"] =~ /Event:/
				f += "\n\n"
				break
			else
				f += " (" + e[i]["sex"]
				f += ", Lv" + e[i]["level"].to_s + ")"

				f += " SIZ=" + e[i]["size"].to_s
				f += "  STR=" + e[i]["strength"].to_s
				f += "  END=" + e[i]["endurance"].to_s
				f += "  AWR=" + e[i]["awareness"].to_s
				f += "  MAG=" + e[i]["mag"].to_s
				f += "  Ddg=" + e[i]["dodge"].to_s
				f += " (" + e[i]["status"].to_s + ")"
				if e[i]["magic_lore"]
					f += "\n".ljust(25) + e[i]["mag_type"] + "Lore=" + e[i]["mag_lore"].to_s
					f += ", Spells=" + e[i]["spells"].to_s
				end
				f += "\n"

				f += "  " + e[i]["wpn_name"].ljust(22) + "Skill=" + e[i]["wpn_skill"].to_s.rjust(2) + ", Ini: " + e[i]["wpn_ini"].to_s
				f += ", Off:" + e[i]["wpn_off"].to_s.rjust(2) + ", Def:" + e[i]["wpn_def"].to_s.rjust(2) + ", Dam:" + e[i]["wpn_dam"].to_s.rjust(2)
				f += "    AP:" + e[i]["ap"].to_s + ", BP:" + e[i]["bp"].to_s + "\n"

				if e[i]["msl_name"]
					f += "  " + e[i]["msl_name"].ljust(22) + "Skill=" + e[i]["msl_skill"].to_s.rjust(2)
					f += ", Off:" + e[i]["msl_off"].to_s.rjust(2) + ", Dam:" + e[i]["msl_dam"].to_s.rjust(2) + ", Rng:" + e[i]["msl_rng"].to_s + "\n"
				end
			end

			f += "\n"
			f += "\n" if e[0]["string"] =~ /Event/
		end
	end
		
	f += "###############################################################################\n\n"

	begin
		File.delete("npcs/encounter.npc")
		File.open("npcs/encounter.npc", File::CREAT|File::EXCL|File::RDWR, 0644) do |fl|
			fl.write f
		end
	rescue
		puts "Error writing file \"npcs/encounter.npc\""
	end
	system("#{$editor} npcs/encounter.npc")
end
