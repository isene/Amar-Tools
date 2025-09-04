# Input module for new encounter system
require 'tty-prompt'

def enc_input_new
  # Clear screen
  system("clear") || system("cls")
  
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
  
  # Race selection (after terrain so user knows the context)
  races = [
    "Human", "Elf", "Half-elf", "Dwarf", "Goblin", "Lizard Man",
    "Centaur", "Ogre", "Troll", "Araxi", "Faerie"
  ]
  
  puts "\nSelect Race (for humanoid encounters):"
  puts "0: Random (default)"
  races.each_with_index do |race, index|
    puts "#{index + 1}: #{race}"
  end
  
  race = ""
  race_input = prompt.ask("\nEnter race number (0 or blank for random):").to_i
  if race_input > 0 && race_input <= races.length
    race = races[race_input - 1]
    puts "Selected race: #{race}"
  else
    puts "Random race will be selected based on encounter"
  end
  
  # Get specific encounter or random
  encounter = ""
  enc_number = 0
  
  # Load encounter tables if not loaded
  unless defined?($Encounters)
    load File.join($pgmdir, "includes/tables/encounters.rb")
  end
  
  # Filter encounter options based on race
  i = 1
  tmp = Array.new
  tmp[0] = ""
  
  if race != "" && race != "Human"
    # For non-human races, only show generic profession types (not race-specific)
    # Skip animals, monsters, and other races
    $Encounters.each_key do |key|
      # Include only generic humanoid professions (no race prefix, no monsters/animals)
      if !key.match?(/animal:|monster:|event:/i) && 
         !key.match?(/elf|dwarf|araxi|troll|ogre|lizard|goblin|centaur|faer/i)
        tmp[i] = key
        i += 1
      end
    end
  elsif race == "Human"
    # For humans, show all non-monster/animal encounters except other races
    $Encounters.each_key do |key|
      if !key.match?(/animal:|monster:|event:/i)
        tmp[i] = key
        i += 1
      end
    end
  else
    # Show all encounters if no race selected
    $Encounters.each_key do |key|
      tmp[i] = key
      i += 1
    end
  end
  
  tmp.sort!
  i = 1
  puts "\nAvailable encounters#{race != '' ? ' for ' + race : ''}:"
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
  
  # If race was selected and encounter is specific, prepend race if needed
  if race != "" && race != "Human" && encounter != "" && !encounter.include?(":")
    # Check if this is a humanoid encounter that should have race prefix
    unless encounter.match?(/animal:|monster:|event:/i)
      # This will signal the encounter generator to use this race
      encounter = "#{race}: #{encounter}"
    end
  end
  
  return encounter, enc_number, $Terraintype, $Level
end