# Input module for new encounter system

def enc_input_new
  prompt = TTY::Prompt.new
  
  puts "\n" + "=" * 60
  puts "NEW SYSTEM ENCOUNTER GENERATION"
  puts "=" * 60
  
  # Get night/day
  $Day = 1 if $Day.nil?  # Default to day
  day_choice = prompt.ask("\nEnter night (0) or day (1) [Default = #{$Day}]:".c(@e))
  if day_choice == "0"
    $Day = 0
  elsif day_choice == "1"
    $Day = 1
  end
  
  # Get the terrain
  $Terrain = 1 if $Terrain.nil?  # Default to Rural
  puts "\n0: City   1: Rural   2: Road   3: Plains   4: Hills   5: Mountains   6: Woods   7: Wilderness".c(@e)
  terrain_choice = prompt.ask("Enter the terrain type [Default = #{$Terrain}]:".c(@e))
  if terrain_choice != "" && (0..7) === terrain_choice.to_i
    $Terrain = terrain_choice.to_i
  end
  
  # Calculate terrain type (includes day/night)
  $Terraintype = $Terrain + (8 * $Day)
  
  # Get level modifier
  $Level = 0 if $Level.nil?
  level_mod = prompt.ask("\nEnter level modifier (+/-) [Default = #{$Level}]:".c(@e))
  if level_mod != ""
    $Level = level_mod.to_i
  end
  
  # Get specific encounter or random
  encounter = ""
  enc_number = 0
  
  # Load encounter tables if not loaded
  unless defined?($Encounters)
    load File.join($pgmdir, "includes/tables/encounters.rb")
  end
  
  # Display encounter options
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
  
  # Get number of encounters if specific
  if encounter != ""
    enc_number = prompt.ask("\nEnter the number of encounters or press ENTER for random number:".c(@e)).to_i
  end
  
  return encounter, enc_number, $Terraintype, $Level
end