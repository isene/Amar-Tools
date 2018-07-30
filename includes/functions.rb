# GET NAMES FROM NAME GENERATOR
def name(race, sex)
	sex = sex.to_s.upcase
	race = race.to_s
	p = File.expand_path(File.dirname(__FILE__))
	case race
		when "Human", "Half-giant"
			file = "human_male_first.txt"
			file = "human_female_first.txt" if sex == "F"
		when "Dwarf"
			file = "dwarven_male.txt"
			file = "dwarven_female.txt" if sex == "F"
		when "Elf", "Half-elf"
			file = "elven_male.txt"
			file = "elven_female.txt" if sex == "F"
		when "Lizardfolk"
			file = "lizardfolk.txt"
		when "Troll", "Lesser troll"
			file = "troll.txt"
		when "Arax"
			file = "araxi.txt"
		else
			file = "fantasy_male.txt"
			file = "fantasy_female.txt" if sex == "F"
	end
	result = `#{p}/../name_generator/name_generator_main.rb -d #{file}`.chomp + " "
	if /human/ =~ file
		lastname = `#{p}/../name_generator/name_generator_main.rb -d human_last.txt`.chomp
	elsif /fantasy/ =~ file
		lastname = ""
	else
		lastname = `#{p}/../name_generator/name_generator_main.rb -d #{file}`.chomp
	end
	result += lastname
	return result.strip
end

# SAVE TEMPORARY FILES
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

# SAVE NAMED (SPECIFIC) FILES
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

