# Input module for new 3-tier NPC system

def npc_input_new
  # Clear screen before starting input
  system("clear") || system("cls")  # Works on both Unix and Windows
  
  prompt = TTY::Prompt.new
  
  puts "\n" + "=" * 60
  puts "NEW SYSTEM NPC GENERATION (3-Tier)"
  puts "=" * 60
  
  # Name input
  name = prompt.ask("Enter NPC name (or leave blank for random):") || ""
  
  # Type selection with numbered list (like old system)
  types = $ChartypeNew.keys.sort
  puts "\nCharacter Types (#{types.length} available):"
  puts "0: Random"
  
  # Display types in 3 columns
  types.each_with_index do |type_name, index|
    number = index + 1
    print "#{number.to_s.rjust(2)}: #{type_name}".ljust(25)
    print "\n" if number % 3 == 0
  end
  puts "\n" if types.length % 3 != 0
  
  # Get user input with validation
  type = ""
  while true
    begin
      input = prompt.ask("\nEnter character type number (0 for random):").to_i
      if input == 0
        type = ""
        break
      elsif input >= 1 && input <= types.length
        type = types[input - 1]
        puts "Selected: #{type}"
        break
      else
        puts "\nInvalid entry! Please enter a number between 0 and #{types.length}."
      end
    rescue
      puts "\nInvalid entry! Please enter a valid number."
    end
  end
  
  # Level input
  level_choices = {
    "Random" => 0,
    "Novice (1)" => 1,
    "Apprentice (2)" => 2,
    "Journeyman (3)" => 3,
    "Expert (4)" => 4,
    "Master (5)" => 5,
    "Grandmaster (6)" => 6
  }
  level = prompt.select("Select character level:", level_choices)
  
  # Area selection
  area_choices = {
    "Random" => "",
    "Amaronir" => "Amaronir",
    "Merisir" => "Merisir",
    "Calaronir" => "Calaronir",
    "Feronir" => "Feronir",
    "Aleresir" => "Aleresir",
    "Rauinir" => "Rauinir",
    "Outskirts" => "Outskirts",
    "Other" => "Other"
  }
  area = prompt.select("Select area of origin:", area_choices)
  
  # Sex selection
  sex_choices = {
    "Random" => "",
    "Male" => "M",
    "Female" => "F"
  }
  sex = prompt.select("Select sex:", sex_choices)
  
  # Age input
  age = prompt.ask("Enter age (or 0 for random):", convert: :int) || 0
  
  # Physical attributes
  height = prompt.ask("Enter height in cm (or 0 for random):", convert: :int) || 0
  weight = prompt.ask("Enter weight in kg (or 0 for random):", convert: :int) || 0
  
  # Description
  description = prompt.ask("Enter description (optional):") || ""
  
  return [name, type, level, area, sex, age, height, weight, description]
end