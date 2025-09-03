#!/usr/bin/ruby
# Script to ensure all character type base values are balanced
# so that totals naturally cannot exceed 18

# Maximum values for natural balance
MAX_CHAR = 3      # Characteristic base max
MAX_ATTR = 4      # Attribute base max  
MAX_SKILL = 3     # Skill base max
MAX_WEAPON = 3    # Weapon skill base max

# Read the current file
file_path = "includes/tables/chartype_new.rb"
content = File.read(file_path)

# Apply conservative limits
content.gsub!(/("characteristics" => \{[^}]+\})/m) do |match|
  match.gsub(/=> (\d+)/) do |num_match|
    value = $1.to_i
    value = MAX_CHAR if value > MAX_CHAR
    "=> #{value}"
  end
end

content.gsub!(/("attributes" => \{[^}]+\})/m) do |match|
  match.gsub(/=> (\d+)/) do |num_match|
    value = $1.to_i
    value = MAX_ATTR if value > MAX_ATTR
    "=> #{value}"
  end
end

content.gsub!(/("skills" => \{[^}]+\})/m) do |match|
  match.gsub(/=> (\d+)/) do |num_match|
    value = $1.to_i
    value = MAX_SKILL if value > MAX_SKILL
    "=> #{value}"
  end
end

content.gsub!(/("melee_weapons" => \{[^}]+\})/m) do |match|
  match.gsub(/=> (\d+)/) do |num_match|
    value = $1.to_i
    value = MAX_WEAPON if value > MAX_WEAPON
    "=> #{value}"
  end
end

content.gsub!(/("missile_weapons" => \{[^}]+\})/m) do |match|
  match.gsub(/=> (\d+)/) do |num_match|
    value = $1.to_i
    value = MAX_WEAPON if value > MAX_WEAPON
    "=> #{value}"
  end
end

# Write back
File.write(file_path, content)

puts "Character type values have been balanced."
puts "Maximum base values enforced:"
puts "  Characteristics: #{MAX_CHAR}"
puts "  Attributes: #{MAX_ATTR}"
puts "  Skills: #{MAX_SKILL}"
puts "  Weapons: #{MAX_WEAPON}"