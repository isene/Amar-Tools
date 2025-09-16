# Get names from name generator
def naming(intype, sex="")
	sex = sex.to_s.upcase
	type = intype.sub(/(:| ).*/, '').to_s.downcase

	# Get for race/sex filename for first name and last name (if any)
	file1 = ""
	file2 = ""
	$Names.each do |m| 
		if m[4].include?(type) and m[3].include?(sex)
			file1 = m[1]
			file2 = m[2]
			break
		end
	end

	p = File.expand_path(File.dirname(__FILE__))
	n = "/../name_generator/name_generator_main.rb -d"
	
	result  = ""
	result += intype + " of " if ["Castle", "Village", "Town", "City"].include?(intype)
	result += `#{p}#{n} #{file1}`.chomp
	result += " " + `#{p}#{n} #{file2}`.chomp if file2 != ""
	result  = "" if result == "No such data file"
	return result.strip
end

# Save temporary files
def save_temp_file(content, file_base, cli)
	cli == "cli" ? file_ext = ".npc" : file_ext = ".txt"

	tfile = "saved/" + file_base + file_ext
	File.delete(tfile) if File.exist?(tfile)
	begin
		# Strip ANSI codes when saving to file for clean editing
		clean_content = content.respond_to?(:pure) ? content.pure : content.gsub(/\e\[\d+(?:;\d+)*m/, '')
		File.write(tfile, clean_content, perm: 0644)
	rescue
  	if cli == "cli"
			# Silent error - no puts in TUI mode
			# gets removed for TUI compatibility
		end
	end
end

# Save named (specific) files
def save_named_file(content, file_base, cli)
	cli == "cli" ? file_ext = ".npc" : file_ext = ".txt"

	$nfile = "saved/" + file_base + file_ext
  c = 1
  while File.exist?($nfile)
    $nfile = "saved/" + file_base + c.to_s + file_ext 
    c += 1
	end
  begin
  	File.write($nfile, content, perm: 0644)
  rescue
  	if cli == "cli"
			# Silent error - no puts in TUI mode
			# gets removed for TUI compatibility
		end
  end

	system("#{$editor} #{$nfile}") if cli == "cli"
end

