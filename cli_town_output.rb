def town_output(aTOWN)

	t = aTOWN.town

	f = "#################################<By NPCg 0.5>#################################\n\n"

	t.length.times do |house|
		f += "##{house + 1}: #{t[house][0]}\n"
		t[house][1..-1].each do |r|
			f += "   #{r}\n"
		end
		f += "\n"
	end
		
	f += "###############################################################################\n\n"

	tfile = "npcs/town.npc"
	begin
		File.delete(tfile) if File.exists?(tfile)
		File.write(tfile, f, perm: 0644)
	rescue
		puts "Error writing file #{tfile}"
		gets
	end
	system("#{$editor} #{tfile}")
end
