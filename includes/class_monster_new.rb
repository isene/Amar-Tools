# Monster/Animal NPC class for the new 3-tier system
# This creates simplified NPCs for non-humanoid encounters

class MonsterNew
  attr_accessor :name, :type, :level, :sex, :description
  attr_accessor :SIZE, :BP, :DB, :MD, :ENC
  attr_accessor :tiers, :armor, :special_abilities
  
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
        "Casting" => { "level" => 0 },
        "Attunement" => { "level" => 0 }
      }
    }
    
    # Calculate derived stats
    calculate_derived_stats
    
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
  
  def spells
    nil  # Most monsters don't have spells
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