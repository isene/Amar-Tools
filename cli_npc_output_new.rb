# Compact output module for new 3-tier NPC system with full details
require 'io/console'

# Try to load string_extensions for color support
begin
  require 'string_extensions'
rescue LoadError
  # Define a fallback pure method if string_extensions is not available
  class String
    def pure
      self.gsub(/\e\[[0-9;]*m/, '')
    end
  end
end

def npc_output_new(n, cli, custom_width = nil)
  # Clear screen before displaying character (only for true CLI mode)
  if cli == "cli_direct"
    system("clear") || system("cls")  # Works on both Unix and Windows
  end

  f = ""

  # Use UTF-8 box drawing characters (no side borders for easy copy-paste)
  # Adjust width based on output mode
  if custom_width
    width = custom_width
  elsif cli == "cli_direct"
    width = 120
  else
    width = 80  # Default for other modes
  end
  
  # Define colors if terminal output
  if cli == "cli"
    # Colors for different elements
    @header_color = "\e[1;36m"  # Bright cyan
    @char_color = "\e[1;33m"     # Bright yellow
    @attr_color = "\e[1;35m"     # Bright magenta
    @skill_color = "\e[0;37m"    # White
    @stat_color = "\e[1;32m"     # Bright green
    @weapon_color = "\e[38;5;202m"   # Brighter red (202)
    @spell_color = "\e[0;34m"    # Blue
    @desc_color = "\e[38;5;229m"  # Light color for description
    @reset = "\e[0m"
  else
    @header_color = @char_color = @attr_color = @skill_color = ""
    @stat_color = @weapon_color = @spell_color = @desc_color = @reset = ""
  end
  
  # Compact header: Name (sex age) H/W: height/weight with right-justified type
  name_hw_part = "#{n.name} (#{n.sex} #{n.age}) H/W: #{n.height}cm/#{n.weight}kg"
  type_part = "#{n.type} (#{n.level})"
  spaces_needed = width - name_hw_part.length - type_part.length
  f += "#{@header_color}#{name_hw_part}#{' ' * spaces_needed}#{type_part}#{@reset}\n"
  
  # Area and Social Status on same line, with status right-justified
  social_status = generate_social_status(n.type, n.level)
  area_part = "Area: #{n.area}"
  status_part = "Social Status: #{social_status}"
  spaces_needed = width - area_part.length - status_part.length
  f += "#{area_part}#{' ' * spaces_needed}#{status_part}\n"


  # Add religion line for priests and anyone with Attunement
  attunement_level = 0
  if n.tiers && n.tiers["SPIRIT"] && n.tiers["SPIRIT"]["Attunement"]
    attunement_level = n.tiers["SPIRIT"]["Attunement"]["level"] || 0
  end
  
  # Check if NPC should have religion info (skip for monsters)
  is_humanoid = !n.type.to_s.match(/Monster:|Animal:|monster/i)
  if is_humanoid && (["Priest", "Clergyman", "Monk"].include?(n.type) || (n.respond_to?(:has_magic?) && n.has_magic?) || attunement_level > 0)
    cult_info = generate_cult_info(n.type, n.level, attunement_level, n.sex)
    f += "#{cult_info}\n" if cult_info
  end
  
  # Add description line with correct light color (229)
  description = n.description && !n.description.empty? ? n.description : generate_description(n.type, n.level, n.sex)
  if cli == "cli"
    f += "#{@desc_color}Description: #{description}#{@reset}\n"
  else
    f += "Description: #{description}\n"
  end
  f += "─" * width + "\n"
  
  # Three-column layout for skills
  col_width = 40
  columns = [[], [], []]
  
  # BODY hierarchy with non-zero skills
  body_char = n.get_characteristic('BODY')
  body_lines = ["#{@char_color}BODY (#{body_char.to_s.rjust(2)})#{@reset}"]
  n.tiers["BODY"].each do |attr_name, attr_data|
    # Skip if attr_data is not a hash or doesn't have skills
    next unless attr_data.is_a?(Hash) && attr_data["skills"].is_a?(Hash)
    
    non_zero_skills = attr_data["skills"].select { |_, v| v > 0 }
    next if non_zero_skills.empty?
    
    attr_level = attr_data["level"]
    body_lines << " #{@attr_color}#{attr_name} (#{attr_level.to_s.rjust(2)})#{@reset}"
    non_zero_skills.each do |skill_name, skill_level|
      total = body_char + attr_level + skill_level
      skill_display = "  #{skill_name} (#{skill_level.to_s.rjust(2)})"
      body_lines << "#{@skill_color}#{skill_display.ljust(30)}: #{total.to_s.rjust(2)}#{@reset}"
    end
  end
  
  # MIND hierarchy with non-zero skills
  mind_char = n.get_characteristic('MIND')
  mind_lines = ["#{@char_color}MIND (#{mind_char.to_s.rjust(2)})#{@reset}"]
  n.tiers["MIND"].each do |attr_name, attr_data|
    # Skip if attr_data is not a hash or doesn't have skills
    next unless attr_data.is_a?(Hash) && attr_data["skills"].is_a?(Hash)
    
    non_zero_skills = attr_data["skills"].select { |_, v| v > 0 }
    next if non_zero_skills.empty?
    
    attr_level = attr_data["level"]
    mind_lines << " #{@attr_color}#{attr_name} (#{attr_level.to_s.rjust(2)})#{@reset}"
    non_zero_skills.each do |skill_name, skill_level|
      total = mind_char + attr_level + skill_level
      skill_display = "  #{skill_name} (#{skill_level.to_s.rjust(2)})"
      mind_lines << "#{@skill_color}#{skill_display.ljust(30)}: #{total.to_s.rjust(2)}#{@reset}"
    end
  end
  
  # SPIRIT hierarchy with non-zero skills
  spirit_char = n.get_characteristic("SPIRIT")
  spirit_lines = []
  spirit_attrs_with_skills = n.tiers["SPIRIT"].select do |_, attr_data|
    attr_data.is_a?(Hash) && attr_data["skills"].is_a?(Hash) && attr_data["skills"].any? { |_, v| v > 0 }
  end
  
  if !spirit_attrs_with_skills.empty?
    spirit_lines << "#{@char_color}SPIRIT (#{spirit_char.to_s.rjust(2)})#{@reset}"
    n.tiers["SPIRIT"].each do |attr_name, attr_data|
      # Skip if attr_data is not a hash or doesn't have skills
      next unless attr_data.is_a?(Hash) && attr_data["skills"].is_a?(Hash)
      
      non_zero_skills = attr_data["skills"].select { |_, v| v > 0 }
      next if non_zero_skills.empty?
      
      attr_level = attr_data["level"]
      spirit_lines << " #{@attr_color}#{attr_name} (#{attr_level.to_s.rjust(2)})#{@reset}"
      non_zero_skills.each do |skill_name, skill_level|
        total = spirit_char + attr_level + skill_level
        skill_display = "  #{skill_name} (#{skill_level.to_s.rjust(2)})"
        spirit_lines << "#{@skill_color}#{skill_display.ljust(30)}: #{total.to_s.rjust(2)}#{@reset}"
      end
    end
  end
  
  # Distribute content across three columns more evenly
  all_lines = []
  all_lines.concat(body_lines) unless body_lines.length == 1
  all_lines.concat(mind_lines) unless mind_lines.length == 1
  all_lines.concat(spirit_lines) unless spirit_lines.empty?
  
  # Calculate lines per column for even distribution
  total_lines = all_lines.length
  lines_per_col = (total_lines / 3.0).ceil
  
  # Fill columns
  all_lines.each_with_index do |line, idx|
    col_idx = idx / lines_per_col
    col_idx = 2 if col_idx > 2
    columns[col_idx] << line
  end
  
  # Balance columns
  max_lines = columns.map(&:length).max
  columns.each { |col| col.concat([""] * (max_lines - col.length)) }
  
  # Print three columns with vertical separators
  max_lines.times do |i|
    line = ""
    columns.each_with_index do |col, idx|
      # Strip color codes for length calculation
      plain_text = col[i].to_s.gsub(/\e\[[0-9;]*m/, '')
      padding = col_width - plain_text.length
      line += col[i].to_s + " " * padding
      line += "│" if idx < 2
    end
    f += line.rstrip + "\n"
  end
  
  # Stats line
  f += "─" * width + "\n"
  
  # Calculate proper encumbrance based on weight carried
  total_weight = calculate_total_weight(n)
  
  # Calculate carrying capacity based on Strength
  strength = n.tiers["BODY"]["Strength"]["level"] || 2
  base_capacity = strength * 5  # Base carrying capacity in kg
  
  # Calculate ENC penalty based on Amar rules
  enc_penalty = if total_weight <= base_capacity
    0  # No penalty under normal load
  elsif total_weight <= base_capacity * 2
    -1  # Light encumbrance
  elsif total_weight <= base_capacity * 5
    -3  # Medium encumbrance
  elsif total_weight <= base_capacity * 10
    -5  # Heavy encumbrance
  else
    -7  # Extreme encumbrance (not -10)
  end
  
  # Format SIZE for display (3.5 becomes "3½")
  size_display = n.SIZE % 1 == 0.5 ? "#{n.SIZE.floor}½" : n.SIZE.to_s
  # Calculate combat totals for the summary line
  dodge_total = n.get_skill_total("BODY", "Athletics", "Dodge") rescue 0
  reaction_total = n.get_skill_total("BODY", "Athletics", "Reaction Speed") rescue 0

  f += "#{@stat_color}SIZE: #{size_display}  BP:#{n.BP.to_s}  DB: #{n.DB.to_s}  MD: #{n.MD.to_s}  Reaction: #{reaction_total}  Dodge: #{dodge_total}   Carried: #{total_weight}kg  ENC: #{enc_penalty}#{@reset}\n"
  
  # Armor section - use original format if available
  f += "─" * width + "\n"
  if n.respond_to?(:armour) && !n.armour.to_s.empty?
    # Use original armor format
    f += "#{@weapon_color}ARMOR: #{n.armour.ljust(20)} AP: #{n.ap.to_s.rjust(2)}  Weight: #{get_armor_weight(n.armour).to_s.rjust(2)}kg#{@reset}\n"
  elsif n.armor && n.armor[:name] && !n.armor[:name].empty?
    # Fall back to new format
    f += "#{@weapon_color}ARMOR: #{n.armor[:name].ljust(20)} AP: #{n.armor[:ap].to_s.rjust(2)}  Weight: #{get_armor_weight(n.armor[:name]).to_s.rjust(2)}kg#{@reset}\n"
  else
    # No armor
    f += "#{@weapon_color}ARMOR: None                  AP:  0  Weight:  0kg#{@reset}\n"
  end
  
  # Check if we have original weapon data and display it
  # DISABLED: Old weapon format only shows 2-3 weapons, new format shows all skills
  if false && n.respond_to?(:melee1) && !n.melee1.to_s.empty?
    # Display ORIGINAL weapon format (DEPRECATED)
    f += "─" * width + "\n"
    f += "#{@weapon_color}WEAPON             SKILL    INI     OFF    DEF    DAM    HP    RANGE#{@reset}\n"

    # Melee weapon 1
    if n.melee1s && n.melee1s > 0
      f += "#{n.melee1.ljust(19)}"
      f += "#{n.melee1s.to_s.ljust(9)}"
      f += "#{n.melee1i.to_s.ljust(8)}"
      f += "#{n.melee1o.to_s.ljust(7)}"
      f += "#{n.melee1d.to_s.ljust(7)}"
      f += "#{n.melee1dam.to_s.ljust(7)}"
      f += "#{n.melee1hp.to_s.ljust(6)}"
      f += "\n"
    end

    # Melee weapon 2
    if n.respond_to?(:melee2s) && n.melee2s && n.melee2s > 0
      f += "#{n.melee2.ljust(19)}"
      f += "#{n.melee2s.to_s.ljust(9)}"
      f += "#{n.melee2i.to_s.ljust(8)}"
      f += "#{n.melee2o.to_s.ljust(7)}"
      f += "#{n.melee2d.to_s.ljust(7)}"
      f += "#{n.melee2dam.to_s.ljust(7)}"
      f += "#{n.melee2hp.to_s.ljust(6)}"
      f += "\n"
    end

    # Missile weapon
    if n.respond_to?(:missiles) && n.missiles && n.missiles > 0
      f += "#{n.missile.ljust(19)}"
      f += "#{n.missiles.to_s.ljust(9)}"
      f += "#{' '.ljust(8)}"  # No init for missile
      f += "#{n.missileo.to_s.ljust(7)}"
      f += "#{' '.ljust(7)}"  # No def for missile
      f += "#{n.missiledam.to_s.ljust(7)}"
      f += "#{n.melee1hp.to_s.ljust(6)}"  # Use melee1 HP as placeholder
      f += "#{n.missilerange}m"
      f += "\n"
    end
  else
    # 3-tier weapon display - show ALL weapon skills
    melee_weapons = n.tiers["BODY"]["Melee Combat"]["skills"].select { |_, v| v > 0 } rescue {}
    missile_weapons = n.tiers["BODY"]["Missile Combat"]["skills"].select { |_, v| v > 0 } rescue {}

  if melee_weapons.any? || missile_weapons.any?
    f += "─" * width + "\n"
    f += "#{@weapon_color}WEAPON             SKILL    INI     OFF    DEF    DAM    HP    RANGE#{@reset}\n"

    body_char = n.get_characteristic("BODY")

    # Calculate Dodge bonus for defense (Dodge/5 rounded down)
    dodge_total = n.get_skill_total("BODY", "Athletics", "Dodge") || 0
    dodge_bonus = (dodge_total / 5).to_i

    # Get reaction speed for initiative
    reaction_speed = n.get_skill_total("MIND", "Awareness", "Reaction speed") || 0

    # Display melee weapons
    melee_weapons.sort_by { |_, skill| -skill }.each do |weapon, skill|
      wpn_stats = get_weapon_stats(weapon)
      attr = n.get_attribute("BODY", "Melee Combat") || 0
      skill_total = body_char + attr + skill

      init = reaction_speed + (wpn_stats[:init] || 0)
      off = skill_total + (wpn_stats[:off] || 0)
      defense = skill_total + (wpn_stats[:def] || 0) + dodge_bonus
      dmg_mod = wpn_stats[:dmg].to_s =~ /special/ ? 0 : (wpn_stats[:dmg].to_s.to_i || 0)
      dmg = (n.DB || 0) + dmg_mod
      hp = wpn_stats[:hp] || 0

      f += "#{weapon.ljust(19)}"
      f += "#{skill_total.to_s.ljust(9)}"
      f += "#{init.to_s.ljust(8)}"
      f += "#{off.to_s.ljust(7)}"
      f += "#{defense.to_s.ljust(7)}"
      f += "#{dmg.to_s.ljust(7)}"
      f += "#{hp.to_s.ljust(6)}"
      f += "\n"
    end

    # Display missile weapons
    missile_weapons.sort_by { |_, skill| -skill }.each do |weapon, skill|
      wpn_stats = get_missile_stats(weapon)
      attr = n.get_attribute("BODY", "Missile Combat") || 0
      skill_total = body_char + attr + skill

      off = skill_total + (wpn_stats[:off] || 0)
      range = wpn_stats[:range] || "30m"
      dmg_mod = wpn_stats[:dmg].to_s =~ /special/ ? 0 : (wpn_stats[:dmg].to_s.to_i || 0)
      dmg = (n.DB || 0) + dmg_mod
      hp = wpn_stats[:hp] || 0

      f += "#{weapon.ljust(19)}"
      f += "#{skill_total.to_s.ljust(9)}"
      f += "#{' '.ljust(8)}"  # No init for missile
      f += "#{off.to_s.ljust(7)}"
      f += "#{' '.ljust(7)}"  # No def for missile
      f += "#{dmg.to_s.ljust(7)}"
      f += "#{hp.to_s.ljust(6)}"
      f += "#{range}"
      f += "\n"
    end
  end
  end  # Close the original/3-tier weapon display if/else block

  # Equipment section with money
  equipment = generate_equipment(n.type, n.level)
  social_status = generate_social_status(n.type, n.level)
  money = generate_money(social_status, n.level)
  
  # Convert money format from "X silver" to currency abbreviations
  money_value = money.split(' ').first.to_i
  money_str = if money_value >= 100
    gp = money_value / 100
    sp = (money_value % 100) / 10
    cp = money_value % 10
    parts = []
    parts << "#{gp}gp" if gp > 0
    parts << "#{sp}sp" if sp > 0
    parts << "#{cp}cp" if cp > 0
    parts.join(" ")
  elsif money_value >= 10
    sp = money_value / 10
    cp = money_value % 10
    parts = []
    parts << "#{sp}sp" if sp > 0
    parts << "#{cp}cp" if cp > 0
    parts.join(" ")
  else
    "#{money_value}cp"
  end
  
  f += "─" * width + "\n"
  equipment_list = equipment + [money_str]
  f += "EQUIPMENT: #{equipment_list.join(", ")}\n"
  
  # Creative Spells section using new spell catalog
  require_relative 'includes/spell_catalog'
  spells = assign_spells_to_npc(n)

  if !spells.empty?
    f += "─" * width + "\n"
    # Use color 165 for SPELLS title (purple for magic)
    spell_title_color = cli == "cli" ? "\e[38;5;165m\e[1m" : ""
    f += "#{spell_title_color}SPELLS (#{spells.length}):#{@reset}\n"

    spells.each do |spell|
      # Spell name and basic info
      spell_name_color = cli == "cli" ? "\e[38;5;226m\e[1m" : ""
      difficulty_color = cli == "cli" ? "\e[38;5;202m" : ""
      desc_color = cli == "cli" ? "\e[38;5;51m" : ""

      f += "  • #{spell_name_color}#{spell[:name]}#{@reset} (Difficulty: #{difficulty_color}#{spell[:difficulty]}#{@reset}, Cooldown: #{difficulty_color}#{spell[:cooldown]}h#{@reset})\n"
      f += "    #{desc_color}#{spell[:description]}#{@reset}\n"

      # Casting path and details
      path_color = cli == "cli" ? "\e[38;5;111m" : ""
      detail_color = cli == "cli" ? "\e[38;5;240m" : ""

      f += "    #{detail_color}Cast via: #{path_color}#{spell[:skill_path]}#{@reset}\n"
      f += "    #{detail_color}Range: #{@reset}#{spell[:range]}, #{detail_color}Duration: #{@reset}#{spell[:duration]}\n"

      if spell[:side_effects] && !spell[:side_effects].empty?
        side_effect_color = cli == "cli" ? "\e[38;5;196m" : ""
        f += "    #{detail_color}Side effect: #{side_effect_color}#{spell[:side_effects]}#{@reset}\n"
      end
      f += "\n"
    end
  end

  # Equipment section

  # Output handling
  if cli == "cli_direct"
    # This is the direct CLI mode - print and handle editing
    # Save clean version without ANSI codes for editing
    File.write("saved/temp_new.npc", f.pure, perm: 0644)
    # Display version with colors
    print f
    
    # Options
    puts "\nPress 'e' to edit, any other key to continue"
    begin
      key = STDIN.getch
    rescue Errno::ENOTTY
      # Not in a terminal, skip the interactive part
      key = nil
    end
    
    if key == "e"
      # Use vim with settings to avoid binary file warnings
      if $editor.include?("vim") || $editor.include?("vi")
        system("#{$editor} -c 'set fileformat=unix' saved/temp_new.npc")
      else
        system("#{$editor} saved/temp_new.npc")
      end
    end
    
    return f
  elsif cli == "cli"
    # This is TUI mode - just return the colored string without printing
    return f
  else
    # Plain mode - return without colors
    return f
  end
end

# Helper functions

def generate_cult_info(type, level, attunement_level = 0, sex = nil)
  # Generate religion and cult standing for religious types
  # Format: "Cult: [Religion], [Standing] (CS)"
  
  # Load religion table if not loaded
  unless defined?($CharacterReligions)
    load File.join($pgmdir, "includes/tables/religions.rb")
  end
  
  # Get appropriate deity from table - pass sex for nobility handling
  cult = get_character_religion(type, sex)
  
  # Determine cult standing based on level and attunement
  # Higher attunement means deeper religious involvement
  standing, cs = case level
  when 1..2
    if attunement_level >= 3
      ["Initiate", rand(3..5)]
    else
      ["Lay Member", rand(1..3)]
    end
  when 3..4
    if attunement_level >= 4
      ["Priest", rand(6..8)]
    else
      ["Initiate", rand(4..7)]
    end
  when 5..6
    if attunement_level >= 5
      ["High Priest", rand(10..12)]
    else
      ["Priest", rand(8..11)]
    end
  else
    ["High Priest", rand(12..15)]
  end
  
  # Special handling for non-priest types (they progress slower in cult)
  if !["Priest", "Clergyman", "Monk"].include?(type)
    standing, cs = case level
    when 1..3
      if attunement_level >= 3
        ["Initiate", rand(2..3)]
      else
        ["Lay Member", rand(1..2)]
      end
    when 4..5
      if attunement_level >= 4
        ["Initiate", rand(4..6)]
      else
        ["Initiate", rand(3..5)]
      end
    else
      if attunement_level >= 5
        ["Priest", rand(7..9)]
      else
        ["Initiate", rand(6..8)]
      end
    end
  end
  
  "Cult: #{cult}, #{standing} (#{cs})"
end

def generate_description(type, level, sex)
  # Generate random description if none provided
  build = ["lean", "muscular", "stocky", "thin", "athletic", "sturdy", "wiry", "robust"].sample
  hair = ["dark", "brown", "blonde", "red", "grey", "black", "auburn", "silver"].sample
  eyes = ["blue", "brown", "green", "grey", "hazel", "dark", "amber"].sample
  feature = ["scarred", "weathered", "youthful", "stern", "friendly", "intense", "calm", "sharp"].sample
  
  pronoun = sex == "F" ? "She" : "He"
  pronoun_pos = sex == "F" ? "Her" : "His"
  
  case type
  when "Warrior", "Guard", "Soldier"
    "#{build.capitalize} build with #{hair} hair. #{pronoun} has #{eyes} eyes and a #{feature} face. Battle-hardened."
  when "Mage", "Wizard", "Scholar"
    "#{pronoun} has #{eyes} eyes that show intelligence. #{hair.capitalize} hair, #{build} build. Scholarly demeanor."
  when "Thief", "Bandit", "Assassin"
    "#{feature.capitalize} features with #{eyes} eyes. #{build.capitalize} and agile. Moves with quiet confidence."
  when "Noble", "Merchant"
    "Well-groomed with #{hair} hair and #{eyes} eyes. #{build.capitalize} build. #{pronoun_pos} bearing shows status."
  when "Priest", "Monk"
    "#{pronoun} has a serene face with #{eyes} eyes. #{hair.capitalize} hair. #{feature.capitalize} presence."
  when "Ranger", "Hunter"
    "Weather-beaten with #{hair} hair. #{eyes.capitalize} eyes scan surroundings. #{build.capitalize} and outdoorsy."
  else
    "#{build.capitalize} build with #{hair} hair and #{eyes} eyes. #{feature.capitalize} appearance."
  end
end

def generate_social_status(type, level)
  # Generate social status using old system abbreviations
  # S=Slave, LC=Lower Class, LMC=Lower Middle Class, MC=Middle Class, UC=Upper Class, N=Noble
  case type
  when "Noble"
    "N"
  when "Priest", "Mage", "Wizard (air)", "Wizard (earth)", "Wizard (fire)", "Wizard (prot.)", "Wizard (water)", "Sorcerer", "Summoner"
    level > 3 ? "UC" : "MC"
  when "Merchant", "Scholar", "Sage", "Seer"
    level > 2 ? "MC" : "LMC"
  when "Warrior", "Guard", "Soldier", "Army officer", "Body guard"
    level > 4 ? "MC" : "LMC"
  when "Bandit", "Thief", "Assassin", "Prostitute", "Highwayman"
    "LC"
  when "Commoner", "Farmer", "House wife", "Nanny"
    "LMC"
  when "Executioner", "Gladiator"
    "LC"
  else
    level > 3 ? "LMC" : "LC"
  end
end

def generate_money(status, level)
  base = case status
         when "N" then 100 * level  # Noble
         when "UC" then 50 * level  # Upper Class
         when "MC" then 30 * level  # Middle Class
         when "LMC" then 15 * level # Lower Middle Class
         when "LC" then 8 * level   # Lower Class
         when "S" then 2 * level    # Slave
         else 10 * level
         end
  
  variance = rand(base / 2) - base / 4
  total = base + variance
  "#{total} silver"
end

# Load the new equipment tables if not already loaded
def generate_equipment(type, level)
  unless defined?(generate_npc_equipment)
    load File.join($pgmdir, "includes/equipment_tables.rb")
  end
  generate_npc_equipment(type, level)
end

def calculate_total_weight(n)
  weight = 0
  
  # Armor weight
  if n.armor
    weight += get_armor_weight(n.armor[:name])
  end
  
  # Weapon weights (approximate)
  melee_count = n.tiers["BODY"]["Melee Combat"]["skills"].select { |_, v| v > 0 }.size
  missile_count = n.tiers["BODY"]["Missile Combat"]["skills"].select { |_, v| v > 0 }.size
  weight += melee_count * 2  # Average 2kg per melee weapon
  weight += missile_count * 1.5  # Average 1.5kg per missile weapon
  
  # Basic equipment
  weight += 5  # Basic gear
  
  weight.round(1)
end

def get_armor_weight(armor_name)
  case armor_name
  when /Leather/i then 5
  when /Padded|Quilt/i then 7
  when /Chain shirt/i then 12
  when /Scale/i then 15
  when /Chain mail/i then 19
  when /Plate/i then 25
  when /Full plate/i then 30
  else 0
  end
end

# Get weapon stats from tables with init modifier
def get_weapon_stats(weapon)
  # Ensure weapon is a string and handle nil
  weapon = weapon.to_s.downcase
  
  # Return default stats if weapon is empty
  if weapon.empty?
    return { init: 0, off: 0, def: 0, dmg: "0" }
  end
  
  # Default values for weapons based on name patterns
  stats = case weapon
  when /sword/
    { init: 0, off: 0, def: 0, dmg: "+1" }
  when /dagger/, /knife/
    { init: 2, off: 1, def: -1, dmg: "-1" }
  when /axe/
    { init: -1, off: 0, def: -1, dmg: "+2" }
  when /spear/, /pike/
    { init: 1, off: 0, def: 1, dmg: "0" }
  when /mace/, /club/, /hammer/
    { init: -1, off: -1, def: 0, dmg: "+1" }
  when /staff/, /quarterstaff/
    { init: 0, off: 0, def: 2, dmg: "-1" }
  when /shield/
    { init: 0, off: -2, def: 3, dmg: "-2" }
  when /net/
    { init: -2, off: 0, def: 0, dmg: "special" }
  when /unarmed/
    { init: 1, off: -2, def: -4, dmg: "-4" }
  else
    { init: 0, off: 0, def: 0, dmg: "0" }
  end
  
  # Make absolutely sure all values are present
  stats ||= {}
  stats[:init] ||= 0
  stats[:off] ||= 0
  stats[:def] ||= 0
  stats[:dmg] ||= "0"
  
  stats
end

def get_missile_stats(weapon)
  # Ensure weapon is a string
  weapon = weapon.to_s.downcase
  
  # Return default stats if weapon is empty
  if weapon.empty?
    return { range: "30m", dmg: "0" }
  end
  
  # Default values for missile weapons
  stats = case weapon
  when /longbow/
    { range: "150m", dmg: "+1" }
  when /bow/
    { range: "100m", dmg: "0" }
  when /x-bow/, /crossbow/
    { range: "150m", dmg: "+2" }
  when /sling/
    { range: "50m", dmg: "-1" }
  when /throwing/, /javelin/
    { range: "30m", dmg: "0" }
  when /net/
    { range: "10m", dmg: "special" }
  when /spear/
    { range: "30m", dmg: "0" }
  when /blowgun/
    { range: "20m", dmg: "-5" }
  else
    { range: "30m", dmg: "0" }
  end
  
  # Ensure all values are present
  stats ||= {}
  stats[:range] ||= "30m"
  stats[:dmg] ||= "0"
  
  stats
end