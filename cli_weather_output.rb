def weather_output(aWEATHER)

	w = aWEATHER

	f = "#################################<By NPCg 0.5>#################################\n\n"

	f += "Month: #{$Month[w.name]}\n"
	
	f += "-------------------------------------------------------------------------------\n"
	w.day.each_with_index do |d,i|
		f += "Day #{(i+1).to_s.rjust(2)}: #{$Weather[d.weather]}. #{$Wind_str[d.wind_str]}"
		f += " (#{$Wind_dir[d.wind_dir]})" unless d.wind_str == 0
		f += " -[ #{d.special} ]-" unless d.special == ""
		if w.name != 0
			f += "   [New moon]" if i == 0
			f += "   [Half moon, vaxing]" if i == 7
			f += "   [Full moon]" if i == 14
			f += "   [Half moon, waning]" if i == 21
		end
		f += "\n"
		f += "-------------------------------------------------------------------------------\n" if ((i+1)%7) == 0 
	end

	f += "\n###############################################################################\n\n"

	wfile = "npcs/weather.npc"
	begin
		File.delete(wfile) if File.exists?(wfile)
		File.write(wfile, f, perm: 0644)
	rescue
		puts "Error writing file #{wfile}"
		gets
	end
	system("#{$editor} #{wfile}")
end
