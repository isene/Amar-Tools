# Monster/Animal NPC class for the new 3-tier system
# This creates simplified NPCs for non-humanoid encounters

class MonsterNew
  attr_accessor :name, :type, :level, :sex, :description, :weight
  attr_accessor :SIZE, :BP, :DB, :MD, :ENC
  attr_accessor :tiers, :armor, :special_abilities, :spells
  
  def initialize(monster_type, level = 1)
    @type = monster_type
    @level = level
    @sex = ["M", "F"].sample  # Even monsters have gender sometimes
    
    # Load monster stats if not loaded
    unless defined?($MonsterStats)
      load File.join($pgmdir, "includes/tables/monster_stats_new.rb")
    end
    
    # Get stats template
    stats = get_monster_stats(@type)
    
    # Set name based on type
    @name = @type.gsub(/Monster:|Animal:|Small |Large /, "").strip.capitalize
    @description = stats["description"]
    @special_abilities = stats["special"]
    
    # Generate weight and SIZE
    if stats["weight_range"]
      # New system: use weight range and calculate SIZE
      @weight = rand(stats["weight_range"][0]..stats["weight_range"][1])
      @SIZE = calculate_size_from_weight(@weight)
    elsif stats["size_range"]
      # Legacy system: convert old SIZE to approximate weight
      old_size = rand(stats["size_range"][0]..stats["size_range"][1])
      # Convert old SIZE to weight (rough approximation)
      @weight = size_to_weight(old_size)
      @SIZE = calculate_size_from_weight(@weight)
    else
      # Default human range
      @weight = rand(50..100)
      @SIZE = calculate_size_from_weight(@weight)
    end
    
    # Initialize tiers with simplified structure for monsters
    @tiers = {
      "BODY" => {
        "level" => stats["base_body"] + (@level / 2),
        "Strength" => { "level" => stats["base_body"] + rand(0..1) },
        "Endurance" => { "level" => stats["base_body"] + rand(0..1) },
        "Melee Combat" => { 
          "level" => stats["base_body"],
          "skills" => generate_combat_skills(stats["skills"])
        },
        "Missile Combat" => {
          "level" => 0,
          "skills" => {}
        },
        "Athletics" => {
          "level" => stats["base_body"] - 1,
          "skills" => {
            "Dodge" => rand(1..3),
            "Running" => rand(0..2),
            "Move Quietly" => rand(0..2),
            "Hide" => rand(0..2)
          }
        }
      },
      "MIND" => {
        "level" => stats["base_mind"] + (@level / 3),
        "Intelligence" => { "level" => stats["base_mind"] },
        "Awareness" => { 
          "level" => stats["base_mind"] + rand(0..1),
          "skills" => {
            "Reaction speed" => rand(0..2),
            "Tracking" => stats["skills"].include?("Tracking") ? rand(2..4) : 0,
            "Alertness" => rand(0..2)
          }
        }
      },
      "SPIRIT" => {
        "level" => stats["base_spirit"],
        "Casting" => { "level" => stats["base_spirit"] > 0 ? rand(1..3) : 0 },
        "Attunement" => { "level" => stats["base_spirit"] > 0 ? rand(1..2) : 0, "skills" => {} }
      }
    }
    
    # Add magical abilities for creatures with spirit
    if stats["base_spirit"] > 0
      # Dragons get Earth magic, other magical creatures get varied
      if @type =~ /dragon/i
        @tiers["SPIRIT"]["Attunement"]["skills"]["Earth"] = @level + rand(2..4)
      elsif @type =~ /drake/i
        @tiers["SPIRIT"]["Attunement"]["skills"]["Fire"] = @level + rand(1..3)
      elsif @type =~ /elemental/i
        element = ["Fire", "Water", "Air", "Earth"].sample
        @tiers["SPIRIT"]["Attunement"]["skills"][element] = @level + rand(2..4)
      elsif @type =~ /undead|zombie|skeleton|lich/i
        @tiers["SPIRIT"]["Attunement"]["skills"]["Death"] = @level + rand(1..3)
      else
        # Other magical creatures get random domain
        domain = ["Fire", "Water", "Air", "Earth", "Life", "Death", "Mind"].sample
        @tiers["SPIRIT"]["Attunement"]["skills"][domain] = @level + rand(1..2)
      end
    end
    
    # Calculate derived stats
    calculate_derived_stats
    
    # Generate spells for magical creatures
    generate_spells if stats["base_spirit"] > 0
    
    # Set armor
    set_armor(stats["armor"])
  end
  
  private
  
  def size_to_weight(old_size)
    # Convert old SIZE system to approximate weight for backward compatibility
    # Old system: SIZE 8-10 for humans, SIZE 15-20 for dragons
    case old_size
    when 0..1 then rand(5..15)
    when 2 then rand(15..30)
    when 3 then rand(30..60)
    when 4 then rand(60..90)
    when 5 then rand(90..135)
    when 6 then rand(135..180)
    when 7 then rand(180..240)
    when 8 then rand(240..300)
    when 9 then rand(300..375)
    when 10 then rand(375..450)
    when 11 then rand(450..525)
    when 12 then rand(525..600)
    when 13 then rand(600..700)
    when 14 then rand(700..800)
    when 15 then rand(800..900)
    when 16 then rand(900..1000)
    when 17 then rand(1000..1200)
    when 18 then rand(1200..1400)
    when 19 then rand(1400..1600)
    when 20 then rand(1600..1800)
    else old_size * 90  # Rough approximation for very large creatures
    end
  end
  
  def calculate_size_from_weight(weight)
    # New SIZE system with half-point values based on weight
    case weight
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
      base = (weight / 25.0).floor * 0.5
      [base, 0.5].max
    end
  end
  
  def generate_combat_skills(skill_list)
    skills = {}
    
    skill_list.each do |skill_name|
      case skill_name.downcase
      when /bite/, /claw/, /tusk/, /tail/
        skills["Natural weapons"] = @level + rand(1..3)
      when /sword/, /spear/, /dagger/
        skills[skill_name.capitalize] = @level + rand(0..2)
      when /club/
        skills["Club"] = @level + rand(0..2)
      when /unarmed/
        skills["Unarmed combat"] = @level + rand(1..3)
      when /grappl/
        skills["Grappling"] = @level + rand(0..2)
      end
    end
    
    # Ensure at least one combat skill
    skills["Natural weapons"] = @level if skills.empty?
    
    skills
  end
  
  def calculate_derived_stats
    body = @tiers["BODY"]["level"]
    mind = @tiers["MIND"]["level"]
    
    # Body Points
    @BP = @SIZE + body + @tiers["BODY"]["Endurance"]["level"]
    
    # Damage Bonus
    strength_total = body + @tiers["BODY"]["Strength"]["level"]
    @DB = (strength_total + @SIZE - 10) / 3
    
    # Magic Defense
    @MD = mind + @tiers["MIND"]["Awareness"]["level"]
    
    # Encumbrance (monsters don't carry much)
    @ENC = 0
  end
  
  def set_armor(armor_desc)
    return unless armor_desc
    
    if armor_desc =~ /Natural \((\d+) AP\)/
      @armor = {
        name: "Natural armor",
        ap: $1.to_i,
        enc: 0
      }
    else
      @armor = {
        name: armor_desc,
        ap: 1,
        enc: 0
      }
    end
  end
  
  def generate_spells
    # Load spell tables if not loaded
    unless defined?($SpellDatabase)
      load File.join($pgmdir, "includes/tables/spells_new.rb")
    end
    
    @spells = []
    
    # Determine primary domain
    domain = nil
    highest_skill = 0
    
    if @tiers["SPIRIT"]["Attunement"]["skills"]
      @tiers["SPIRIT"]["Attunement"]["skills"].each do |dom, skill|
        if skill > highest_skill
          domain = dom
          highest_skill = skill
        end
      end
    end
    
    return unless domain
    
    # Calculate spell count based on level and domain skill
    spell_count = (@level + highest_skill) / 2
    spell_count = [spell_count, 1].max
    spell_count = [spell_count, 20].min  # Cap at 20 spells
    
    # Dragons get more spells
    spell_count = (@level * 2) if @type =~ /dragon/i
    spell_count = [spell_count, 30].min if @type =~ /dragon/i
    
    # Get spells from the appropriate domain
    available_spells = []
    
    # Filter spells by domain from $SpellDatabase
    $SpellDatabase.each do |spell_name, spell_data|
      if spell_data["domain"] == domain
        available_spells << {
          'name' => spell_name,
          'duration' => spell_data["duration"],
          'range' => spell_data["distance"],
          'area' => spell_data["aoe"]
        }
      end
    end
    
    # If no spells found for domain, use some generic ones
    if available_spells.empty?
      # Create some basic spells for the domain
      case domain
      when "Earth"
        available_spells = [
          {'name' => "Stone Skin", 'duration' => "1 hour", 'range' => "Touch", 'area' => "Single"},
          {'name' => "Earth Spike", 'duration' => "Instant", 'range' => "20m", 'area' => "Single"},
          {'name' => "Tremor", 'duration' => "Instant", 'range' => "50m", 'area' => "10m radius"},
          {'name' => "Stone Wall", 'duration' => "Permanent", 'range' => "10m", 'area' => "Wall 5m"},
          {'name' => "Earth Bind", 'duration' => "1 minute", 'range' => "30m", 'area' => "Single"},
          {'name' => "Quake", 'duration' => "Instant", 'range' => "100m", 'area' => "20m radius"}
        ]
      when "Fire"
        available_spells = [
          {'name' => "Flame Bolt", 'duration' => "Instant", 'range' => "30m", 'area' => "Single"},
          {'name' => "Fire Shield", 'duration' => "10 minutes", 'range' => "Self", 'area' => "Self"},
          {'name' => "Fireball", 'duration' => "Instant", 'range' => "50m", 'area' => "5m radius"}
        ]
      when "Water"
        available_spells = [
          {'name' => "Ice Bolt", 'duration' => "Instant", 'range' => "30m", 'area' => "Single"},
          {'name' => "Water Walk", 'duration' => "1 hour", 'range' => "Touch", 'area' => "Single"},
          {'name' => "Freeze", 'duration' => "1 minute", 'range' => "20m", 'area' => "Single"}
        ]
      when "Air"
        available_spells = [
          {'name' => "Lightning", 'duration' => "Instant", 'range' => "50m", 'area' => "Single"},
          {'name' => "Wind Walk", 'duration' => "10 minutes", 'range' => "Touch", 'area' => "Single"},
          {'name' => "Storm", 'duration' => "10 minutes", 'range' => "100m", 'area' => "50m radius"}
        ]
      when "Death"
        available_spells = [
          {'name' => "Drain Life", 'duration' => "Instant", 'range' => "Touch", 'area' => "Single"},
          {'name' => "Animate Dead", 'duration' => "1 hour", 'range' => "10m", 'area' => "Corpse"},
          {'name' => "Death Touch", 'duration' => "Instant", 'range' => "Touch", 'area' => "Single"}
        ]
      else
        available_spells = [
          {'name' => "Magic Bolt", 'duration' => "Instant", 'range' => "30m", 'area' => "Single"}
        ]
      end
    end
    
    # Select random spells
    selected_spells = available_spells.sample([spell_count, available_spells.length].min)
    
    selected_spells.each do |spell|
      @spells << {
        'name' => spell['name'],
        'domain' => domain,
        'duration' => spell['duration'] || "Instant",
        'range' => spell['range'] || "Touch",
        'area' => spell['area'] || "Target"
      }
    end
  end
  
  public
  
  # Compatibility methods for encounter system
  def get_characteristic(char_name)
    @tiers[char_name]["level"] || 0
  end
  
  def get_attribute(char_name, attr_name)
    return 0 unless @tiers[char_name] && @tiers[char_name][attr_name]
    @tiers[char_name][attr_name]["level"] || 0
  end
  
  def get_skill(char_name, attr_name, skill_name)
    return 0 unless @tiers[char_name] && @tiers[char_name][attr_name]
    return 0 unless @tiers[char_name][attr_name]["skills"]
    @tiers[char_name][attr_name]["skills"][skill_name] || 0
  end
  
  
  def age
    "Unknown"
  end
  
  def height
    @SIZE * 20  # Rough estimate
  end
  
  def weight
    @SIZE * 10  # Rough estimate
  end
  
  def area
    "Wild"
  end
  
  def has_magic?
    # Check if monster has any casting ability
    return false unless @tiers["SPIRIT"] && @tiers["SPIRIT"]["Casting"]
    casting_level = @tiers["SPIRIT"]["Casting"]["level"] || 0
    casting_level > 0
  end
  
  def get_skill_total(char_name, attr_name, skill_name)
    # Calculate total: Characteristic + Attribute + Skill
    char_level = get_characteristic(char_name)
    attr_level = get_attribute(char_name, attr_name)
    skill_level = get_skill(char_name, attr_name, skill_name)
    
    char_level + attr_level + skill_level
  end
  
  # Additional methods for compatibility with detailed views
  def profession
    @type.to_s.gsub(/Monster:|Animal:/, "")
  end
  
  def cult
    nil  # Monsters don't have religions
  end
  
  def social_status
    "Wild"  # Monsters are outside society
  end
  
  def money
    0  # Monsters don't carry money
  end
  
  def equipment
    []  # Monsters don't have equipment
  end
end