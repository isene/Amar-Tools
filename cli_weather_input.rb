# The town input module for CLI NPCg
  
def weather_input

  # Get Month
	mstring = ""
	7.times do |i|
		mstring += "#{i}: #{$Month[i]}".ljust(20)
		mstring += "#{i+7}: #{$Month[i+7]}".ljust(20)
		mstring += "\n"
	end
 	puts "\nEnter month (default=#{$mn}):"
	puts mstring	
  print "> "
	month = gets.chomp
	month = $mn if month == ""
	month = month.to_i
	month = 0 if month < 0
	month = month % 14

  # Get previous weather
 	puts "\nEnter previous weather (default=#{$weather_n}):"
	$Weather[1..-1].each_with_index {|w,i| puts "#{(i+1).to_s.rjust(2)}: #{w}" }
  print "> "
	weather = gets.chomp
	weather = $weather_n if weather == ""
	weather = weather.to_i
	weather = 1 if weather < 0

  # Get previous wind direction
 	puts "\nEnter previous wind direction (default=#{$wind_dir_n}):"
	4.times do |i|
		puts "#{(i*2).to_s.rjust(2)}: #{$Wind_dir[i*2].ljust(2)}   #{(i*2+1).to_s.rjust(2)}: #{$Wind_dir[i*2+1].ljust(2)}"
	end
  print "> "
	wind_dir = gets.chomp
	wind_dir = $wind_dir_n if wind_dir == ""
	wind_dir = wind_dir.to_i
	wind_dir = 0 if wind_dir < 0
	wind_dir = wind_dir % 8

  # Get previous weather
 	puts "\nEnter previous wind strength (default=#{$wind_str_n}):"
	$Wind_str.each_with_index {|w,i| puts "#{i.to_s.rjust(2)}: #{w}" }
  print "> "
	wind_str = gets.chomp
	wind_str = $wind_str_n if wind_str == ""
	wind_str = wind_str.to_i
	wind_str = 0 if wind_str < 0
	wind_str = wind_str % 4

	return month, weather, wind_dir, wind_str

end
