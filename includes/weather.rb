class Weather_day

	attr_reader :weather, :wind, :wind_dir, :wind_str, :special, :moon
	attr_writer :special, :moon

	def initialize
		if rand(3) != 0
			$weather_n = ($weather_n + oD6 + oD6 - 7).abs % 41
			$weather_n = 40 - $weather_n if $weather_n > 20
		end
		if rand(2) != 0
			$wind_dir_n = ($wind_dir_n + (oD6 + oD6 - 7)/3) % 8
		end
		if rand(3) != 0
			$wind_str_n = ($wind_str_n + (oD6 + oD6 - 6)/6).abs % 4
		end
		
		$weather_n = 1 if $weather_n == 0
		@weather  = $weather_n
		@wind_dir = $wind_dir_n
		@wind_str = $wind_str_n
		@wind     = (@wind_dir + 1) + ((@wind_str - 1) * 8)
		@wind     = 0 if @wind_str == 0

		@special  = ""
		@moon     = ""
	end
end


class Weather_month

	attr_reader :day, :name

	def initialize(month, weather, wind)

		$month_n = $Month.index(month)
		@name    = month
		
		$weather_n  = weather.to_i
		$wind_str_n = ((wind.to_i) / 8).ceil
		$wind_dir_n = (wind.to_i) % 8
		
		@day = []
		28.times do |d|
			@day[d] = Weather_day.new
		end

		case @name
			when 1
				@day[0].special = "Walmaer"
				@day[8].special = "Cal Amae"
			when 2
				@day[1].special = "Elesi"
			when 3
				@day[3].special = "Anashina"
				@day[14].special = "Ish Nakil"
				@day[17].special = "Fenimaal"
				@day[20].special = "Fionella"
			when 4
				@day[7].special = "Alesia"
				@day[11].special = "Gwendyll"
			when 5
				@day[12].special = "MacGillan"
			when 6
				@day[9].special = "Juba"
			when 7
				@day[10].special = "Taroc"
				@day[14].special = "Ikalio"
			when 8
				@day[3].special = "Man Peggon"
			when 9
				@day[0].special = "Maleko"
			when 10
				@day[6].special = "Fal Munir"
				@day[20].special = "Shalissa"
			when 11
				@day[2].special = "Moltan"
			when 12
				@day[7].special = "Kraagh"
			when 13
				@day[5].special = "Mestronorpha"
				@day[27].special = "Ielina"
		end

		if @name != ""
			@day[0].moon  = 0
			@day[7].moon  = 1
			@day[14].moon = 2
			@day[21].moon = 3
		end

	end
end
