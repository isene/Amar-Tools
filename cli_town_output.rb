def town_output(aTOWN, cli)

	@t = aTOWN.town

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
	town_name = @tn
	@tn += " - Houses: #{aTOWN.town_size} - Residents: #{aTOWN.town_residents}\n\n"
	f   += @tn

	@t.length.times do |house|
		f += "##{house + 1}: #{@t[house][0]}\n"
		@t[house][1..-1].each do |r|
			f += "   #{r}\n"
		end
		f += "\n"
	end
		
	f += "\n#######################################################################"

save_temp_file(f, "town", cli)
save_named_file(f, town_name.delete(' '), cli)

end
