# This is the Ruby version of the Open Ended D6 rolls used in the Amar RPG
# See http://d6gaming.org for details about the Amar Role-Playing Game system

def d6
	return rand(1..6)
end

def o6
	m = true ; mark = "" ; t = d6
	d = d6

	if d == 1
		while t < 4
			d -= 1
			t == 1 ? m == true ? mark = " fumble" : m = true : m = false
			t = d6
		end
	end

	if d == 6
		while t > 3
			d += 1
			t == 6 ? m == true ? mark = " critical" : m = true : m = false
			t = d6
		end
	end

	puts "#{d.to_s}#{mark}"
end

o6
