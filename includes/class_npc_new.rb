# New NPC Class for 3-Tier System
# Implements the Characteristics > Attributes > Skills structure

class NpcNew
  attr_accessor :name, :type, :level, :area, :sex, :age, :height, :weight
  attr_accessor :tiers, :social_status, :marks, :description
  attr_accessor :melee_weapon, :missile_weapon, :armor, :ENC, :spells
  # Original CLI weapon format accessors
  attr_accessor :melee1, :melee2, :melee3, :missile
  attr_accessor :melee1s, :melee2s, :melee3s, :missiles
  attr_accessor :melee1i, :melee1o, :melee1d, :melee1dam, :melee1hp
  attr_accessor :melee2i, :melee2o, :melee2d, :melee2dam, :melee2hp
  attr_accessor :melee3i, :melee3o, :melee3d, :melee3dam, :melee3hp
  attr_accessor :missileo, :missiledam, :missilerange
  attr_accessor :armour, :ap
  
  def initialize(name, type, level, area, sex, age, height, weight, description, predetermined_stats = nil)
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
    
    # Generate realistic height and weight based on Amar averages
    # Human average: 170cm height, 70kg weight
    # But allowing for strongmen up to 195cm/125kg
    if height.to_i > 0
      @height = height.to_i
    else
      # Base height around 160 + variation using open-ended d6 rolls
      # This gives a bell curve centered around 170cm
      base_height = 160
      variation = oD6 * 2 + oD6 + rand(10)
      @height = base_height + variation
      @height -= 5 if @sex == "F"  # Females slightly shorter on average
      @height -= (3 * (16 - @age)) if @age < 17  # Youth adjustment

      # Type-based adjustments for larger/smaller builds
      case @type
      when /Warrior|Guard|Soldier|Body guard|Barbarian/
        @height += rand(0..10)  # Warriors tend to be taller
      when /Thief|Assassin|Rogue/
        @height -= rand(0..5)  # Rogues tend to be more average/shorter
      end
    end

    if weight.to_i > 0
      @weight = weight.to_i
    else
      # Weight based on height with more variation for different builds
      # Base formula: height - 120 + variation
      base_weight = @height - 120

      # Build variation based on character type
      build_modifier = case @type
      when /Warrior|Guard|Soldier|Body guard|Barbarian|Worker|Farmer/
        # Muscular builds: more weight for same height
        aD6 * 5 + rand(15)  # Can add up to 55kg for strongman builds
      when /Noble|Merchant|Scholar|Sage|Priest|Mage|Wizard/
        # Average to lighter builds
        aD6 * 3 + rand(10)  # Normal variation
      when /Thief|Assassin|Rogue|Scout/
        # Lean, agile builds
        aD6 * 2 + rand(10)  # Lighter variation
      else
        # Default average build
        aD6 * 4 + rand(10)
      end

      @weight = base_weight + build_modifier
      @weight = [@weight, 40].max  # Minimum weight of 40kg
    end
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
    
    # Store predetermined stats for later use
    @predetermined_stats = predetermined_stats

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
    
    # Apply predetermined stats if provided (for encounter consistency)
    apply_predetermined_stats() if @predetermined_stats

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
    
    # Use scaling that produces desired total skill progression
    # Target totals: L1: 4-5, L2: 6-7, L3: 8-9, L4: 10-11, L5: 12-13, L6: 14+
    # Typical warrior has BODY 1-2, Melee Combat 2-3, Weapon skill 2-3 at mid-levels
    level_multiplier = case npc_level
                       when 1 then 0.7
                       when 2 then 0.95
                       when 3 then 1.2
                       when 4 then 1.45
                       when 5 then 1.7
                       when 6 then 1.95
                       else 2.2
                       end

    level = (base * level_multiplier * growth_rate).to_i

    # Add variation ONLY if base > 0
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
  
  def select_actual_weapon(skill_name, strength_total, is_missile = false)
    # Map skill name to actual weapon from $Melee or $Missile table
    # Load weapon tables if needed
    unless defined?($Melee)
      load File.join($pgmdir, "includes/tables/melee.rb")
    end
    unless defined?($Missile)
      load File.join($pgmdir, "includes/tables/missile.rb")
    end

    if is_missile
      # Map missile skill names to actual weapons
      case skill_name.downcase
      when /bow/
        # Select bow based on strength: L(2), M(4), H(6), H2(8), H3(10)
        if strength_total >= 10
          "Bow(H3) [1]"
        elsif strength_total >= 8
          "Bow(H2) [1]"
        elsif strength_total >= 6
          "Bow(H)  [1]"
        elsif strength_total >= 4
          "Bow(M) [1]"
        else
          "Bow(L) [1]"
        end
      when /crossbow|x-bow/
        # Select crossbow based on strength
        if strength_total >= 4
          "X-bow(H) [¼]"
        elsif strength_total >= 3
          "X-bow(M) [⅓]"
        else
          "X-bow(L) [½]"
        end
      when /throwing|knife/
        "Th Knife [2]"
      when /javelin/
        "Javelin [1]"
      when /sling/
        "Sling [1]"
      when /net/
        skill_name  # Net is just "Net"
      when /spear/
        "Javelin [1]"  # Thrown spear = javelin
      else
        "Rock [2]"  # Default
      end
    else
      # Map melee skill names to actual weapons from $Melee table
      case skill_name.downcase
      when /sword/
        strength_total >= 4 ? "Longsword" : "Short sword"
      when /axe/
        strength_total >= 4 ? "B. axe 2H" : "Hatchet"
      when /spear/
        strength_total >= 4 ? "Spear 2H" : "Spear"
      when /mace/
        strength_total >= 4 ? "H. mace 2H" : "Light mace"
      when /dagger|knife/
        "Knife"
      when /staff/
        "Staff"
      when /club/
        "Club"
      when /net/
        "Net"
      when /shield/
        "Buckler"
      when /unarmed/
        "Unarmed"
      else
        skill_name  # Return as-is if no match
      end
    end
  end

  def add_weapon_skills(template)
    # Add melee weapon skills with primary weapon specialization
    # Also store actual weapon selections based on skill names
    if template["melee_weapons"]
      @tiers["BODY"]["Melee Combat"]["skills"] ||= {}
      @tiers["BODY"]["Melee Combat"]["actual_weapons"] ||= {}

      # Find primary weapon (highest base value)
      primary_weapon = template["melee_weapons"].max_by { |_, v| v }

      # Get strength total for weapon selection
      strength_total = get_skill_total("BODY", "Strength", "Wield weapon") rescue 3

      template["melee_weapons"].each_with_index do |(weapon, skill_level), index|
        base_level = calculate_tier_level(skill_level, @level, 0.6)

        # Boost primary weapon by 1-2 points for specialization
        if weapon == primary_weapon[0] && skill_level >= 4
          boost = rand(2) + 1  # +1 or +2
          base_level += boost
        end

        @tiers["BODY"]["Melee Combat"]["skills"][weapon] = base_level

        # Select actual weapon based on skill name and strength
        actual_weapon = select_actual_weapon(weapon, strength_total, false)
        @tiers["BODY"]["Melee Combat"]["actual_weapons"][weapon] = actual_weapon
      end
    end

    # Add missile weapon skills
    if template["missile_weapons"]
      @tiers["BODY"]["Missile Combat"]["skills"] ||= {}
      @tiers["BODY"]["Missile Combat"]["actual_weapons"] ||= {}

      # Find primary missile weapon
      primary_missile = template["missile_weapons"].max_by { |_, v| v }

      # Get strength total for missile weapon selection
      strength_total = get_skill_total("BODY", "Strength", "Wield weapon") rescue 3

      template["missile_weapons"].each do |weapon, skill_level|
        base_level = calculate_tier_level(skill_level, @level, 0.6)

        # Boost primary missile weapon
        if weapon == primary_missile[0] && skill_level >= 3
          boost = rand(2) + 1  # +1 or +2
          base_level += boost
        end

        @tiers["BODY"]["Missile Combat"]["skills"][weapon] = base_level

        # Select actual weapon based on skill name and strength
        actual_weapon = select_actual_weapon(weapon, strength_total, true)
        @tiers["BODY"]["Missile Combat"]["actual_weapons"][weapon] = actual_weapon
      end
    end
    
    # Add Unarmed combat for all NPCs (everyone can fight with fists)
    @tiers["BODY"]["Melee Combat"]["skills"] ||= {}
    if !@tiers["BODY"]["Melee Combat"]["skills"]["Unarmed"]
      # Base unarmed skill based on type and level
      unarmed_bonus = case @type
                      when /Monk|Martial|Barbarian/
                        2  # Better at unarmed
                      when /Warrior|Guard|Soldier|Gladiator/
                        1  # Decent at unarmed
                      when /Wizard|Sage|Scholar|Scribe/
                        -1  # Poor at unarmed
                      else
                        0  # Average
                      end
      unarmed_skill = calculate_tier_level(1 + unarmed_bonus, @level, 0.5)
      @tiers["BODY"]["Melee Combat"]["skills"]["Unarmed"] = [unarmed_skill, 0].max
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
      primary = select_best_weapon(melee_skills, ["Mace", "Staff", "Hammer"])
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
        primary = select_best_weapon(melee_skills, ["2H Axe", "2H Sword", "Spear"])
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
    when /Sailor|Seaman|Mariner/
      # Sailors typically have cutlass or short sword
      primary = select_best_weapon(melee_skills, ["Cutlass", "Short sword", "Hatchet"])
      @weapons << (primary || "Cutlass")
      if rand(100) < 40
        @weapons << "Dagger"  # Utility knife
      end
    when /Farmer|Commoner/
      # Common folk have simple weapons
      @weapons << select_best_weapon(melee_skills, ["Pitchfork", "Staff", "Hatchet"]) || "Staff"
    else
      # Default: pick best available weapon with more variety
      if melee_skills.any?
        # Get all weapons with decent skill
        good_weapons = melee_skills.select { |k, v| v > 0 && k != "Shield" }
        if good_weapons.any?
          # Sort weapons by skill level and pick from the better ones
          sorted_weapons = good_weapons.sort_by { |_, v| -v }
          # Take top weapons (those within 2 skill points of best)
          best_skill = sorted_weapons.first[1]
          top_weapons = sorted_weapons.select { |_, v| v >= best_skill - 2 }
          
          # Prefer weapons other than Dagger if available
          preferred = top_weapons.reject { |k, _| k =~ /Dagger/ }
          if preferred.any?
            @weapons << preferred.sample[0]
          else
            @weapons << top_weapons.sample[0]
          end
          
          # Sometimes add a secondary weapon
          if rand(100) < 30 && good_weapons.size > 1
            secondary = good_weapons.keys - [@weapons.first]
            @weapons << secondary.sample
          end
        end
      else
        # No skills, give more varied basic weapons
        basic_weapons = ["Staff", "Short sword", "Hatchet", "Mace", "Spear", "Knife"]
        @weapons << basic_weapons.sample
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
    
    # Use ORIGINAL armor selection logic from class_npc.rb
    # Determine armor level based on strength (exact original logic)
    strng = get_characteristic("BODY") || 3
    arm_level = case strng
                when 1..2 then 1
                when 3 then 2
                when 4 then 3
                when 5 then 5
                when 6 then 6
                when 7 then 7
                else 8
                end

    # Pick armor from ORIGINAL $Armour table
    armor_index = rand(arm_level) + 1
    armor_data = $Armour[armor_index]

    @armour = armor_data[0]  # Armor name from original table
    @ap = armor_data[1]      # Armor points from original table

    # Set armor in new format for compatibility with output
    @armor = {
      name: @armour,
      ap: @ap,
      enc: armor_data[4] || 0  # Weight as encumbrance
    }

    # Add armor encumbrance
    @ENC += @armor[:enc] if @armor

    # Add ORIGINAL weapon selection using $Melee and $Missile tables
    generate_original_weapons
  end

  def generate_original_weapons
    # Use EXACT original CLI weapon selection logic
    # Determine weapon level based on strength (like original)
    strng = get_characteristic("BODY") || 3
    wpn_level = case strng
                when 1 then 2
                when 2 then 4
                when 3 then 11
                when 4 then 18
                when 5 then 22
                when 7..8 then 28
                else 30
                end

    # Initialize weapon variables
    @melee1 = @melee2 = @melee3 = ""
    @melee1s = @melee2s = @melee3s = 0
    @melee1i = @melee1o = @melee1d = @melee1dam = @melee1hp = 0
    @melee2i = @melee2o = @melee2d = @melee2dam = @melee2hp = 0
    @melee3i = @melee3o = @melee3d = @melee3dam = @melee3hp = 0
    @missile = ""
    @missiles = @missileo = @missiledam = @missilerange = 0

    # Get reaction speed for initiative calculations
    reaction_speed = get_skill_total("MIND", "Awareness", "Reaction speed") || 0
    dodge_total = get_skill_total("BODY", "Athletics", "Dodge") || 0

    # Select melee weapon 1 from ORIGINAL $Melee table
    melee1_idx = rand(wpn_level) + 1
    melee1_data = $Melee[melee1_idx]
    @melee1 = melee1_data[0]  # Weapon name like "Longsword/Buc"
    @melee1s = calculate_weapon_skill_for_name(@melee1)
    @melee1i = melee1_data[4] + reaction_speed     # Init = weapon init + reaction
    @melee1o = melee1_data[5] + @melee1s           # Off = weapon off + skill
    @melee1d = melee1_data[6] + @melee1s + (dodge_total / 5)  # Def = weapon def + skill + dodge/5
    @melee1dam = melee1_data[3] + self.DB          # Damage = weapon dam + DB
    @melee1hp = melee1_data[7]                     # Weapon hit points

    # Select melee weapon 2 (if different)
    melee2_idx = rand(wpn_level) + 1
    if melee2_idx != melee1_idx
      melee2_data = $Melee[melee2_idx]
      @melee2 = melee2_data[0]
      @melee2s = calculate_weapon_skill_for_name(@melee2)
      @melee2i = melee2_data[4] + reaction_speed
      @melee2o = melee2_data[5] + @melee2s
      @melee2d = melee2_data[6] + @melee2s + (dodge_total / 5)
      @melee2dam = melee2_data[3] + self.DB
      @melee2hp = melee2_data[7]
    end

    # Select missile weapon from ORIGINAL $Missile table
    msl_level = wpn_level
    missile_idx = rand(msl_level) + 1
    missile_data = $Missile[missile_idx]
    @missile = missile_data[0]  # Weapon name like "Bow(H) [1]"
    @missiles = calculate_missile_skill_for_name(@missile)
    @missileo = missile_data[4] + @missiles        # Off = weapon off + skill
    @missiledam = missile_data[3] + self.DB        # Damage = weapon dam + DB
    @missilerange = missile_data[5]                # Range from table

    # Apply strength bonus for throwing weapons (original logic)
    if @missile && missile_data[1] != "Crossbow" && missile_data[1] != "Bow"
      @missiledam += (strng / 5)
    end
  end

  def calculate_weapon_skill_for_name(weapon_name)
    # Map weapon names to 3-tier skills
    case weapon_name.to_s.downcase
    when /sword/
      get_skill_total("BODY", "Melee Combat", "Sword")
    when /axe/
      get_skill_total("BODY", "Melee Combat", "Axe")
    when /mace|club|hammer/
      get_skill_total("BODY", "Melee Combat", "Club")
    when /spear|polearm/
      get_skill_total("BODY", "Melee Combat", "Spear")
    when /staff/
      get_skill_total("BODY", "Melee Combat", "Staff")
    when /dagger|knife/
      get_skill_total("BODY", "Melee Combat", "Dagger")
    when /unarmed/
      get_skill_total("BODY", "Melee Combat", "Unarmed")
    else
      get_skill_total("BODY", "Melee Combat", "Sword") || 0
    end
  end

  def calculate_missile_skill_for_name(weapon_name)
    case weapon_name.to_s.downcase
    when /bow/
      get_skill_total("BODY", "Missile Combat", "Bow")
    when /crossbow|x-bow/
      get_skill_total("BODY", "Missile Combat", "Crossbow")
    when /sling/
      get_skill_total("BODY", "Missile Combat", "Sling")
    when /javelin/
      get_skill_total("BODY", "Missile Combat", "Javelin")
    when /rock|stone|throwing|th\s|knife/
      get_skill_total("BODY", "Missile Combat", "Throwing")
    else
      get_skill_total("BODY", "Missile Combat", "Bow") || 0
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
  
  # Dice rolling methods (matching old system)
  def d6
    rand(1..6)
  end

  def oD6
    # Open-ended D6 roll
    result = d6
    return result if (2..5).include?(result)

    if result == 1
      down = d6
      while down <= 3
        result -= 1
        down = d6
      end
    elsif result == 6
      up = d6
      while up >= 4
        result += 1
        up = d6
      end
    end
    result
  end

  def aD6
    # Average D6 roll (average of regular d6 and open-ended d6)
    ((d6 + oD6) / 2.0).to_i
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
    # SIZE system based on weight with half-sizes
    case @weight
    when 0...10 then 0.5
    when 10...15 then 1
    when 15...20 then 1.5
    when 20...35 then 2
    when 35...50 then 2.5
    when 50...75 then 3
    when 75...100 then 3.5
    when 100...125 then 4
    when 125...150 then 4.5
    when 150...188 then 5
    when 188...225 then 5.5
    when 225...263 then 6
    when 263...300 then 6.5
    when 300...350 then 7
    when 350...400 then 7.5
    when 400...450 then 8
    when 450...500 then 8.5
    when 500...550 then 9
    when 550...600 then 9.5
    when 600...663 then 10
    when 663...725 then 10.5
    when 725...788 then 11
    when 788...850 then 11.5
    when 850...925 then 12
    when 925...1000 then 12.5
    when 1000...1075 then 13
    when 1075...1150 then 13.5
    when 1150...1225 then 14
    when 1225...1300 then 14.5
    when 1300...1375 then 15
    when 1375...1450 then 15.5
    when 1450...1525 then 16
    when 1525...1600 then 16.5
    else
      # For very large creatures, add 0.5 per 100kg
      16.5 + ((@weight - 1600) / 100.0).floor * 0.5
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
    # Use the proper name generator based on race
    race = @type.to_s.sub(/(:| ).*/, '').capitalize

    # Use naming function from functions.rb which uses the actual name generator
    name = naming(race, sex)

    # Fallback to basic names if name generator fails
    if name.nil? || name.empty?
      if sex == "F" || (sex.empty? && rand(2) == 0)
        female_names = ["Aria", "Luna", "Sera", "Mira", "Lyra", "Nova", "Kira", "Zara", "Elara", "Thalia"]
        name = female_names.sample + " " + ["Starweaver", "Moonwhisper", "Brightblade", "Swiftwind", "Ironheart"].sample
      else
        male_names = ["Gareth", "Marcus", "Aldric", "Kael", "Doran", "Lucian", "Theron", "Cassius", "Orion", "Zephyr"]
        name = male_names.sample + " " + ["Ironforge", "Stormcaller", "Darkbane", "Goldhand", "Steelclaw"].sample
      end
    end

    name
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

  def apply_predetermined_stats
    # Apply predetermined stats to preserve encounter consistency
    # This allows encounters to pass specific stats that should not be randomized

    return unless @predetermined_stats.is_a?(Hash)

    # Override characteristics if provided
    if @predetermined_stats["characteristics"]
      @predetermined_stats["characteristics"].each do |char_name, value|
        # This would require modifying the SIZE calculation system
        # For now, we'll focus on weapons/armor/skills
      end
    end

    # Override specific weapon skills if provided
    if @predetermined_stats["weapon_skills"]
      @predetermined_stats["weapon_skills"].each do |weapon, skill_level|
        # Add to melee combat skills
        @tiers["BODY"]["Melee Combat"]["skills"] ||= {}
        @tiers["BODY"]["Melee Combat"]["skills"][weapon] = skill_level.to_i
      end
    end

    # Override missile skills if provided
    if @predetermined_stats["missile_skills"]
      @predetermined_stats["missile_skills"].each do |weapon, skill_level|
        @tiers["BODY"]["Missile Combat"]["skills"] ||= {}
        @tiers["BODY"]["Missile Combat"]["skills"][weapon] = skill_level.to_i
      end
    end

    # Override armor if provided
    if @predetermined_stats["armor"]
      @armor = @predetermined_stats["armor"]
    end

    # Override other skills if provided
    if @predetermined_stats["skills"]
      @predetermined_stats["skills"].each do |skill_path, value|
        parts = skill_path.split("/")
        next unless parts.length == 3

        char_name, attr_name, skill_name = parts
        next unless @tiers[char_name] && @tiers[char_name][attr_name]

        @tiers[char_name][attr_name]["skills"] ||= {}
        @tiers[char_name][attr_name]["skills"][skill_name] = value.to_i
      end
    end
  end
end