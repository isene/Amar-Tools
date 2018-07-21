class Weather_day

	attr_reader :weather, :wind_dir, :wind_str, :wind, :special
	attr_writer :weather, :wind_dir, :wind_str, :wind, :special

	def initialize(weather, wind_dir, wind_str, month, day)
		if rand(2) == 0
			weather = (weather + oD6 + oD6 - 7).abs % 41
			weather += 4 if month == 1 and rand(3) == 0			# Walmaer
			weather -= 4 if month == 6 and rand(3) == 0			# Juba
			weather -= 4 if month == 8 and rand(3) == 0			# Man Peggon
			weather += 6 if month == 13 and rand(3) == 0		# Mestronorpha
			weather = 40 - weather if weather > 20
		end
		weather -= 1 if month == 7												# Taroc
		weather = 1 if month == 7 and day == 14						# Ikalio day
		weather = 1 if month == 13 and day == 27					# Ielina day
		if rand(2) == 0
			wind_dir = (wind_dir + (oD6 + oD6 - 7)/3) % 8
		end
		if rand(2) == 0
			wind_str = (wind_str + (oD6 + oD6 - 7)/6).abs
			wind_str += 1 if month == 1 and rand(3) == 0		# Walmaer
			wind_str += 1 if month == 10										# Fal Munir
			wind_str = 3 if wind_str > 3
		end
		wind_str = 3 if month == 10 and day == 20					# Shalissa day

		weather = 1 if weather == 0
		@weather   = weather
		@wind_dir  = wind_dir
		@wind_str  = wind_str
		@wind      = (wind_dir + 1) + ((wind_str - 1) * 8)
		@wind      = 0 if wind_str == 0
		@special   = ""
	end
end


class Weather_month

	attr_reader :day, :month_n

	def initialize(month, weather, wind)

		@month_n    = month
		
		@weather_n  = weather.to_i
		@wind_str_n = ((wind.to_i) / 8).ceil
		@wind_dir_n = (wind.to_i) % 8
		
		@day = []
		28.times do |d|
			@day[d] = Weather_day.new(@weather_n, @wind_dir_n, @wind_str_n, @month_n, d)
			@weather_n = @day[d].weather
			@wind_dir_n = @day[d].wind_dir
			@wind_str_n = @day[d].wind_str
		end

		case @month_n
			when 1
				@day[0].special  = "Walmaer"
				@day[8].special  = "Cal Amae"
			when 2
				@day[1].special  = "Elesi"
			when 3
				@day[3].special  = "Anashina"
				@day[14].special = "Ish Nakil"
				@day[17].special = "Fenimaal"
				@day[20].special = "Fionella"
			when 4
				@day[7].special  = "Alesia"
				@day[11].special = "Gwendyll"
			when 5
				@day[12].special = "MacGillan"
			when 6
				@day[9].special  = "Juba"
			when 7
				@day[10].special = "Taroc"
				@day[14].special = "Ikalio"
			when 8
				@day[3].special  = "Man Peggon"
			when 9
				@day[0].special  = "Maleko"
			when 10
				@day[6].special  = "Fal Munir"
				@day[20].special = "Shalissa"
			when 11
				@day[2].special  = "Moltan"
			when 12
				@day[7].special  = "Kraagh"
			when 13
				@day[5].special  = "Mestronorpha"
				@day[27].special = "Ielina"
		end
	end
end
