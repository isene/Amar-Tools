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
    
    # Generate NPCs
    generate_npcs_from_tables
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
    case enc_string.downcase
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