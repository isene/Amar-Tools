def enc_output(anENC, cli)

	e = anENC.encounter

	f = "############################<By Amar Tools>############################\n"

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

	f += " (Level mod = " + $Level.to_s + ")"
	f += "Created: #{Date.today.to_s}".rjust(38) + "\n\n"

  if e[0]["string"] == "NO ENCOUNTER"
		f += "\nNO ENCOUNTER\n\n"
	else
		f += anENC.enc_attitude
		f += ":\n"
		anENC.enc_number.times do |i|
			f += "  "
			e[i]["string"] += " (#{e[i]["name"]})" unless e[i]["string"] =~ /animal/ or e[i]["string"] =~ /Event/
			f += e[i]["string"]
			if e[i]["string"] =~ /Event:/
				f += "\n\n"
				break
			else
				f += " (" + e[i]["sex"]
				f += ", Level " + e[i]["level"].to_s + ")\n"
				f += "".ljust(15)
				f += " SIZ=" + e[i]["size"].to_s
				f += "  STR=" + e[i]["strength"].to_s
				f += "  END=" + e[i]["endurance"].to_s
				f += "  AWR=" + e[i]["awareness"].to_s
				f += "  MAG=" + e[i]["mag"].to_s
				f += "  Ddg=" + e[i]["dodge"].to_s
				f += " (Status: " + e[i]["status"].to_s + ")"
				if e[i]["magic_lore"]
					f += "\n".ljust(17) + e[i]["mag_type"] + "Lore=" + e[i]["mag_lore"].to_s
					f += ", Spells=" + e[i]["spells"].to_s
				end
				f += "\n"

				f += "  " + e[i]["wpn_name"].ljust(14) + "Skill=" + e[i]["wpn_skill"].to_s.rjust(2) + ", Ini: " + e[i]["wpn_ini"].to_s
				f += ", Off:" + e[i]["wpn_off"].to_s.rjust(2) + ", Def:" + e[i]["wpn_def"].to_s.rjust(2) + ", Dam:" + e[i]["wpn_dam"].to_s.rjust(2)
				f += "    AP:" + e[i]["ap"].to_s + ", BP:" + e[i]["bp"].to_s + "\n"

				if e[i]["msl_name"]
					f += "  " + e[i]["msl_name"].ljust(14) + "Skill=" + e[i]["msl_skill"].to_s.rjust(2)
					f += ", Off:" + e[i]["msl_off"].to_s.rjust(2) + ", Dam:" + e[i]["msl_dam"].to_s.rjust(2) + ", Rng:" + e[i]["msl_rng"].to_s + "\n"
				end
			end

			f += "\n"
			f += "\n" if e[0]["string"] =~ /Event/
		end
	end
		
	f += "#######################################################################\n\n"

  cli == "cli" ? tfile = "saved/encounter.npc" : tfile = "saved/encounter.txt"
  begin
  	File.delete(tfile) if File.exists?(tfile)
  	File.write(tfile, f, perm: 0644)
  rescue
  	puts "Error writing file #{tfile}"
  	gets if cli == "cli"
  end
  system("#{$editor} #{tfile}") if cli == "cli"

end
