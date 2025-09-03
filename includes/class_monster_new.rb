# Monster/Animal NPC class for the new 3-tier system
# This creates simplified NPCs for non-humanoid encounters

class MonsterNew
  attr_accessor :name, :type, :level, :sex, :description
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
    
    # Generate size
    size_range = stats["size_range"] || [8, 10]
    @SIZE = rand(size_range[0]..size_range[1])
    
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
end