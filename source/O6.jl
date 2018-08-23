# This is the Julia version of the Open Ended D6 rolls used in the Amar RPG
# See http://d6gaming.org for details about the Amar Role-Playing Game system


function D(x)
    rand(1:x)
end

m = true; mark = ""; d = D(6); t = D(6)
if d == 1
	while t < 4
		if t == 1 && !m; m = true
		elseif t == 1 && m; mark = " fumble"
		else; m = false
		end
		d -= 1
		t = D(6)
	end
end
if d == 6
	while t > 3
		if t == 6 && !m; m = true
		elseif t == 6 && m; mark = " critical"
		else; m = false
		end
		d += 1
		t = D(6)
	end
end
println("$d $mark")
