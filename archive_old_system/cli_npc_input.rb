# The CLI input module for Amar Tools

def npc_input
  # Clear screen before starting input
  system("clear") || system("cls")  # Works on both Unix and Windows

  prompt = TTY::Prompt.new

  # Get the character's name
  name = prompt.ask("\nEnter the NPC's name:".c(@n))

  # Get the type
  i = 1
  tmp = Array.new
  tmp[0] = ""
  $Chartype.each_key do |key|
    tmp[i] = key
    i += 1
  end
  tmp.sort!
  i = 1
  puts
  while tmp[i]
    print "#{i}: #{tmp[i]}".ljust(25).c(@n)
    print "\n" if i % 3 == 0
    i += 1
  end
  puts
  while t = prompt.ask("\nEnter the NPC's type/profession (enter the number):".c(@n)).to_i
    if t == 0
      type = ""
      break
    elsif (1...tmp.length) === t
      type = tmp[t]
      break  
    else 
      puts "\nInvalid entry!".c(@red)
    end
  end

  # Get the level
  puts "\n1: Untrained   2: Trained some   3: Trained   4: Well trained   5: Master".c(@n)
  while level = prompt.ask("Enter the NPC's level (enter the number):".c(@n)).to_i
    if (0..8) === level
      break  
    else 
      puts "\nInvalid entry!".c(@red)
    end
  end

  # Get the area of residence
  puts "\n1: Amaronir     2: Merisir      3: Calaronir      4: Feronir".c(@n)
  puts "5: Alerisir     6: Rauinir      7: Outskirts".c(@n)
  while a = prompt.ask("Enter the NPC's recident area:".c(@n)).to_i
    if (0..7) === a
      break  
    else 
      puts "\nInvalid entry!".c(@red)
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
  while sex = prompt.ask("\nEnter the NPC's sex (M/F):".c(@n))
    if sex == "" || sex == "M" || sex == "F"
      break  
    else
      puts "\nInvalid entry!".c(@red)
    end
  end

  # And then the age
  age = prompt.ask("\nEnter the NPC's age:".c(@n)).to_i

  # The height of the character
  height = prompt.ask("\nEnter the NPC's height (in centimeters):".c(@n)).to_i
  
  # And the character's weight
  weight = prompt.ask("\nEnter the NPC's weight in kilograms (will be adjusted based on the NPC's strength):".c(@n)).to_i

  # Get description
  description = prompt.ask("\nEnter description of the NPC:".c(@n))

  puts "\n"

  return name, type, level, area, sex, age, height, weight, description

end
