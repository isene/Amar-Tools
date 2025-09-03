# The CLI encounter input module for Amar Tools
  
def enc_input

  prompt = TTY::Prompt.new

  # Get night/day
  c = prompt.ask("\nEnter night (0) or day (1) [Default = #{$Day}]:".c(@e))
	if c == "0"
		$Day = 0
	elsif c == "1"
		$Day = 1
  else
	end

  # Get the terrain
  puts "\n0: City   1: Rural   2: Road   3: Plains   4: Hills   5: Mountains   6: Woods   7: Wilderness".c(@e)
  c = prompt.ask("Enter the tarrain type [Default = #{$Terrain}]:".c(@e))
	if c == ""
	elsif (0..7) === c.to_i
		$Terrain = c.to_i
	end

  $Terraintype = $Terrain + (8 * $Day)

  # Get level modifier
  c = prompt.ask("\nEnter level modifier (+/-) [Default = #{$Level}]:".c(@e))
	if c != ""
		$Level = c.to_i
	end

	encounter = ""

  # Get a specific encounter
  i = 1
  tmp = Array.new
  tmp[0] = ""
  $Encounters.each_key do |key|
    tmp[i] = key
    i += 1
  end
  tmp.sort!
  i = 1
  puts
  while tmp[i]
    print "#{i}: #{tmp[i]}".ljust(30).c(@e)
    print "\n" if i % 3 == 0
    i += 1
  end
  puts
  while t = prompt.ask("\n\nEnter a specific encounter (enter the number) or press ENTER for random encounter:".c(@e)).to_i
    if t == 0
      encounter = ""
      break
    elsif (1...tmp.length) === t
      encounter = tmp[t]
      break
    else
      puts "\nInvalid entry!".c(@red)
    end
  end

	enc_number = 0
  enc_number = prompt.ask("\nEnter the number of encounters or press ENTER for random number of encounters:".c(@e)).to_i if encounter != ""

	return encounter, enc_number

end
