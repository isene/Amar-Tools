# New Encounter class for the 3-tier system

class EncNew
  attr_reader :terrain, :terraintype, :enc, :enc_spec, :enc_number, :enc_attitude
  attr_reader :npcs, :encounter
  
  def initialize(enc_spec = "", enc_number = 0, terraintype = nil, level_mod = 0)
    # Set defaults
    @terraintype = terraintype || $Terraintype || 8  # Default to day/rural
    @level_mod = level_mod || $Level || 0
    @terrain = @terraintype % 8  # Extract terrain from terraintype
    @day = @terraintype >= 8 ? 1 : 0  # Extract day/night
    
    @enc_spec = enc_spec.to_s
    @enc_number = enc_number.to_i
    @encounter = []
    @npcs = []
    
    # Load tables if not loaded
    unless defined?($Enc_type)
      load File.join($pgmdir, "includes/tables/enc_type.rb")
      load File.join($pgmdir, "includes/tables/enc_specific.rb")
      load File.join($pgmdir, "includes/tables/encounters.rb")
    end
    
    # Generate attitude
    generate_attitude
    
    # Generate the encounter
    if @enc_spec.empty?
      generate_random_encounter
    else
      generate_specific_encounter
    end
  end
  
  private
  
  def generate_attitude
    # Generate encounter attitude
    case d6
    when 1
      @enc_attitude = "HOSTILE"
    when 2
      @enc_attitude = "ANTAGONISTIC"
    when 3..4
      @enc_attitude = "NEUTRAL"
    when 5
      @enc_attitude = "POSITIVE"
    when 6
      @enc_attitude = "FRIENDLY"
    end
  end
  
  def generate_random_encounter
    # Use the encounter tables from old system
    enc_terrain = {}
    $Enc_type.each do |key, value|
      enc_terrain[key] = value[@terraintype]
    end
    
    @enc_type = randomizer(enc_terrain)
    
    # Handle no encounter
    if @enc_type =~ /NO ENCOUNTER/
      @encounter[0] = {}
      @encounter[0]["string"] = "NO ENCOUNTER"
      return
    end
    
    # Get specific encounter from type
    if defined?($Enc_specific) && $Enc_specific[@enc_type]
      enc_terrain2 = {}
      $Enc_specific[@enc_type].each do |key, value|
        enc_terrain2[key] = value[@terraintype]
      end
      @enc_spec = randomizer(enc_terrain2)
    else
      # Fallback to basic type
      @enc_spec = @enc_type
    end
    
    # Generate number of encounters
    if @enc_number == 0
      case oD6
      when -Float::INFINITY..3
        @enc_number = 1
      when 4
        @enc_number = dX(3)
      when 5
        @enc_number = d6
      when 6..7
        @enc_number = 2 * d6
      else
        @enc_number = 3 * d6
      end
      @enc_number = 5 if @enc_number > 5 && @enc_type =~ /onster/
    end
    
    # For humanoid encounters, sometimes create mixed groups
    if @enc_type =~ /human/i && @enc_number > 3 && rand(100) < 30
      generate_mixed_group
    else
      # Generate NPCs normally
      generate_npcs_from_tables
    end
  end
  
  def generate_specific_encounter
    @enc = @enc_spec
    @enc_type = "human"  # Default type
    
    # Generate number if not specified
    if @enc_number == 0
      @enc_number = rand(6) + 1
    end
    
    # Generate NPCs
    generate_npcs_from_tables
  end
  
  def generate_mixed_group
    # Create a diverse but logical group
    # Examples: merchant caravan, adventuring party, soldiers with support
    
    # Load required classes if needed
    unless defined?(NpcNew)
      load File.join($pgmdir, "includes/class_npc_new.rb")
    end
    
    group_type = rand(100)
    
    if group_type < 25
      # Merchant caravan
      leader_count = 1 + rand(2)
      guard_count = (@enc_number - leader_count) * 2 / 3
      worker_count = @enc_number - leader_count - guard_count
      
      enc_types = []
      leader_count.times { enc_types << "Merchant" }
      guard_count.times { enc_types << ["Guard", "Warrior", "Soldier"].sample }
      worker_count.times { enc_types << ["Worker", "Farmer", "Porter"].sample }
      
      @enc_spec = "Mixed merchant caravan"
    elsif group_type < 50
      # Adventuring party
      enc_types = []
      enc_types << ["Warrior", "Soldier", "Gladiator"].sample
      enc_types << ["Priest", "Cleric", "Healer"].sample if @enc_number > 2
      enc_types << ["Wizard (fire)", "Wizard (water)", "Wizard (air)", "Wizard (earth)"].sample if @enc_number > 3
      enc_types << ["Thief", "Ranger", "Scout"].sample if @enc_number > 4
      
      # Fill rest with warriors/fighters
      while enc_types.length < @enc_number
        enc_types << ["Warrior", "Ranger", "Soldier", "Guard"].sample
      end
      
      @enc_spec = "Adventuring party"
    elsif group_type < 75
      # Military patrol
      officer_count = 1
      soldier_count = @enc_number - 1
      
      enc_types = []
      officer_count.times { enc_types << "Army officer" }
      soldier_count.times { enc_types << ["Soldier", "Guard", "Warrior"].sample }
      
      @enc_spec = "Military patrol"
    else
      # Bandits/thieves
      leader_count = 1
      thief_count = (@enc_number - leader_count) / 2
      muscle_count = @enc_number - leader_count - thief_count
      
      enc_types = []
      leader_count.times { enc_types << ["Assassin", "Highwayman", "Bandit"].sample }
      thief_count.times { enc_types << ["Thief", "Rogue", "Highwayman"].sample }
      muscle_count.times { enc_types << ["Warrior", "Barbarian", "Thug"].sample }
      
      @enc_spec = "Bandit group"
    end
    
    # Generate the NPCs
    enc_types.shuffle! # Randomize order
    
    @enc_number.times do |i|
      @encounter[i] = {}
      @encounter[i]["string"] = enc_types[i] || "Commoner"
      
      # Generate level with some variety
      base_level = rand(3) + 1 + @level_mod
      if i == 0 && group_type != 50  # Leader gets bonus (except adventuring party)
        base_level += 1
      end
      @encounter[i]["level"] = [base_level, 1].max
      
      # Generate sex
      @encounter[i]["sex"] = rand(2) == 0 ? "F" : "M"
      
      # Create NPC
      npc = NpcNew.new(
        "",  # Name will be generated
        enc_types[i] || "Commoner",
        @encounter[i]["level"],
        "",  # Area
        @encounter[i]["sex"],
        0,   # Age will be generated
        0,   # Height will be generated
        0,   # Weight will be generated
        ""   # Description
      )
      
      @encounter[i]["npc"] = npc
      @npcs << npc
    end
  end
  
  def generate_npcs_from_tables
    # Load required classes if needed
    unless defined?(MonsterNew)
      load File.join($pgmdir, "includes/class_monster_new.rb")
    end
    
    unless defined?(NpcNew)
      load File.join($pgmdir, "includes/class_npc_new.rb")
    end
    
    # Generate NPCs based on encounter tables
    @enc_number.times do |i|
      @encounter[i] = {}
      @encounter[i]["string"] = @enc_spec
      
      # Skip if event
      if @encounter[i]["string"] =~ /Event:/
        break
      end
      
      # Check if this is a monster/animal encounter
      if @enc_spec =~ /Monster:|Animal:|animal:/i
        # Generate level for monster
        if defined?($Encounters) && $Encounters[@enc_spec]
          stats = $Encounters[@enc_spec].dup
          base_level = stats[0].is_a?(Array) ? dX(stats[0]) : stats[0]
        else
          base_level = rand(3) + 1
        end
        
        @encounter[i]["level"] = base_level + @level_mod
        @encounter[i]["level"] = 1 if @encounter[i]["level"] < 1
        
        # Create monster/animal NPC
        npc = MonsterNew.new(@enc_spec, @encounter[i]["level"])
        @encounter[i]["sex"] = npc.sex
      else
        # Handle humanoid encounters
        # Get stats from encounter table if exists
        if defined?($Encounters) && $Encounters[@enc_spec]
          stats = $Encounters[@enc_spec].dup
          
          # Generate level with modifier
          base_level = stats[0].is_a?(Array) ? dX(stats[0]) : stats[0]
          @encounter[i]["level"] = base_level + @level_mod
          @encounter[i]["level"] += 2 if @enc_spec =~ /Elf/
          @encounter[i]["level"] += 1 if @enc_spec =~ /Dwarf/
          @encounter[i]["level"] = 1 if @encounter[i]["level"] < 1
          
          # Determine character type from encounter
          char_type = determine_character_type(@enc_spec)
        else
          # Fallback values
          @encounter[i]["level"] = rand(3) + 1 + @level_mod
          @encounter[i]["level"] = 1 if @encounter[i]["level"] < 1
          char_type = determine_character_type(@enc_spec)
        end
        
        # Generate sex
        @encounter[i]["sex"] = rand(2) == 0 ? "F" : "M"
        @encounter[i]["sex"] = "M" if @enc_spec =~ /officer/ && rand(6) != 0
        @encounter[i]["sex"] = "F" if @enc_spec =~ /Prostitute/ && rand(10) != 0
        @encounter[i]["sex"] = "F" if @enc_spec =~ /Nanny/ && rand(10) != 0
        @encounter[i]["sex"] = "F" if @enc_spec =~ /wife/
        
        # Create NPC with new system
        npc = NpcNew.new(
          "",  # Name will be generated
          char_type,
          @encounter[i]["level"],
          "",  # Area
          @encounter[i]["sex"],
          0,   # Age will be generated
          0,   # Height will be generated
          0,   # Weight will be generated
          ""   # Description
        )
      end
      
      @encounter[i]["npc"] = npc
      @npcs << npc
    end
  end
  
  def determine_character_type(enc_string)
    # Map encounter strings to character types
    # Check if encounter string already has race prefix
    if enc_string =~ /^(\w+):\s+(.+)/
      race = $1
      profession = $2
      
      # Map profession to appropriate type for that race
      base_type = case profession.downcase
      when /warrior/, /soldier/, /fighter/
        "Warrior"
      when /ranger/, /scout/, /hunter/
        "Ranger"
      when /mage/, /wizard/, /sorcerer/
        "Mage"
      when /thief/, /rogue/, /bandit/
        "Thief"
      when /smith/, /blacksmith/
        "Smith"
      when /guard/, /watchman/
        "Guard"
      when /priest/, /cleric/
        "Priest"
      when /merchant/, /trader/
        "Merchant"
      when /noble/, /lord/, /lady/
        "Noble"
      when /commoner/, /farmer/, /peasant/
        "Commoner"
      else
        "Warrior"  # Default to warrior
      end
      
      # Return race-specific type if it exists in templates
      race_type = "#{race}: #{base_type}"
      
      # Check if this race-type combo exists in templates
      if defined?($ChartypeNew) && $ChartypeNew.key?(race_type)
        return race_type
      elsif defined?($RaceTemplates) && $RaceTemplates.key?(race_type)
        return race_type
      else
        # Try alternate names
        alt_types = []
        case base_type
        when "Mage"
          alt_types = ["Wizard", "Sorcerer"]
        when "Warrior"
          alt_types = ["Fighter", "Soldier"]
        when "Ranger"
          alt_types = ["Scout", "Hunter"]
        end
        
        for alt in alt_types
          alt_race_type = "#{race}: #{alt}"
          if (defined?($ChartypeNew) && $ChartypeNew.key?(alt_race_type)) ||
             (defined?($RaceTemplates) && $RaceTemplates.key?(alt_race_type))
            return alt_race_type
          end
        end
        
        # Fallback to generic warrior for that race
        return "#{race}: Warrior"
      end
    end
    
    # Original logic for encounters without race prefix
    case enc_string.downcase
    when /elf/
      # Elves can be various types
      ["Elf: Ranger", "Elf: Warrior", "Elf: Mage"].sample
    when /dwarf/
      # Dwarves are typically warriors or smiths
      ["Dwarf: Warrior", "Dwarf: Smith", "Dwarf: Guard"].sample
    when /araxi/, /arax/
      # Araxi are savage predatory warriors
      "Araxi: Warrior"
    when /troll/
      "Troll: Warrior"
    when /ogre/
      "Ogre: Warrior"
    when /lizard/
      "Lizard Man: Warrior"
    when /goblin/
      ["Goblin: Warrior", "Goblin: Thief"].sample
    when /centaur/
      ["Centaur: Warrior", "Centaur: Ranger"].sample
    when /faer/
      "Faerie: Mage"
    # Then check for profession-based encounters
    when /warrior/, /soldier/, /guard/
      "Warrior"
    when /merchant/, /trader/, /caravan/
      "Merchant"
    when /thief/, /bandit/, /robber/
      "Thief"
    when /wizard/, /mage/, /sorcerer/
      ["Wizard (fire)", "Wizard (water)", "Wizard (air)", "Wizard (earth)"].sample
    when /priest/, /cleric/, /monk/
      "Priest"
    when /ranger/, /scout/, /hunter/
      "Ranger"
    when /noble/, /lord/, /lady/
      "Noble"
    when /barbarian/
      "Barbarian"
    when /assassin/
      "Assassin"
    when /gladiator/
      "Gladiator"
    when /smith/, /blacksmith/, /weaponsmith/, /armorer/
      "Smith"
    when /farmer/, /peasant/, /laborer/
      "Farmer"
    when /sailor/, /seaman/, /mariner/
      "Sailor"
    when /bard/, /minstrel/, /storyteller/
      "Bard"
    when /sage/, /scholar/, /learned/, /wise/
      "Sage"
    when /scribe/, /clerk/, /secretary/
      "Scribe"
    when /healer/, /physician/, /apothecary/
      "Healer"
    when /entertainer/, /actor/, /dancer/
      "Entertainer"
    when /artisan/, /craftsman/, /crafter/
      "Artisan"
    when /guard/, /watchman/
      "Guard"
    else
      "Commoner"
    end
  end
  
  # Helper methods from old system
  def d6
    rand(6) + 1
  end
  
  def oD6
    d6 + rand(3) - 1
  end
  
  def dX(x)
    return 0 if x <= 0
    if x.is_a?(Array)
      x = x.first.to_i
    end
    sum = 0
    x.times { sum += d6 }
    sum
  end
  
  def randomizer(hash)
    # Weight-based random selection
    total = hash.values.sum
    return "" if total == 0
    
    roll = rand(total) + 1
    cumulative = 0
    
    hash.each do |key, weight|
      cumulative += weight
      return key if roll <= cumulative
    end
    
    hash.keys.first
  end
  
  public
  
  def summary
    if @encounter.first && @encounter.first["string"] == "NO ENCOUNTER"
      "NO ENCOUNTER"
    else
      "#{@enc_number} #{@enc_spec}"
    end
  end
  
  def get_npc(index)
    @npcs[index] if index < @npcs.length
  end
  
  def total_threat_level
    @npcs.sum { |npc| npc.level }
  end
  
  def is_no_encounter?
    @encounter.first && @encounter.first["string"] == "NO ENCOUNTER"
  end
end