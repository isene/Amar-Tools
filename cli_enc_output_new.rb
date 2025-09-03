# Encounter output module showing full 3-tier system format

def enc_output_new(e, cli)
  # Clear screen before output if CLI mode
  if cli == "cli"
    system("clear") || system("cls")
  end
  
  f = ""
  
  # Get terminal width or use default
  if cli == "cli"
    width = `tput cols`.to_i rescue 120
    width = 120 if width < 120  # Minimum width
  else
    width = 120
  end
  
  # Define colors if terminal output
  if cli == "cli"
    # Colors for different elements
    @header_color = "\e[1;36m"     # Bright cyan
    @char_color = "\e[1;33m"       # Bright yellow  
    @attr_color = "\e[1;35m"       # Bright magenta
    @skill_color = "\e[0;37m"      # White
    @stat_color = "\e[1;32m"       # Bright green
    @special_color = "\e[38;5;202m" # Orange for special abilities
    @name_color = "\e[38;5;111m"    # Light blue for names
    @reset = "\e[0m"
  else
    @header_color = @char_color = @attr_color = @skill_color = ""
    @stat_color = @special_color = @name_color = @reset = ""
  end
  
  # Header with box characters (white)
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
  require 'date'
  date_str = "Created: #{Date.today.to_s}"
  
  f += "#{day_str}#{terrain_str}#{level_mod_str}#{date_str.rjust(width - day_str.length - terrain_str.length - level_mod_str.length)}\n"
  f += "─" * width + "\n"
  
  # Check for no encounter
  if e.is_no_encounter?
    f += "\n#{@desc_color}NO ENCOUNTER#{@reset}\n\n"
    f += "═" * width + "\n"
  else
    # Show attitude and summary with color based on attitude
    attitude_color = case e.enc_attitude
                     when "HOSTILE" then "\e[1;31m"      # Red
                     when "ANTAGONISTIC" then "\e[38;5;208m" # Orange
                     when "NEUTRAL" then "\e[1;37m"      # White
                     when "POSITIVE" then "\e[1;32m"     # Green
                     when "FRIENDLY" then "\e[1;36m"     # Cyan
                     else "\e[0;37m"
                     end if cli == "cli"
    attitude_color ||= ""
    
    # Use color 229 for the encounter line
    f += "\e[38;5;229m#{e.enc_attitude}: #{e.summary}#{@reset}\n" if cli == "cli"
    f += "#{e.enc_attitude}: #{e.summary}\n" unless cli == "cli"
    f += "─" * width + "\n"
    
    # List all NPCs in the encounter with 3-tier format
    e.encounter.each_with_index do |enc_data, index|
      break if enc_data["string"] =~ /Event:/
      
      npc = enc_data["npc"]
      next unless npc
      
      # NPC header with color
      name_str = npc.name.empty? ? enc_data["string"] : npc.name
      type_str = npc.respond_to?(:type) ? npc.type : "Unknown"
      age_str = npc.respond_to?(:age) ? npc.age : "Unknown"
      f += "\n#{@name_color}#{index + 1}. #{name_str} (#{npc.sex}, #{age_str}) - #{type_str} [Level #{npc.level}]#{@reset}\n"
      f += "   " + "─" * (width - 10) + "\n"
      
      # Show 3-tier stats in compact format
      if npc.respond_to?(:tiers) && npc.tiers
        # BODY section with three columns layout
        body = npc.get_characteristic("BODY")
        mind = npc.get_characteristic("MIND")
        spirit = npc.get_characteristic("SPIRIT")
        
        # Build columns
        body_lines = []
        mind_lines = []
        spirit_lines = []
        
        # BODY column
        body_lines << "#{@char_color}BODY (#{body})#{@reset}"
        
        # Show key BODY attributes with skills
        str_attr = npc.get_attribute("BODY", "Strength")
        if str_attr > 0
          body_lines << " #{@attr_color}Strength (#{str_attr})#{@reset}"
        end
        
        end_attr = npc.get_attribute("BODY", "Endurance")
        if end_attr > 0
          body_lines << " #{@attr_color}Endurance (#{end_attr})#{@reset}"
        end
        
        # Melee combat skills with weapon stats
        if npc.tiers["BODY"]["Melee Combat"]
          melee_attr = npc.get_attribute("BODY", "Melee Combat")
          melee_skills = npc.tiers["BODY"]["Melee Combat"]["skills"].select { |_, v| v > 0 }
          if melee_skills.any?
            body_lines << " #{@attr_color}Melee Combat (#{melee_attr})#{@reset}"
            melee_skills.each do |skill, value|
              total = body + melee_attr + value
              # Get weapon stats
              wpn_stats = get_weapon_stats(skill)
              reaction_speed = mind + npc.get_attribute("MIND", "Awareness") + npc.get_skill("MIND", "Awareness", "Reaction speed")
              ini = reaction_speed + (wpn_stats[:ini] || 0)
              off = total + wpn_stats[:off]
              def_val = total + wpn_stats[:def]
              dmg = npc.DB + wpn_stats[:dmg]
              
              body_lines << "  #{@skill_color}#{skill.ljust(18)}: Skl:#{total} Ini:#{ini} Off:#{off} Def:#{def_val} Dmg:#{dmg}#{@reset}"
            end
          end
        end
        
        # Missile combat skills if any
        if npc.tiers["BODY"]["Missile Combat"]
          missile_attr = npc.get_attribute("BODY", "Missile Combat")
          missile_skills = npc.tiers["BODY"]["Missile Combat"]["skills"].select { |_, v| v > 0 }
          if missile_skills.any?
            body_lines << " #{@attr_color}Missile Combat (#{missile_attr})#{@reset}"
            missile_skills.each do |skill, value|
              total = body + missile_attr + value
              # Get missile weapon stats
              msl_stats = get_missile_stats(skill)
              off = total
              dmg = npc.DB + msl_stats[:dmg]
              
              body_lines << "  #{@skill_color}#{skill.ljust(18)}: Skl:#{total} Rng:#{msl_stats[:range]} Dmg:#{dmg}#{@reset}"
            end
          end
        end
        
        # Athletics skills (always show key ones)
        athletics_attr = npc.get_attribute("BODY", "Athletics")
        if athletics_attr >= 0
          body_lines << " #{@attr_color}Athletics (#{athletics_attr})#{@reset}"
          
          # Always show these essential skills even if 0
          dodge = npc.get_skill("BODY", "Athletics", "Dodge")
          hide = npc.get_skill("BODY", "Athletics", "Hide")
          move_quietly = npc.get_skill("BODY", "Athletics", "Move Quietly")
          
          dodge_total = body + athletics_attr + dodge
          hide_total = body + athletics_attr + hide
          move_total = body + athletics_attr + move_quietly
          
          body_lines << "  #{@skill_color}Dodge: #{dodge_total}#{@reset}"
          body_lines << "  #{@skill_color}Hide: #{hide_total}#{@reset}"
          body_lines << "  #{@skill_color}Move Quietly: #{move_total}#{@reset}"
        end
        
        # MIND column
        mind_lines << "#{@char_color}MIND (#{mind})#{@reset}"
        
        # Awareness (always show key skills)
        awr_attr = npc.get_attribute("MIND", "Awareness")
        if awr_attr >= 0
          mind_lines << " #{@attr_color}Awareness (#{awr_attr})#{@reset}"
          
          # Essential awareness skills
          reaction = npc.get_skill("MIND", "Awareness", "Reaction speed")
          alertness = npc.get_skill("MIND", "Awareness", "Alertness") 
          tracking = npc.get_skill("MIND", "Awareness", "Tracking")
          
          reaction_total = mind + awr_attr + reaction
          alertness_total = mind + awr_attr + alertness
          tracking_total = mind + awr_attr + tracking
          
          mind_lines << "  #{@skill_color}Reaction speed: #{reaction_total}#{@reset}"
          mind_lines << "  #{@skill_color}Alertness: #{alertness_total}#{@reset}"
          if tracking > 0  # Only show tracking if non-zero
            mind_lines << "  #{@skill_color}Tracking: #{tracking_total}#{@reset}"
          end
        end
        
        # SPIRIT column (only if non-zero)
        if spirit > 0
          spirit_lines << "#{@char_color}SPIRIT (#{spirit})#{@reset}"
          
          # Show casting if applicable
          if npc.respond_to?(:spells) && npc.spells && npc.spells.length > 0
            casting = npc.get_attribute("SPIRIT", "Casting")
            spirit_lines << " #{@attr_color}Casting (#{casting})#{@reset}"
            spell_names = npc.spells.take(3).map{|s| s['name']}.join(', ')
            spirit_lines << "  #{@skill_color}Spells(#{npc.spells.length}): #{spell_names}#{'...' if npc.spells.length > 3}#{@reset}"
          end
        end
        
        # Output columns in three-column layout
        col_width = (width - 6) / 3
        max_lines = [body_lines.length, mind_lines.length, spirit_lines.length].max
        
        max_lines.times do |i|
          body_text = body_lines[i] || ""
          mind_text = mind_lines[i] || ""
          spirit_text = spirit_lines[i] || ""
          
          # Strip color codes for length calculation
          body_plain = body_text.gsub(/\e\[[0-9;]*m/, '')
          mind_plain = mind_text.gsub(/\e\[[0-9;]*m/, '')
          spirit_plain = spirit_text.gsub(/\e\[[0-9;]*m/, '')
          
          # Add padding
          body_padded = body_text + ' ' * [0, col_width - body_plain.length].max
          mind_padded = mind_text + ' ' * [0, col_width - mind_plain.length].max
          spirit_padded = spirit_text
          
          f += "   #{body_padded}#{mind_padded}#{spirit_padded}\n"
        end
      end
      
      # Derived stats
      f += "   " + "─" * (width - 10) + "\n"
      
      # Check if NPC has spells and show domain lore on separate line
      if npc.respond_to?(:spells) && npc.spells && npc.spells.length > 0
        # Determine primary spell domain
        domain = nil
        domain_skill = 0
        
        if npc.tiers["SPIRIT"] && npc.tiers["SPIRIT"]["Attunement"] && npc.tiers["SPIRIT"]["Attunement"]["skills"]
          # Find highest attunement domain
          npc.tiers["SPIRIT"]["Attunement"]["skills"].each do |dom, val|
            if val > domain_skill
              domain = dom
              domain_skill = val
            end
          end
        end
        
        # Show domain lore and spell count
        if domain && domain_skill > 0
          total_lore = spirit + npc.get_attribute("SPIRIT", "Attunement") + domain_skill
          f += "   #{@stat_color}#{domain} Lore: #{total_lore}, # of spells: #{npc.spells.length}#{@reset}\n"
        end
      end
      
      f += "   #{@stat_color}SIZE: #{npc.SIZE}    BP: #{npc.BP}    DB: #{npc.DB}    MD: #{npc.MD}"
      if npc.armor
        f += "    Armor: #{npc.armor[:name]} (AP: #{npc.armor[:ap]})"
      end
      f += "#{@reset}\n"
      
      # Equipment and money for humanoids (not monsters)
      if npc.respond_to?(:type) && !npc.type.to_s.match(/Monster:|Animal:|monster/i)
        # Load equipment generation if not loaded
        unless defined?(generate_equipment)
          load File.join($pgmdir, "cli_npc_output_new.rb")
        end
        
        # Generate equipment and money
        equipment = generate_equipment(npc.type, npc.level)
        
        # Determine social status for money calculation
        social_status = case npc.type
        when /Noble/ then "N"
        when /Merchant/ then "UC"
        when /Priest/ then "MC"
        when /Smith/, /Bard/ then "LMC"
        else "LC"
        end
        
        money = generate_money(social_status, npc.level)
        
        # Convert money format
        money_value = money.split(' ').first.to_i
        money_str = if money_value >= 100
          gp = money_value / 100
          sp = (money_value % 100) / 10
          cp = money_value % 10
          parts = []
          parts << "#{gp}gp" if gp > 0
          parts << "#{sp}sp" if sp > 0
          parts << "#{cp}cp" if cp > 0
          parts.join(' ')
        elsif money_value >= 10
          sp = money_value / 10
          cp = money_value % 10
          parts = []
          parts << "#{sp}sp" if sp > 0
          parts << "#{cp}cp" if cp > 0
          parts.join(' ')
        else
          "#{money_value}cp"
        end
        
        f += "   #{@stat_color}Equipment: #{equipment.join(', ')} | Money: #{money_str}#{@reset}\n"
      end
      
      # Special abilities for monsters
      if npc.respond_to?(:special_abilities) && npc.special_abilities
        f += "   #{@special_color}Special: #{npc.special_abilities}#{@reset}\n"
      end
    end
  end
  
  f += "\n" + ("═" * width) + "\n"
  
  # Output handling
  if cli == "cli"
    File.write("saved/encounter_new.npc", f, perm: 0644)
    print f
    
    if !e.is_no_encounter? && e.npcs.length > 0
      # Option to view detailed NPC
      puts "\nEnter NPC number (1-#{e.npcs.length}) for details, 'v' to view in less, 'e' to edit, or any other key to continue"
      input = STDIN.getc
      
      if input.to_i.between?(1, e.npcs.length)
        # Load the NPC output module if not loaded
        unless defined?(npc_output_new)
          load File.join($pgmdir, "cli_npc_output_new.rb")
        end
        npc_output_new(e.get_npc(input.to_i - 1), "cli")
      elsif input == "v"
        system("less saved/encounter_new.npc")
      elsif input == "e"
        system("#{$editor} saved/encounter_new.npc")
      end
    end
  else
    return f
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
  when /natural/, /claw/, /bite/, /tail/, /tusk/
    { off: 0, def: -2, dmg: 0, ini: 1 }
  when /unarmed/
    { off: -2, def: -4, dmg: -4, ini: 2 }
  when /grappl/
    { off: 0, def: 0, dmg: -2, ini: 0 }
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

# Keep the old compact format as an alternative
def enc_output_new_compact(e, cli)
  # This would be the current enc_output_new function
  # Keeping it for quick combat reference
  enc_output_new(e, cli)
end