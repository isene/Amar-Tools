# The input module for CLI NPCg
  

def npc_input

  # Get the character's name
  puts "\nEnter the NPC's name:"
  print "> "
  name = gets.chomp.to_s

  # Get the type
  #load "tables/chartype.rb"
  puts "\nEnter the NPC's type (enter the number):"
  i = 1
  tmp = Array.new
  tmp[0] = ""
  $Chartype.each_key do |key|
    tmp[i] = key
    i += 1
  end
  tmp.sort!
  i = 1
  while tmp[i]
    print "#{i}: #{tmp[i]}".ljust(25)
    print "\n" if i % 3 == 0
    i += 1
  end
  print "\n> "
  while t = gets.chomp.to_i
    if t == 0
      type = ""
      break
    elsif (1...tmp.length) === t
      type = tmp[t]
      break  
    else 
      puts "\nInvalid entry!"
      puts "Enter the NPC's type/profession (enter the number):"
      print "> "
    end
  end

  # Get the level
  puts "\nEnter the NPC's level (enter the number):"
  puts "1: Untrained   2: Trained some   3: Trained   4: Well trained   5: Master"
  print "> "
  while level = gets.chomp.to_i
    if (0..8) === level
      break  
    else 
      puts "\nInvalid entry!"
      puts "Enter the NPC's level (1-5):"
      print "> "
    end
  end

  # Get the area of residence
  puts "\nEnter the NPC's recident area:"
  puts "1: Amaronir     2: Merisir      3: Calaronir      4: Feronir"
  puts "5: Alerisir     6: Rauinir      7: Outskirts"
  print "> "
  while a = gets.chomp.to_i 
    if (0..7) === a
      break  
    else 
      puts "\nInvalid entry!"
      puts "Enter the NPC's recident area:"
      print "> "
    end
  end
  case a
    when 0
      area = ""
    when 1
      area = "Amaronir "
    when 2
      area = "Merisir  "
    when 3
      area = "Calaronir"
    when 4
      area = "Feronir  "
    when 5
      area = "Alerisir "
    when 6
      area = "Rauinir  "
    when 7
      area = "Outskirts"
  end

  # Get the sex
  puts "\nEnter the NPC's sex (M/F):"
  print "> "
  while sex = gets.chomp 
    if sex == "" || sex == "M" || sex == "F"
      break  
    else
      puts "\nInvalid entry!"
      puts "Enter the NPC's sex (M/F):"
      print "> "
    end
  end

  # And then the age
  puts "\nEnter the NPC's age:"
  print "> "
  age = gets.chomp.to_i

  # The height of the character
  puts "\nEnter the NPC's height (in centimeters):"
  print "> "
  height = gets.chomp.to_i
  
  # And the character's weight
  puts "\nEnter the NPC's weight (in kilograms):"
  puts "PS: The weight will be adjusted based on the npc's strength."
  print "> "
  weight = gets.chomp.to_i 

  # Get description
  puts "\nEnter description of the NPC:"
  print "> "
  description = gets.chomp

  puts "\n"

  return name, type, level, area, sex, age, height, weight, description

end
