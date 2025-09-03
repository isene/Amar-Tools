# Improved skill generation for experienced NPCs
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
  
  # BODY skills
  skill_pool += [
    ["BODY", "Athletics", "Hide", rand(2..3) + experience_bonus],
    ["BODY", "Athletics", "Move Quietly", rand(2..3) + experience_bonus],
    ["BODY", "Athletics", "Climb", rand(1..3) + experience_bonus],
    ["BODY", "Athletics", "Swim", rand(1..3) + experience_bonus],
    ["BODY", "Athletics", "Ride", rand(1..2) + experience_bonus],
    ["BODY", "Athletics", "Jump", rand(1..2) + experience_bonus],
    ["BODY", "Athletics", "Balance", rand(2..3) + experience_bonus],
    ["BODY", "Endurance", "Running", rand(2..3) + experience_bonus],
    ["BODY", "Endurance", "Combat Tenacity", rand(1..3) + experience_bonus],
    ["BODY", "Sleight", "Pick pockets", rand(1..2) + experience_bonus],
    ["BODY", "Sleight", "Disarm Traps", rand(1..2) + experience_bonus]
  ]
  
  # MIND skills
  skill_pool += [
    ["MIND", "Awareness", "Tracking", rand(2..3) + experience_bonus],
    ["MIND", "Awareness", "Detect Traps", rand(1..2) + experience_bonus],
    ["MIND", "Awareness", "Sense Emotions", rand(1..2) + experience_bonus],
    ["MIND", "Awareness", "Sense of Direction", rand(2..3) + experience_bonus],
    ["MIND", "Awareness", "Listening", rand(2..3) + experience_bonus],
    ["MIND", "Social Knowledge", "Social lore", rand(2..3) + experience_bonus],
    ["MIND", "Social Knowledge", "Spoken Language", rand(1..3) + experience_bonus],
    ["MIND", "Social Knowledge", "Literacy", rand(1..3) + experience_bonus],
    ["MIND", "Nature Knowledge", "Medical lore", rand(1..2) + experience_bonus],
    ["MIND", "Nature Knowledge", "Plant Lore", rand(1..2) + experience_bonus],
    ["MIND", "Nature Knowledge", "Animal Lore", rand(1..2) + experience_bonus],
    ["MIND", "Practical Knowledge", "Survival Lore", rand(2..3) + experience_bonus],
    ["MIND", "Practical Knowledge", "Set traps", rand(1..2) + experience_bonus],
    ["MIND", "Willpower", "Mental Fortitude", rand(2..3) + experience_bonus],
    ["MIND", "Willpower", "Courage", rand(1..3) + experience_bonus]
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
  if ["Warrior", "Guard", "Soldier", "Gladiator", "Body guard", "Ranger", "Hunter"].any? { |t| @type.include?(t) }
    skill_pool += [
      ["BODY", "Endurance", "Fortitude", rand(3..4) + experience_bonus],
      ["BODY", "Endurance", "Combat Tenacity", rand(3..4) + experience_bonus],
      ["MIND", "Practical Knowledge", "Ambush", rand(2..3) + experience_bonus],
      ["MIND", "Awareness", "Sense Ambush", rand(2..3) + experience_bonus]
    ]
  end
  
  # Scholarly types
  if ["Scholar", "Sage", "Scribe", "Wizard", "Mage"].any? { |t| @type.include?(t) }
    skill_pool += [
      ["MIND", "Intelligence", "Innovation", rand(3..4) + experience_bonus],
      ["MIND", "Intelligence", "Problem Solving", rand(3..4) + experience_bonus],
      ["MIND", "Social Knowledge", "Literacy", rand(4..5) + experience_bonus],
      ["MIND", "Nature Knowledge", "Alchemy", rand(2..3) + experience_bonus]
    ]
  end
  
  # Rogueish types
  if ["Thief", "Rogue", "Assassin", "Scout"].any? { |t| @type.include?(t) }
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
    
    # Convert array to hash if needed
    if @tiers[char_name][attr_name]["skills"].is_a?(Array)
      skill_list = @tiers[char_name][attr_name]["skills"]
      @tiers[char_name][attr_name]["skills"] = {}
      skill_list.each { |s| @tiers[char_name][attr_name]["skills"][s] = 0 }
    end
    
    # Add skill if it doesn't exist or is 0
    if !@tiers[char_name][attr_name]["skills"][skill_name] || 
       @tiers[char_name][attr_name]["skills"][skill_name] == 0
      @tiers[char_name][attr_name]["skills"][skill_name] = value
      skills_added += 1
    end
  end
  
  # Fill remaining with random skills from existing structure
  while skills_added < skill_count
    char_name = ["BODY", "MIND"].sample
    if @tiers[char_name]
      attr_name = @tiers[char_name].keys.sample
      if @tiers[char_name][attr_name] && @tiers[char_name][attr_name]["skills"]
        @tiers[char_name][attr_name]["skills"] ||= {}
        
        # Convert array to hash if needed
        if @tiers[char_name][attr_name]["skills"].is_a?(Array)
          skill_list = @tiers[char_name][attr_name]["skills"]
          @tiers[char_name][attr_name]["skills"] = {}
          skill_list.each { |s| @tiers[char_name][attr_name]["skills"][s] = 0 }
        end
        
        # Pick a random skill
        if @tiers[char_name][attr_name]["skills"].any?
          skill_name = @tiers[char_name][attr_name]["skills"].keys.sample
          if @tiers[char_name][attr_name]["skills"][skill_name] == 0
            @tiers[char_name][attr_name]["skills"][skill_name] = rand(1..3) + experience_bonus
            skills_added += 1
          end
        end
      end
    end
    
    # Prevent infinite loop
    break if skills_added >= 50
  end
end