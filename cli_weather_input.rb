# The town input module for CLI NPCg
  
def weather_input

  # Get Month
	month = 0
	mstring = ""
	7.times do |i|
		mstring += "#{i}: #{$Month[i]}".ljust(20)
		mstring += "#{i+7}: #{$Month[i+7]}".ljust(20)
		mstring += "\n"
	end
 	puts "\nEnter month (default=0):"
	puts mstring	
  print "> "
	month = gets.chomp.to_i
	month = 0 if month < 0
	month = month % 14

  # Get previous weather
	weather = 0
 	puts "\nEnter previous weather (default=0):"
	$Weather.each_with_index {|w,i| puts "#{i.to_s.rjust(2)}: #{w}" }
  print "> "
	weather = gets.chomp.to_i
	weather = 0 if weather < 0
	weather = weather % 21

  # Get previous wind direction
	wind_dir = 0
 	puts "\nEnter previous wind direction (default=0):"
	4.times do |i|
		puts "#{(i*2).to_s.rjust(2)}: #{$Wind_dir[i*2].ljust(2)}   #{(i*2+1).to_s.rjust(2)}: #{$Wind_dir[i*2+1].ljust(2)}"
	end
  print "> "
	wind_dir = gets.chomp.to_i
	wind_dir = 0 if wind_dir < 0
	wind_dir = wind_dir % 8

  # Get previous weather
	wind_str = 0
 	puts "\nEnter previous wind strength (default=0):"
	$Wind_str.each_with_index {|w,i| puts "#{i.to_s.rjust(2)}: #{w}" }
  print "> "
	wind_str = gets.chomp.to_i
	wind_str = 0 if wind_str < 0
	wind_str = wind_str % 4

	return month, weather, wind_dir, wind_str

end
