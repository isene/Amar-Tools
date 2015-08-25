# The encounter input module for CLI NPCg
  
def enc_input

  # Get night/day
	puts "\nEnter night (0) or day (1) [Default = #{$Day}]"
  print "> "
	c = gets.chomp
	if c == "0"
		$Day = 0
	elsif c == "1" 
		$Day = 1
	end

  # Get the terrain
	puts "\nEnter the tarrain type [Default = #{$Terrain}]:"
	puts "0: City   1: Rural   2: Road   3:Plains   4: Hills   5: Mountains   6:Woods   7: Wilderness"
  print "> "
	c = gets.chomp
	if c == ""
	elsif (0..7) === c.to_i
		$Terrain = c.to_i
	end

  $Terraintype = $Terrain + (8 * $Day)

  # Get level modifier
	puts "\nEnter level modifier (+/-) [Default = #{$Level}]:"
  print "> "
	c = gets.chomp
	if c != ""
		$Level = c.to_i
	end

	encounter = ""

  # Get a specific encounter
  puts "\nEnter a specific encounter (enter the number) or press ENTER for random encounter:"
  i = 1
  tmp = Array.new
  tmp[0] = ""
  $Encounters.each_key do |key|
    tmp[i] = key
    i += 1
  end
  tmp.sort!
  i = 1
  while tmp[i]
    print "#{i}: #{tmp[i]}".ljust(30)
    print "\n" if i % 3 == 0
    i += 1
  end
  print "\n> "
  while t = gets.chomp.to_i
    if t == 0
      encounter = ""
      break
    elsif (1...tmp.length) === t
      encounter = tmp[t]
      break
    else
      puts "\nInvalid entry!"
      puts "Enter a specific encounter (enter the number) or press ENTER for random encounter:"
      print "> "
    end
  end

	enc_number = 0

	if encounter != ""
  	puts "\nEnter the number of encounters or press ENTER for random number of encounters:"
    print "> "
		enc_number = gets.chomp.to_i
  end

	return encounter, enc_number

end
