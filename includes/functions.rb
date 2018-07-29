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

