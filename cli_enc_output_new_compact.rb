# Output module for new encounter system

def enc_output_new(e, cli)
  f = ""
  
  # Header with box characters
  width = 120
  f += "═" * width + "\n"
  
  # Day/Night and Terrain
  day_str = $Day == 1 ? "Day:   " : "Night: "
  terrain_str = case $Terrain
                when 0 then "City      "
                when 1 then "Rural     "
                when 2 then "Road      "
                when 3 then "Plains    "
                when 4 then "Hills     "
                when 5 then "Mountains "
                when 6 then "Woods     "
                when 7 then "Wilderness"
                end
  
  level_mod_str = "(Level mod = #{$Level || 0})"
  date_str = "Created: #{Date.today.to_s}"
  
  f += "#{day_str}#{terrain_str}#{level_mod_str}#{date_str.rjust(width - day_str.length - terrain_str.length - level_mod_str.length)}\n"
  f += "─" * width + "\n"
  
  # Check for no encounter
  if e.is_no_encounter?
    f += "\nNO ENCOUNTER\n\n"
    f += "═" * width + "\n"
  else
    # Show attitude and summary
    f += "#{e.enc_attitude}: #{e.summary}\n"
    f += "─" * width + "\n\n"
  
    # List all NPCs in the encounter
    e.encounter.each_with_index do |enc_data, index|
      break if enc_data["string"] =~ /Event:/
      
      npc = enc_data["npc"]
      next unless npc
      
      # Format: Name (Sex, actual name) [Lvl X]
      name_str = npc.name.empty? ? enc_data["string"] : npc.name
      f += "  #{name_str} (#{npc.sex}, #{npc.name}) [Lvl #{npc.level}]\n"
      f += "  ".ljust(15)
    
      # Show key stats in compact format like old system
      # SIZE, Strength, Endurance, Awareness, Magic capability, Reaction Speed, Dodge
      body = npc.get_characteristic("BODY")
      mind = npc.get_characteristic("MIND")
      spirit = npc.get_characteristic("SPIRIT")
      
      str_attr = npc.get_attribute("BODY", "Strength")
      end_attr = npc.get_attribute("BODY", "Endurance")
      awr_attr = npc.get_attribute("MIND", "Awareness")
      reaction_skill = npc.get_skill("MIND", "Awareness", "Reaction speed")
      dodge_skill = npc.get_skill("BODY", "Athletics", "Dodge")
      
      str_total = body + str_attr
      end_total = body + end_attr
      awr_total = mind + awr_attr
      mag_total = spirit
      rs_total = mind + awr_attr + reaction_skill
      dodge_total = body + npc.get_attribute("BODY", "Athletics") + dodge_skill
      
      # Calculate ENC penalty
      strength = npc.get_attribute("BODY", "Strength") + body
      base_capacity = strength * 5
      total_weight = npc.ENC || 0
      
      enc_penalty = if total_weight <= base_capacity
        0
      elsif total_weight <= base_capacity * 2
        -1
      elsif total_weight <= base_capacity * 5
        -3
      elsif total_weight <= base_capacity * 10
        -5
      else
        -7
      end
      
      f += " SIZ=#{npc.SIZE}"
      f += "  STR=#{str_total}"
      f += "  END=#{end_total}"
      f += "  AWR=#{awr_total}"
      f += "  MAG=#{mag_total}"
      f += "  RS=#{rs_total}"
      f += " Ddg=#{dodge_total}"
      f += "  (S:#{enc_penalty})\n"
      
      # Show magic lore if applicable
      if npc.spells && npc.spells.length > 0
        domain = npc.spells.first['domain'] if npc.spells.first
        casting = npc.get_attribute("SPIRIT", "Casting")
        f += "\n".ljust(17) + "#{domain || 'Magic'} Lore=#{spirit + casting}"
        f += ", # of spells: #{npc.spells.length}\n"
      end
      
      # Show best weapon
      melee_skills = npc.tiers["BODY"]["Melee Combat"]["skills"].select { |_, v| v > 0 }
      if melee_skills.any?
        best_melee = melee_skills.max_by { |_, v| v }
        if best_melee
          wpn_name = best_melee[0]
          wpn_skill = body + npc.get_attribute("BODY", "Melee Combat") + best_melee[1]
          wpn_stats = get_weapon_stats(wpn_name)
          wpn_ini = rs_total + (wpn_stats[:ini] || 0)
          
          f += "  " + wpn_name.ljust(14) + "Skill=" + wpn_skill.to_s.rjust(2)
          f += ", Ini:" + wpn_ini.to_s
          f += ", Off:" + (wpn_skill + wpn_stats[:off]).to_s.rjust(2)
          f += ", Def:" + (wpn_skill + wpn_stats[:def]).to_s.rjust(2)
          f += ", Dam:" + (npc.DB + wpn_stats[:dmg].to_i).to_s.rjust(2)
          f += "    AP:" + (npc.armor ? npc.armor[:ap] : 0).to_s
          f += ", BP:" + npc.BP.to_s + "\n"
        end
      end
      
      # Show best missile weapon if any
      missile_skills = npc.tiers["BODY"]["Missile Combat"]["skills"].select { |_, v| v > 0 }
      if missile_skills.any?
        best_missile = missile_skills.max_by { |_, v| v }
        if best_missile
          msl_name = best_missile[0]
          msl_skill = body + npc.get_attribute("BODY", "Missile Combat") + best_missile[1]
          msl_stats = get_missile_stats(msl_name)
          
          f += "  " + msl_name.ljust(14) + "Skill=" + msl_skill.to_s.rjust(2)
          f += ", SR:" + (msl_stats[:sr] || "1").to_s
          f += ", Off:" + msl_skill.to_s.rjust(2)
          f += ", Dam:" + (npc.DB + msl_stats[:dmg].to_i).to_s.rjust(2)
          f += ", Rng:" + msl_stats[:range] + "\n"
        end
      end
      
      f += "\n"
    end
  end
  
  f += "═" * width + "\n"
  
  # Output handling
  if cli == "cli"
    File.write("saved/encounter_new.npc", f, perm: 0644)
    print f
    
    if !e.is_no_encounter? && e.npcs.length > 0
      # Option to view detailed NPC
      puts "\nEnter NPC number (1-#{e.npcs.length}) to view details, 'v' to edit, or any other key to continue"
      input = STDIN.getch
      
      if input.to_i.between?(1, e.npcs.length)
        npc_output_new(e.get_npc(input.to_i - 1), "cli")
      elsif input == "v"
        system("#{$editor} saved/encounter_new.npc")
      end
    end
  else
    return f
  end
end

def terrain_name(terrain_type)
  case terrain_type
  when 0..2 then "Rural/Civilized"
  when 3..5 then "Wilderness"
  when 6..8 then "Dangerous Lands"
  else "Unknown"
  end
end

# Get weapon stats from tables
def get_weapon_stats(weapon)
  # Default values for weapons based on name patterns
  case weapon.downcase
  when /sword/
    { off: 0, def: 0, dmg: 1, ini: 0 }
  when /dagger/, /knife/
    { off: 1, def: -1, dmg: -1, ini: 1 }
  when /axe/
    { off: 0, def: -1, dmg: 2, ini: -1 }
  when /spear/, /pike/
    { off: 0, def: 1, dmg: 0, ini: 0 }
  when /mace/, /club/, /hammer/
    { off: -1, def: 0, dmg: 1, ini: -1 }
  when /staff/, /quarterstaff/
    { off: 0, def: 2, dmg: -1, ini: 0 }
  when /unarmed/
    { off: -2, def: -4, dmg: -4, ini: 2 }
  else
    { off: 0, def: 0, dmg: 0, ini: 0 }
  end
end

def get_missile_stats(weapon)
  # Default values for missile weapons
  case weapon.downcase
  when /longbow/
    { range: "150m", dmg: 1, sr: "1" }
  when /bow/
    { range: "100m", dmg: 0, sr: "1" }
  when /x-bow/, /crossbow/
    { range: "150m", dmg: 2, sr: "1/2" }
  when /sling/
    { range: "50m", dmg: -1, sr: "1" }
  when /throwing/, /javelin/
    { range: "30m", dmg: 0, sr: "1" }
  when /blowgun/
    { range: "20m", dmg: -5, sr: "2" }
  else
    { range: "30m", dmg: 0, sr: "1" }
  end
end