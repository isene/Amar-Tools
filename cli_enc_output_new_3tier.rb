# Encounter output module showing full 3-tier system format

def enc_output_new_3tier(e, cli)
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
    
    # List all NPCs in the encounter with 3-tier format
    e.encounter.each_with_index do |enc_data, index|
      break if enc_data["string"] =~ /Event:/
      
      npc = enc_data["npc"]
      next unless npc
      
      # NPC header
      name_str = npc.name.empty? ? enc_data["string"] : npc.name
      type_str = npc.respond_to?(:type) ? npc.type : "Unknown"
      f += "#{index + 1}. #{name_str} (#{npc.sex}) - #{type_str} [Level #{npc.level}]\n"
      f += "   " + "─" * 80 + "\n"
      
      # Show 3-tier stats in compact format
      if npc.respond_to?(:tiers) && npc.tiers
        # BODY section
        body = npc.get_characteristic("BODY")
        f += "   BODY (#{body})\n"
        
        # Show key BODY attributes with skills
        str_attr = npc.get_attribute("BODY", "Strength")
        if str_attr > 0
          f += "    Strength (#{str_attr})\n"
        end
        
        end_attr = npc.get_attribute("BODY", "Endurance")
        if end_attr > 0
          f += "    Endurance (#{end_attr})\n"
        end
        
        # Melee combat skills
        if npc.tiers["BODY"]["Melee Combat"]
          melee_attr = npc.get_attribute("BODY", "Melee Combat")
          melee_skills = npc.tiers["BODY"]["Melee Combat"]["skills"].select { |_, v| v > 0 }
          if melee_skills.any?
            f += "    Melee Combat (#{melee_attr})\n"
            melee_skills.each do |skill, value|
              total = body + melee_attr + value
              f += "      #{skill.ljust(20)}: #{body}+#{melee_attr}+#{value} = #{total}\n"
            end
          end
        end
        
        # Athletics skills (only if non-zero)
        athletics_attr = npc.get_attribute("BODY", "Athletics")
        dodge = npc.get_skill("BODY", "Athletics", "Dodge")
        if dodge > 0
          f += "    Athletics (#{athletics_attr})\n"
          f += "      Dodge: #{body}+#{athletics_attr}+#{dodge} = #{body + athletics_attr + dodge}\n"
        end
        
        # MIND section
        mind = npc.get_characteristic("MIND")
        f += "   MIND (#{mind})\n"
        
        # Awareness
        awr_attr = npc.get_attribute("MIND", "Awareness")
        if awr_attr > 0
          reaction = npc.get_skill("MIND", "Awareness", "Reaction speed")
          tracking = npc.get_skill("MIND", "Awareness", "Tracking")
          
          if reaction > 0 || tracking > 0
            f += "    Awareness (#{awr_attr})\n"
            if reaction > 0
              f += "      Reaction speed: #{mind}+#{awr_attr}+#{reaction} = #{mind + awr_attr + reaction}\n"
            end
            if tracking > 0
              f += "      Tracking: #{mind}+#{awr_attr}+#{tracking} = #{mind + awr_attr + tracking}\n"
            end
          end
        end
        
        # SPIRIT section (only if non-zero)
        spirit = npc.get_characteristic("SPIRIT")
        if spirit > 0
          f += "   SPIRIT (#{spirit})\n"
          
          # Show casting if applicable
          if npc.respond_to?(:spells) && npc.spells && npc.spells.length > 0
            casting = npc.get_attribute("SPIRIT", "Casting")
            f += "    Casting (#{casting})\n"
            f += "      Spells: #{npc.spells.length} (#{npc.spells.take(3).map{|s| s['name']}.join(', ')}#{'...' if npc.spells.length > 3})\n"
          end
        end
      end
      
      # Derived stats
      f += "   " + "─" * 80 + "\n"
      f += "   SIZE: #{npc.SIZE}    BP: #{npc.BP}    DB: #{npc.DB}    MD: #{npc.MD}"
      if npc.armor
        f += "    Armor: #{npc.armor[:name]} (AP: #{npc.armor[:ap]})"
      end
      f += "\n"
      
      # Special abilities for monsters
      if npc.respond_to?(:special_abilities) && npc.special_abilities
        f += "   Special: #{npc.special_abilities}\n"
      end
      
      f += "\n"
    end
  end
  
  f += "═" * width + "\n"
  
  # Output handling
  if cli == "cli"
    # Save clean version without ANSI codes for editing
    File.write("saved/encounter_new.npc", f.pure, perm: 0644)
    # Display version with colors
    print f
    
    if !e.is_no_encounter? && e.npcs.length > 0
      # Option to view detailed NPC
      puts "\nEnter NPC number (1-#{e.npcs.length}) to view full details, 'e' to edit, or any other key to continue"
      input = STDIN.getch
      
      if input.to_i.between?(1, e.npcs.length)
        # Load the NPC output module if not loaded
        unless defined?(npc_output_new)
          load File.join($pgmdir, "cli_npc_output_new.rb")
        end
        npc_output_new(e.get_npc(input.to_i - 1), "cli")
      elsif input == "e"
        # Use vim with settings to avoid binary file warnings
        if $editor.include?("vim") || $editor.include?("vi")
          system("#{$editor} -c 'set fileformat=unix' saved/encounter_new.npc")
        else
          system("#{$editor} saved/encounter_new.npc")
        end
      end
    end
  else
    return f
  end
end

# Keep the old compact format as an alternative
def enc_output_new_compact(e, cli)
  # This would be the current enc_output_new function
  # Keeping it for quick combat reference
  enc_output_new(e, cli)
end