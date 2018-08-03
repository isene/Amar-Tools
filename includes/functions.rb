# Get names from name generator
def name(race, sex="M")
	sex = sex.to_s.upcase
	race = race.to_s.downcase
	ln = true
	case race
		when /dwarf/, /dwarven/, /gnome/
			race = "Dwarf-"
		when /elf/, /elven/, /faerie/, /faery/, /pixie/, /brownie/
			race = "Dwarf-"
		when /lizard/
			race = "Lizard-"
			sex = "M"
		when /troll/, /ogre/
			race = "Troll-"
			sex = "M"
		when /arax/
			race = "Arax-"
			sex = "M"
		when /fantasy/, /generic/
			race = "Generic-"
			ln = false
		else
			race = "Human-"
	end

	race += sex
	file = $Names[race]

	p = File.expand_path(File.dirname(__FILE__))
	n = "/../name_generator/name_generator_main.rb -d"
	
	result = `#{p}#{n} #{file}`.chomp + " "
	
	if ln
		if /Human/ =~ race
			lastname = `#{p}#{n} Human_last.txt`.chomp
		else
			lastname = `#{p}#{n} #{file}`.chomp
		end
		result += lastname
	end
	
	return result.strip

end

# Save temporary files
def save_temp_file(content, file_base, cli)
	cli == "cli" ? file_ext = ".npc" : file_ext = ".txt"

	tfile = "saved/" + file_base + file_ext
	File.delete(tfile) if File.exist?(tfile)
	begin
		File.write(tfile, content, perm: 0644)
	rescue
  	if cli == "cli"
			puts "Error writing file #{tfile}"
			gets
		end
	end
end

# Save named (specific) files
def save_named_file(content, file_base, cli)
	cli == "cli" ? file_ext = ".npc" : file_ext = ".txt"

	$nfile = "saved/" + file_base + file_ext
  while File.exists?($nfile)
		$nfile =  "saved/" + File.basename($nfile) + "1" + file_ext
	end
  begin
  	File.write($nfile, content, perm: 0644)
  rescue
  	if cli == "cli"
			puts "Error writing file #{$nfile}"
			gets
		end
  end

	system("#{$editor} #{$nfile}") if cli == "cli"
end

