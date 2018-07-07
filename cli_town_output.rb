def town_output(aTOWN)

	t = aTOWN.town

	f = "#################################<By NPCg 0.5>#################################\n\n"

	t.length.times do |house|
		f += "##{house}: #{t[house][0]}\n"
		t[house][1..-1].each do |r|
			f += "   #{r}\n"
		end
		f += "\n"
	end
		
	f += "###############################################################################\n\n"

	begin
		File.delete("npcs/town.npc")
		File.open("npcs/town.npc", File::CREAT|File::EXCL|File::RDWR, 0644) do |fl|
			fl.write f
		end
	rescue
		puts "Error writing file \"npcs/town.npc\""
	end
	system("#{$editor} npcs/town.npc")
end
