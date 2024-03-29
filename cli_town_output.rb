# The CLI town output module for Amar Tools

def town_output(aTOWN, cli)

	@town = aTOWN.town

	# Start creating the output text
	@tn= ""
	f  = ""
	f += "(You may want to bookmark this URL for future references to this Town)\n\n" unless cli == "cli"
	f += "############################<By Amar Tools>############################\n\n"

	case aTOWN.town_size
	when 1..4
		@tn += "Castle"
	when 5..25
		@tn += "Village"
	when 26..99
		@tn += "Town"
	else
		@tn += "City"
	end
	@tn += " Of #{aTOWN.town_name}"
	town_name = @tn.delete(' ')
	@tn += " - Houses: #{aTOWN.town_size} - Residents: #{aTOWN.town_residents}\n\n"
	f   += @tn

	@town.length.times do |house|
		f += "##{house}: #{@town[house][0]}\n"
		@town[house][1..-1].each do |r|
			f += "   #{r}\n"
		end
		f += "\n"
	end
		
	f += "\n#######################################################################"

	# from functions.rb - save to temp file and named file
	save_temp_file(f, "town", cli)
	save_named_file(f, town_name, cli)

end
