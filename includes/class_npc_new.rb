# New NPC Class for 3-Tier System
# Implements the Characteristics > Attributes > Skills structure

class NpcNew
  attr_accessor :name, :type, :level, :area, :sex, :age, :height, :weight
  attr_accessor :tiers, :social_status, :marks, :description
  attr_accessor :melee_weapon, :missile_weapon, :armor, :ENC, :spells
  
  def initialize(name, type, level, area, sex, age, height, weight, description)
    # Generate random values for missing data
    @name = name && !name.empty? ? name : generate_random_name(sex)
    @type = type
    @level = level.to_i
    @area = area && !area.empty? ? area : ["Amaronir", "Merisir", "Calaronir", "Feronir", "Rauinir"].sample
    @sex = sex && !sex.empty? ? sex : ["M", "F"].sample
    
    # Calculate realistic age based on experience level
    # Assuming training starts at 15, each level requires years of dedication
    if age.to_i > 0
      @age = age.to_i
    else
      base_age = 15  # Starting age for training
      years_training = case @level
                      when 1 then rand(1..3)    # 16-18 years old
                      when 2 then rand(3..7)    # 18-22 years old
                      when 3 then rand(7..12)   # 22-27 years old
                      when 4 then rand(12..20)  # 27-35 years old
                      when 5 then rand(20..30)  # 35-45 years old
                      when 6 then rand(30..45)  # 45-60 years old
                      else rand(45..60)         # 60-75 years old
                      end
      @age = base_age + years_training
    end
    
    @height = height.to_i > 0 ? height.to_i : rand(150..200)
    @weight = weight.to_i > 0 ? weight.to_i : rand(50..100)
    @description = description
    
    # Initialize tier system structures
    @tiers = {
      "BODY" => {},
      "MIND" => {},
      "SPIRIT" => {}
    }
    
    # Initialize mark tracking for progression
    @marks = {
      "BODY" => {},
      "MIND" => {},
      "SPIRIT" => {}
    }
    
    # Set social status
    @social_status = ["S", "LC", "LMC", "MC", "UC", "N"].sample
    
    # Generate based on new tier system
    generate_tiers()
    
    # Generate spells if magic user
    generate_spells()
    
    # Select equipment
    select_equipment()
    
    # Initialize encumbrance
    @ENC = 0
  end
  
  private
  
  def generate_tiers
    # Load tier system and character templates
    unless defined?($TierSystem)
      load File.join($pgmdir, "includes/tables/tier_system.rb")
    end
    unless defined?($ChartypeNewFull)
      load File.join($pgmdir, "includes/tables/chartype_new_full.rb")
    end
    
    # Get template for this character type
    template = $ChartypeNewFull[@type] || $ChartypeNewFull["Commoner"]
    
    # Generate characteristics
    ["BODY", "MIND", "SPIRIT"].each do |char_name|
      char_base = template["characteristics"][char_name] || 2
      
      # Initialize attributes for this characteristic
      $TierSystem[char_name].each do |attr_name, attr_data|
        @tiers[char_name][attr_name] = {
          "level" => 0,
          "skills" => {}
        }
        
        # Set attribute base from template
        attr_key = "#{char_name}/#{attr_name}"
        if template["attributes"] && template["attributes"][attr_key]
          attr_base = template["attributes"][attr_key]
        else
          attr_base = attr_data["base"] || 0
        end
        
        # Calculate attribute level based on NPC level
        @tiers[char_name][attr_name]["level"] = calculate_tier_level(attr_base, @level, 0.8)
        
        # Initialize skills for this attribute
        if attr_data["skills"]
          # Convert array to hash for skills
          skill_list = attr_data["skills"]
          skill_list = [] unless skill_list.is_a?(Array)
          
          skill_list.each do |skill_name|
            # Check if template has specific skill values
            skill_key = "#{char_name}/#{attr_name}/#{skill_name}"
            skill_base = 0
            
            if template["skills"] && template["skills"][skill_key]
              skill_base = template["skills"][skill_key]
            end
            
            # Calculate skill level
            @tiers[char_name][attr_name]["skills"][skill_name] = calculate_tier_level(skill_base, @level, 0.6)
          end
        end
      end
    end
    
    # Add template-specific skills
    if template["skills"]
      template["skills"].each do |skill_path, base_value|
        parts = skill_path.split("/")
        next unless parts.length == 3
        
        char_name, attr_name, skill_name = parts
        next unless @tiers[char_name] && @tiers[char_name][attr_name]
        
        @tiers[char_name][attr_name]["skills"] ||= {}
        current = @tiers[char_name][attr_name]["skills"][skill_name] || 0
        new_value = calculate_tier_level(base_value, @level, 0.6)
        @tiers[char_name][attr_name]["skills"][skill_name] = [current, new_value].max
      end
    end
    
    # Add weapon skills from template
    add_weapon_skills(template)
    
    # Add Innate skills ONLY for specific character types
    innate_types = ["Witch (white)", "Witch (black)", "Sorcerer", "Summoner"]
    if innate_types.include?(@type)
      # These types get innate magical abilities
      innate_skills = ["Flying", "Camouflage", "Shape Shifting"]
      innate_skills.sample(rand(1..2)).each do |skill|
        @tiers["SPIRIT"]["Innate"]["skills"][skill] = rand(1..3) + (@level / 2)
      end
    end
    
    # For magic users, ensure they have appropriate Casting and Attunement
    if has_template_magic?(template)
      # Ensure minimum Casting level for spell use
      min_casting = (@level / 2) + 1
      if @tiers["SPIRIT"]["Casting"]["level"] < min_casting
        @tiers["SPIRIT"]["Casting"]["level"] = min_casting
      end
      
      # Add specific casting skills
      ["Range", "Duration", "Area of Effect"].each do |skill|
        @tiers["SPIRIT"]["Casting"]["skills"][skill] = rand(1..3) + (@level / 2)
      end
      
      # Set attunement domains based on type
      domains = case @type
                when /Wizard \((.*?)\)/
                  [$1.capitalize]
                when "Priest"
                  ["Life", "Body"]
                when "Mage"
                  ["Fire", "Air", "Mind"]
                else
                  ["Fire", "Water", "Air", "Earth"].sample(2)
                end
      
      domains.each do |domain|
        @tiers["SPIRIT"]["Attunement"]["skills"][domain] = rand(2..4) + (@level / 2)
      end
    end
    
    # Add experience-based skills for higher level NPCs
    if @level >= 4
      add_experience_skills()
    end
    
    # Ensure essential skills are always present
    ensure_essential_skills()
  end
  
  def add_experience_skills
    # Add additional skills for experienced characters
    experience_bonus = @level - 3  # 1 for level 4, 2 for level 5, etc.
    
    # Significantly expand skill generation based on level
    skill_count = case @level
                  when 4 then rand(8..12)
                  when 5 then rand(12..18)
                  when 6 then rand(18..25)
                  else rand(20..30)
                  end
    
    skills_added = 0
    
    # Build skill pool based on actual tier system
    skill_pool = []
    
    # BODY skills - more varied distribution
    skill_pool += [
      ["BODY", "Athletics", "Hide", rand(1..2) + (experience_bonus / 2)],
      ["BODY", "Athletics", "Move Quietly", rand(1..2) + (experience_bonus / 2)],
      ["BODY", "Athletics", "Climb", rand(0..2) + (experience_bonus / 2)],
      ["BODY", "Athletics", "Swim", rand(0..2) + (experience_bonus / 2)],
      ["BODY", "Athletics", "Ride", rand(0..1) + (experience_bonus / 3)],
      ["BODY", "Athletics", "Jump", rand(0..1) + (experience_bonus / 3)],
      ["BODY", "Athletics", "Balance", rand(1..2) + (experience_bonus / 2)],
      ["BODY", "Endurance", "Running", rand(1..2) + (experience_bonus / 2)],
      ["BODY", "Endurance", "Combat Tenacity", rand(0..2) + (experience_bonus / 2)],
      ["BODY", "Sleight", "Pick pockets", rand(0..1) + (experience_bonus / 3)],
      ["BODY", "Sleight", "Disarm Traps", rand(0..1) + (experience_bonus / 3)]
    ]
    
    # MIND skills - more varied distribution
    skill_pool += [
      ["MIND", "Awareness", "Tracking", rand(1..2) + (experience_bonus / 2)],
      ["MIND", "Awareness", "Detect Traps", rand(0..1) + (experience_bonus / 3)],
      ["MIND", "Awareness", "Sense Emotions", rand(0..2) + (experience_bonus / 2)],
      ["MIND", "Awareness", "Sense of Direction", rand(1..2) + (experience_bonus / 2)],
      ["MIND", "Awareness", "Listening", rand(1..2) + (experience_bonus / 2)],
      ["MIND", "Social Knowledge", "Social lore", rand(1..2) + (experience_bonus / 2)],
      ["MIND", "Social Knowledge", "Spoken Language", rand(0..2) + (experience_bonus / 2)],
      ["MIND", "Social Knowledge", "Literacy", rand(0..2) + (experience_bonus / 2)],
      ["MIND", "Nature Knowledge", "Medical lore", rand(0..1) + (experience_bonus / 3)],
      ["MIND", "Nature Knowledge", "Plant Lore", rand(0..1) + (experience_bonus / 3)],
      ["MIND", "Nature Knowledge", "Animal Lore", rand(0..1) + (experience_bonus / 3)],
      ["MIND", "Practical Knowledge", "Survival Lore", rand(1..2) + (experience_bonus / 2)],
      ["MIND", "Practical Knowledge", "Set traps", rand(0..1) + (experience_bonus / 3)],
      ["MIND", "Willpower", "Mental Fortitude", rand(1..2) + (experience_bonus / 2)],
      ["MIND", "Willpower", "Courage", rand(0..2) + (experience_bonus / 2)]
    ]
    
    # Type-specific skills
    if has_magic?
      skill_pool += [
        ["MIND", "Awareness", "Sense Magick", rand(3..4) + experience_bonus],
        ["MIND", "Nature Knowledge", "Magick Rituals", rand(3..5) + experience_bonus],
        ["MIND", "Social Knowledge", "Mythology", rand(2..3) + experience_bonus],
        ["MIND", "Social Knowledge", "Legend Lore", rand(2..3) + experience_bonus],
        ["SPIRIT", "Casting", "Range", rand(2..4) + experience_bonus],
        ["SPIRIT", "Casting", "Duration", rand(2..4) + experience_bonus],
        ["SPIRIT", "Casting", "Area of Effect", rand(1..3) + experience_bonus]
      ]
    end
    
    # Physical combat types
    type_str = @type.to_s
    if ["Warrior", "Guard", "Soldier", "Gladiator", "Body guard", "Ranger", "Hunter"].any? { |t| type_str.include?(t) }
      skill_pool += [
        ["BODY", "Endurance", "Fortitude", rand(3..4) + experience_bonus],
        ["BODY", "Endurance", "Combat Tenacity", rand(3..4) + experience_bonus],
        ["MIND", "Practical Knowledge", "Ambush", rand(2..3) + experience_bonus],
        ["MIND", "Awareness", "Sense Ambush", rand(2..3) + experience_bonus]
      ]
    end
    
    # Scholarly types
    if ["Scholar", "Sage", "Scribe", "Wizard", "Mage"].any? { |t| type_str.include?(t) }
      skill_pool += [
        ["MIND", "Intelligence", "Innovation", rand(3..4) + experience_bonus],
        ["MIND", "Intelligence", "Problem Solving", rand(3..4) + experience_bonus],
        ["MIND", "Social Knowledge", "Literacy", rand(4..5) + experience_bonus],
        ["MIND", "Nature Knowledge", "Alchemy", rand(2..3) + experience_bonus]
      ]
    end
    
    # Rogueish types
    if ["Thief", "Rogue", "Assassin", "Scout"].any? { |t| type_str.include?(t) }
      skill_pool += [
        ["BODY", "Athletics", "Hide", rand(4..5) + experience_bonus],
        ["BODY", "Athletics", "Move Quietly", rand(4..5) + experience_bonus],
        ["BODY", "Sleight", "Pick pockets", rand(3..5) + experience_bonus],
        ["BODY", "Sleight", "Disarm Traps", rand(3..4) + experience_bonus],
        ["MIND", "Awareness", "Detect Traps", rand(3..4) + experience_bonus]
      ]
    end
    
    # Now randomly select and add skills
    skill_pool.shuffle!
    
    skill_pool.each do |char_name, attr_name, skill_name, value|
      break if skills_added >= skill_count
      
      # Ensure the tier structure exists
      next unless @tiers[char_name] && @tiers[char_name][attr_name]
      
      # Initialize skills hash if needed
      @tiers[char_name][attr_name]["skills"] ||= {}
      
      # Add skill if it doesn't exist or is 0
      if !@tiers[char_name][attr_name]["skills"][skill_name] || 
         @tiers[char_name][attr_name]["skills"][skill_name] == 0
        @tiers[char_name][attr_name]["skills"][skill_name] = value
        skills_added += 1
      end
    end
  end
  
  def calculate_tier_level(base, npc_level, tier_modifier)
    # Natural caps based on training difficulty
    # The harder to train, the lower the natural cap
    
    # Determine tier type and apply realistic caps
    # Adjusted to create proper population distribution
    tier_caps = case tier_modifier
                when 1.0  # Characteristic (hardest to train)
                  { normal: 2, experienced: 3, master: 4, hero: 5 }
                when 0.8  # Attribute (moderate training)
                  { normal: 3, experienced: 5, master: 6, hero: 7 }
                when 0.6  # Skill (easiest to train)
                  { normal: 5, experienced: 7, master: 9, hero: 11 }
                else
                  { normal: 2, experienced: 3, master: 4, hero: 5 }
                end
    
    # Determine NPC experience level - matches population distribution
    experience = case npc_level
                 when 1..2 then :normal       # Common folk
                 when 3..4 then :experienced  # Town champions  
                 when 5..6 then :master       # Regional masters
                 else :hero                   # National/legendary
                 end
    
    max_value = tier_caps[experience]
    
    # Calculate level with diminishing returns
    # Characteristics grow very slowly, skills grow faster
    growth_rate = case tier_modifier
                  when 1.0 then 0.4  # Very slow for characteristics
                  when 0.8 then 0.6  # Moderate for attributes
                  when 0.6 then 0.8  # Faster for skills
                  else 0.5
                  end
    
    # Use square root for more realistic progression
    level = (base * Math.sqrt(npc_level + 1) * growth_rate).to_i
    
    # Add minimal variation ONLY if base > 0
    if base > 0
      variation = rand(3) - 1  # -1, 0, or 1
      level += variation
    end
    
    # Ensure minimum competence for trained individuals
    # Skills should rarely be below 3 for anyone with training
    if tier_modifier == 0.6  # Skills
      min_skill = case npc_level
                  when 1..2 then 2
                  when 3..4 then 3
                  else 4
                  end
      level = min_skill if level < min_skill && base > 0
    elsif tier_modifier == 0.8  # Attributes
      min_attr = case npc_level
                 when 1..2 then 1
                 when 3..4 then 2
                 else 3
                 end
      level = min_attr if level < min_attr && base > 0
    end
    
    # Apply training reality - most people plateau
    # Only exceptional individuals (high level + good base) reach max
    if tier_modifier == 1.0  # Characteristics rarely exceed 3
      level = 3 if level > 3 && rand(100) > 20  # 80% plateau at 3
    elsif tier_modifier == 0.8  # Attributes occasionally reach 6
      level = 5 if level > 5 && rand(100) > 40  # 60% plateau at 5
    end
    
    # Ensure within bounds
    level = 0 if level < 0
    level = max_value if level > max_value
    
    level
  end
  
  def add_weapon_skills(template)
    # Add melee weapon skills
    if template["melee_weapons"]
      @tiers["BODY"]["Melee Combat"]["skills"] ||= {}
      template["melee_weapons"].each do |weapon, skill_level|
        base_level = calculate_tier_level(skill_level, @level, 0.6)
        @tiers["BODY"]["Melee Combat"]["skills"][weapon] = base_level
      end
    end
    
    # Add missile weapon skills
    if template["missile_weapons"]
      @tiers["BODY"]["Missile Combat"]["skills"] ||= {}
      template["missile_weapons"].each do |weapon, skill_level|
        base_level = calculate_tier_level(skill_level, @level, 0.6)
        @tiers["BODY"]["Missile Combat"]["skills"][weapon] = base_level
      end
    end
  end
  
  def select_equipment
    @weapons = []
    @ENC = 0
    
    # Get melee combat skills
    melee_skills = @tiers["BODY"]["Melee Combat"]["skills"] || {}
    missile_skills = @tiers["BODY"]["Missile Combat"]["skills"] || {}
    
    # Check if has shield skill
    has_shield = melee_skills["Shield"] && melee_skills["Shield"] > 0
    
    # Determine weapon loadout based on character type and skills
    case @type
    when /Warrior|Guard|Soldier|Knight/
      # Warriors typically have weapon + shield or two-handed weapon
      if has_shield && rand(100) < 70
        # Weapon + shield combo (70% chance if has shield skill)
        primary = select_best_weapon(melee_skills, ["Sword", "Axe", "Mace", "Spear"])
        @weapons << primary if primary
        @weapons << "Shield"
      elsif rand(100) < 40
        # Two-handed weapon (40% chance)
        primary = select_best_weapon(melee_skills, ["2H Sword", "2H Axe", "Polearm", "Spear"])
        @weapons << (primary || "Spear")
      else
        # Dual wield
        primary = select_best_weapon(melee_skills, ["Sword", "Axe", "Mace"])
        secondary = select_best_weapon(melee_skills, ["Short sword", "Dagger", "Hatchet"])
        @weapons << (primary || "Sword")
        @weapons << (secondary || "Dagger")
      end
    when /Thief|Assassin|Rogue/
      # Thieves prefer light weapons, often dual wield
      primary = select_best_weapon(melee_skills, ["Short sword", "Dagger", "Rapier"])
      @weapons << (primary || "Dagger")
      if rand(100) < 60
        # Often carry a second weapon
        @weapons << "Dagger"
      end
    when /Ranger|Hunter|Scout/
      # Rangers typically have melee + ranged
      primary = select_best_weapon(melee_skills, ["Sword", "Axe", "Spear"])
      @weapons << (primary || "Sword")
      if rand(100) < 30
        @weapons << "Dagger"  # Backup weapon
      end
    when /Priest|Cleric|Monk/
      # Religious types often use blunt weapons
      primary = select_best_weapon(melee_skills, ["Mace", "Staff", "Club"])
      @weapons << (primary || "Staff")
      if has_shield && rand(100) < 40
        @weapons << "Shield"
      end
    when /Wizard|Mage|Sorcerer/
      # Mages usually just have a staff or dagger
      primary = select_best_weapon(melee_skills, ["Staff", "Dagger"])
      @weapons << (primary || "Staff")
    when /Noble/
      # Nobles have fancy weapons
      primary = select_best_weapon(melee_skills, ["Sword", "Rapier"])
      @weapons << (primary || "Sword")
      if rand(100) < 50
        @weapons << "Dagger"  # Ornamental backup
      end
    when /Barbarian/
      # Barbarians use heavy weapons
      if rand(100) < 60
        primary = select_best_weapon(melee_skills, ["2H Axe", "2H Sword", "Club"])
        @weapons << (primary || "2H Axe")
      else
        # Dual wield
        @weapons << select_best_weapon(melee_skills, ["Axe", "Sword"]) || "Axe"
        @weapons << select_best_weapon(melee_skills, ["Axe", "Mace"]) || "Hatchet"
      end
    when /Gladiator/
      # Gladiators have varied weapon combos
      combo = rand(100)
      if combo < 33
        # Sword and shield
        @weapons << select_best_weapon(melee_skills, ["Sword", "Spear"]) || "Sword"
        @weapons << "Shield"
      elsif combo < 66
        # Dual wield
        @weapons << "Sword"
        @weapons << "Short sword"
      else
        # Exotic weapon
        @weapons << select_best_weapon(melee_skills, ["Trident", "Net", "Spear"]) || "Spear"
        if has_shield
          @weapons << "Shield"
        end
      end
    when /Smith/
      # Smiths have varied hammers and tools - add randomization
      weapon_choice = rand(100)
      if weapon_choice < 40
        @weapons << select_best_weapon(melee_skills, ["Hammer", "War hammer"]) || "Hammer"
      elsif weapon_choice < 70
        @weapons << select_best_weapon(melee_skills, ["Mace", "Hammer"]) || "Mace"
      elsif weapon_choice < 85
        # Smith with axe
        @weapons << select_best_weapon(melee_skills, ["Axe", "Hatchet"]) || "Axe"
      else
        # Smith with sword (forged their own)
        @weapons << select_best_weapon(melee_skills, ["Sword", "Short sword"]) || "Sword"
      end
      # Sometimes add a shield
      if has_shield && rand(100) < 30
        @weapons << "Shield"
      end
    when /Farmer|Commoner/
      # Common folk have simple weapons
      @weapons << select_best_weapon(melee_skills, ["Pitchfork", "Club", "Staff", "Dagger"]) || "Club"
    else
      # Default: pick best available weapon with more variety
      if melee_skills.any?
        # Get all weapons with decent skill
        good_weapons = melee_skills.select { |k, v| v > 0 && k != "Shield" }
        if good_weapons.any?
          # Pick randomly from good options
          @weapons << good_weapons.keys.sample
        end
      else
        # No skills, give basic weapon
        @weapons << ["Dagger", "Club", "Staff"].sample
      end
    end
    
    # Add missile weapon if applicable
    if missile_skills.any?
      best_missile = missile_skills.max_by { |_, v| v }
      if best_missile && rand(100) < 70  # 70% chance to actually carry it
        @missile_weapon = best_missile[0]
        @ENC += 1
      end
    end
    
    # Set primary melee weapon for compatibility
    @melee_weapon = @weapons.first if @weapons.any?
    
    # Calculate encumbrance
    @ENC += @weapons.size
    
    # Select armor based on type and level
    armor_types = case @type
                  when "Warrior", "Guard", "Soldier", "Gladiator"
                    ["Chain mail", "Scale", "Plate"].sample
                  when "Ranger", "Hunter", "Scout"
                    ["Leather", "Padded", "Chain shirt"].sample
                  when "Thief", "Rogue", "Assassin"
                    ["Padded", "Leather"].sample
                  when "Noble", "Knight"
                    ["Chain mail", "Plate", "Full plate"].sample
                  else
                    rand(100) < 30 ? ["Padded", "Leather"].sample : nil
                  end
    
    if armor_types
      armor_name = armor_types
      
      @armor = case armor_name
               when "Leather"
                 { name: "Leather", ap: 2, enc: 2 }
               when "Padded"
                 { name: "Padded", ap: 1, enc: 1 }
               when "Chain shirt"
                 { name: "Chain shirt", ap: 3, enc: 3 }
               when "Scale"
                 { name: "Scale armor", ap: 4, enc: 4 }
               when "Chain mail"
                 { name: "Chain mail", ap: 4, enc: 5 }
               when "Plate"
                 { name: "Plate armor", ap: 5, enc: 6 }
               when "Full plate"
                 { name: "Full plate", ap: 6, enc: 7 }
               else
                 nil
               end
      
      # Add armor encumbrance to total
      @ENC += @armor[:enc] if @armor
    end
  end
  
  def select_best_weapon(skills, preferred_weapons)
    # Find the best weapon from preferred list that character has skill in
    best_weapon = nil
    best_skill = 0
    
    preferred_weapons.each do |weapon|
      if skills[weapon] && skills[weapon] > best_skill
        best_weapon = weapon
        best_skill = skills[weapon]
      end
    end
    
    # If no preferred weapon found, check for any weapon skill
    if !best_weapon && skills.any?
      # Filter out Shield as it's not a primary weapon
      weapon_skills = skills.reject { |k, _| k == "Shield" }
      if weapon_skills.any?
        best = weapon_skills.max_by { |_, v| v }
        best_weapon = best[0]
      end
    end
    
    best_weapon
  end
  
  def has_template_magic?(template)
    # Check if template indicates magical ability
    return false unless template
    
    # Check if template has Casting attribute > 0
    casting_attr = template["attributes"]["SPIRIT/Casting"] || 0
    return true if casting_attr > 0
    
    # Check for specific magic-using types
    magic_types = ["Mage", "Wizard", "Witch (white)", "Witch (black)", "Sorcerer", 
                   "Summoner", "Priest", "Sage", "Seer"]
    type_str = @type.to_s
    magic_types.include?(type_str) || type_str.include?("Wizard")
  end
  
  # Moved to public section below
  
  def generate_spells
    # Generate spell cards based on character type and level
    spirit = get_characteristic("SPIRIT")
    casting_attr = get_attribute("SPIRIT", "Casting")
    casting_total = spirit + casting_attr
    
    # Restrict spells to appropriate creatures
    # Require SPIRIT >= 2 AND total Casting >= 5
    # Exclude specific races and creature types
    excluded_types = ["Araxi", "Troll", "Dwarf", "Ogre", "Lizard", "Animal", "Zombie", "Skeleton"]
    type_lower = @type.to_s.downcase
    
    is_excluded = excluded_types.any? { |ex| type_lower.include?(ex.downcase) }
    
    # Only generate spells for intelligent magical beings
    if spirit >= 2 && casting_total >= 5 && !is_excluded
      # Load spell database if not already loaded
      unless defined?($SpellDatabase)
        load File.join($pgmdir, "includes/tables/spells_new.rb")
      end
      
      @spells = generate_spell_cards(@type, @level, casting_total)
    end
  end
  
  # Public methods for accessing tier data
  public
  
  def has_magic?
    # Check if character has any casting ability
    casting_level = @tiers["SPIRIT"]["Casting"]["level"] || 0
    casting_level > 0
  end
  
  # Calculate derived stats
  def SIZE
    # New SIZE system with half-point values based on weight
    case @weight
    when 0...5
      0.5
    when 5...10
      1
    when 10...20
      1.5
    when 20...35
      2
    when 35...50
      2.5
    when 50...75
      3
    when 75...100
      3.5
    when 100...125
      4
    when 125...150
      4.5
    when 150...175
      5
    when 175...200
      5.5
    when 200...225
      6
    when 225...250
      6.5
    when 250...275
      7
    when 275...300
      7.5
    when 300...350
      8
    when 350...400
      8.5
    when 400...450
      9
    when 450...500
      9.5
    when 500...550
      10
    when 550...600
      10.5
    when 600...650
      11
    when 650...700
      11.5
    when 700...750
      12
    else
      # For very large creatures, continue the pattern
      base = (@weight / 25.0).floor * 0.5
      [base, 0.5].max
    end
  end
  
  def BP
    # Body Points: SIZE * 2 + Fortitude / 3
    # Fortitude is under Endurance
    fortitude = get_skill("BODY", "Endurance", "Fortitude")
    endurance = get_attribute("BODY", "Endurance")
    body = get_characteristic("BODY")
    total_fortitude = body + endurance + fortitude
    (self.SIZE * 2 + total_fortitude / 3.0).round
  end
  
  def DB
    # Damage Bonus: (SIZE + Strength total) / 3
    strength = get_attribute("BODY", "Strength")
    body = get_characteristic("BODY")
    total_strength = body + strength
    ((self.SIZE + total_strength) / 3.0).round
  end
  
  def MD
    # Magic Defense: (Mental Fortitude + Attunement Self) / 3
    mental_fortitude = get_skill("MIND", "Willpower", "Mental Fortitude")
    willpower = get_attribute("MIND", "Willpower")
    mind = get_characteristic("MIND")
    total_mental_fortitude = mind + willpower + mental_fortitude
    
    attunement_self = get_skill("SPIRIT", "Attunement", "Self")
    attunement = get_attribute("SPIRIT", "Attunement")
    spirit = get_characteristic("SPIRIT")
    total_attunement_self = spirit + attunement + attunement_self
    
    ((total_mental_fortitude + total_attunement_self) / 3.0).round
  end
  
  def get_characteristic(name)
    # Calculate characteristic as weighted average of its attributes
    # Reflects years of broad training across all aspects
    total = 0
    count = 0
    @tiers[name].each do |attr_name, attr_data|
      if attr_data["level"] && attr_data["level"] > 0
        total += attr_data["level"]
        count += 1
      end
    end
    
    return 0 if count == 0
    
    # Characteristics are very hard to improve - most people stay at 2-3
    char_level = (total.to_f / count / 1.5).round  # Scaled down to reflect training difficulty
    
    # Apply realistic caps based on NPC level
    max_char = case @level
               when 1..2 then 2  # Novices rarely exceed 2
               when 3..4 then 3  # Experienced typically max at 3
               when 5..6 then 4  # Veterans might reach 4
               else 5            # Only masters achieve 5
               end
    
    char_level = max_char if char_level > max_char
    char_level
  end
  
  def get_attribute(char_name, attr_name)
    @tiers[char_name][attr_name]["level"] || 0
  end
  
  def get_skill(char_name, attr_name, skill_name)
    @tiers[char_name][attr_name]["skills"][skill_name] || 0
  end
  
  def get_skill_total(char_name, attr_name, skill_name)
    # Calculate total: Characteristic + Attribute + Skill
    char_level = get_characteristic(char_name)
    attr_level = get_attribute(char_name, attr_name)
    skill_level = get_skill(char_name, attr_name, skill_name)
    
    # Natural progression based on training difficulty:
    # - Getting to 10 is achievable with focused skill training
    # - Getting to 15 requires years of dedicated work
    # - Getting to 18+ is legendary, requiring lifetime mastery
    total = char_level + attr_level + skill_level
    
    # Apply soft cap at 18 for game balance (only true masters exceed)
    if total > 18 && @level < 7
      # Small chance for exceptional individuals to exceed 18
      total = 18 unless rand(100) < 5
    end
    
    total
  end
  
  # Mark system for progression
  
  def add_mark(char_name, attr_name, skill_name = nil)
    if skill_name
      # Add mark to skill
      key = "#{attr_name}/#{skill_name}"
      @marks[char_name][key] ||= 0
      @marks[char_name][key] += 1
      
      # Check if ready to advance
      check_advancement(char_name, attr_name, skill_name)
    else
      # Add mark to attribute
      @marks[char_name][attr_name] ||= 0
      @marks[char_name][attr_name] += 1
    end
  end
  
  def check_advancement(char_name, attr_name, skill_name)
    current_level = get_skill(char_name, attr_name, skill_name)
    required_marks = (current_level + 1) * 5
    key = "#{attr_name}/#{skill_name}"
    
    if @marks[char_name][key] >= required_marks
      # Roll for advancement (all but a 1)
      if oD6 > 1
        @tiers[char_name][attr_name]["skills"][skill_name] += 1
        @marks[char_name][key] = 0
        
        # Add mark to attribute above
        add_mark(char_name, attr_name)
        
        return true
      end
    end
    false
  end
  
  private
  
  def generate_random_name(sex)
    # Generate a random fantasy name
    if sex == "F" || (sex.empty? && rand(2) == 0)
      female_names = ["Aria", "Luna", "Sera", "Mira", "Lyra", "Nova", "Kira", "Zara", "Elara", "Thalia"]
      female_names.sample + " " + ["Starweaver", "Moonwhisper", "Brightblade", "Swiftwind", "Ironheart"].sample
    else
      male_names = ["Gareth", "Marcus", "Aldric", "Kael", "Doran", "Lucian", "Theron", "Cassius", "Orion", "Zephyr"]
      male_names.sample + " " + ["Ironforge", "Stormcaller", "Darkbane", "Goldhand", "Steelclaw"].sample
    end
  end
  
  def ensure_essential_skills
    # Ensure all NPCs have essential combat/stealth awareness skills (even if at 0)
    # These skills are frequently used in encounters
    
    # Ensure Athletics attribute exists with essential skills
    @tiers["BODY"]["Athletics"] ||= {"level" => 0, "skills" => {}}
    @tiers["BODY"]["Athletics"]["skills"] ||= {}
    
    # Add Move Quietly if missing
    unless @tiers["BODY"]["Athletics"]["skills"].key?("Move Quietly")
      @tiers["BODY"]["Athletics"]["skills"]["Move Quietly"] = 0
    end
    
    # Add Hide if missing
    unless @tiers["BODY"]["Athletics"]["skills"].key?("Hide")
      @tiers["BODY"]["Athletics"]["skills"]["Hide"] = 0
    end
    
    # Add Dodge if missing (often used in combat)
    unless @tiers["BODY"]["Athletics"]["skills"].key?("Dodge")
      @tiers["BODY"]["Athletics"]["skills"]["Dodge"] = 0
    end
    
    # Ensure Awareness attribute exists with essential skills
    @tiers["MIND"]["Awareness"] ||= {"level" => 0, "skills" => {}}
    @tiers["MIND"]["Awareness"]["skills"] ||= {}
    
    # Add Alertness if missing (this is the general awareness skill)
    unless @tiers["MIND"]["Awareness"]["skills"].key?("Alertness")
      @tiers["MIND"]["Awareness"]["skills"]["Alertness"] = 0
    end
    
    # Reaction speed should always be present for initiative calculations
    unless @tiers["MIND"]["Awareness"]["skills"].key?("Reaction speed")
      @tiers["MIND"]["Awareness"]["skills"]["Reaction speed"] = 0
    end
  end
end