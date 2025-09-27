# Encounter output module showing full 3-tier system format
require 'io/console'

# Try to load string_extensions for color support
begin
  require 'string_extensions'
rescue LoadError
  # Define a fallback pure method if string_extensions is not available
  class String
    def pure
      self.gsub(/\e\[[0-9;]*m/, '')
    end
  end
end

def enc_output_new(e, cli, custom_width = nil)
  # Clear screen before output if direct CLI mode
  if cli == "cli_direct"
    system("clear") || system("cls")
  end

  f = ""

  # Get terminal width or use default
  if custom_width
    width = custom_width
  elsif cli == "cli_direct"
    width = `tput cols`.to_i rescue 120
    width = 120 if width < 120  # Minimum width
  elsif cli == "cli"
    # For TUI, use a narrower width that fits in the content pane
    width = 80
  else
    width = 80
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
    @gray = "\e[38;5;240m"          # Gray for explanatory text
    @reset = "\e[0m"
  else
    @header_color = @char_color = @attr_color = @skill_color = ""
    @stat_color = @special_color = @name_color = @gray = @reset = ""
  end
  
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
      
      # Show 3-tier stats in reorganized format
      if npc.respond_to?(:tiers) && npc.tiers
        body = npc.get_characteristic("BODY")
        mind = npc.get_characteristic("MIND")
        spirit = npc.get_characteristic("SPIRIT")
        
        # Get all key stats
        str_attr = npc.get_attribute("BODY", "Strength")
        end_attr = npc.get_attribute("BODY", "Endurance")
        awareness_attr = npc.get_attribute("MIND", "Awareness")
        reaction_speed = mind + awareness_attr + npc.get_skill("MIND", "Awareness", "Reaction speed")
        
        # Calculate derived values
        bp_value = npc.BP.respond_to?(:round) ? npc.BP.round : npc.BP.to_i
        db_value = npc.DB.respond_to?(:round) ? npc.DB.round : npc.DB.to_i  
        md_value = npc.MD.respond_to?(:round) ? npc.MD.round : npc.MD.to_i
        
        # Line 1: SIZE, Characteristics and key attributes
        # Format SIZE for display
        size_display = npc.SIZE % 1 == 0.5 ? "#{npc.SIZE.floor}½" : npc.SIZE.to_s
        f += "   SIZE:#{size_display}  BODY:#{body}  Str:#{body + str_attr}  End:#{body + end_attr}"
        f += " | MIND:#{mind}  Awr:#{mind + awareness_attr}  RS:#{reaction_speed}"
        if spirit > 0
          f += " | SPIRIT:#{spirit}"
        end
        f += "\n"
        
        # Line 2: Derived stats and armor with combat totals (highlight BP/DB/MD/Reaction/Dodge)
        dodge_total = npc.get_skill_total("BODY", "Athletics", "Dodge") rescue 0
        reaction_total = npc.get_skill_total("BODY", "Athletics", "Reaction Speed") rescue 0

        f += "   #{@skill_color}BP:#{@reset}#{@stat_color}#{bp_value}#{@reset} #{@skill_color}DB:#{@reset}#{@stat_color}#{db_value}#{@reset} #{@skill_color}MD:#{@reset}#{@stat_color}#{md_value}#{@reset} #{@skill_color}Reaction:#{@reset}#{@stat_color}#{reaction_total}#{@reset} #{@skill_color}Dodge:#{@reset}#{@stat_color}#{dodge_total}#{@reset}"
        if npc.armor
          f += " Armor:#{npc.armor[:name]}(#{npc.armor[:ap]})"
        end
        
        # Calculate dodge bonus for defense
        athletics_attr = npc.get_attribute("BODY", "Athletics")
        dodge = npc.get_skill("BODY", "Athletics", "Dodge")
        dodge_total = body + athletics_attr + dodge
        dodge_bonus = (dodge_total / 5).to_i
        
        # Line 3: Skills and spells
        hide = npc.get_skill("BODY", "Athletics", "Hide")
        move_quietly = npc.get_skill("BODY", "Athletics", "Move Quietly")
        alertness = npc.get_skill("MIND", "Awareness", "Alertness")
        
        hide_total = body + athletics_attr + hide
        move_total = body + athletics_attr + move_quietly
        alertness_total = mind + awareness_attr + alertness
        
        f += "   Skills: #{@skill_color}Dodge:#{@reset}#{@stat_color}#{dodge_total}#{@reset} #{@skill_color}Hide:#{@reset}#{@stat_color}#{hide_total}#{@reset} #{@skill_color}MoveQ:#{@reset}#{@stat_color}#{move_total}#{@reset} #{@skill_color}Alert:#{@reset}#{@stat_color}#{alertness_total}#{@reset}"
        
        # Add tracking if non-zero
        tracking = npc.get_skill("MIND", "Awareness", "Tracking")
        if tracking > 0
          tracking_total = mind + awareness_attr + tracking
          f += " #{@skill_color}Track:#{@reset}#{@stat_color}#{tracking_total}#{@reset}"
        end
        
        # Show spells if any
        if npc.respond_to?(:spells) && npc.spells && npc.spells.length > 0
          spell_names = npc.spells.take(2).map{|s| s['name']}.join(', ')
          f += " Spells(#{npc.spells.length}): #{spell_names}#{'...' if npc.spells.length > 2}"
        end
        f += "\n"
        
        # Line 4 & 5: Weapons (melee and missile on separate lines)
        melee_weapons = []
        missile_weapons = []
        
        # Melee combat - use ORIGINAL weapon names with NEW skill calculations
        if npc.respond_to?(:melee1) && npc.melee1 && !npc.melee1.strip.empty?
          weapon_name = npc.melee1.strip
          skill = npc.melee1s || 0
          ini = npc.melee1i || 0
          off = npc.melee1o || 0
          def_val = npc.melee1d || 0
          dmg = npc.melee1dam || 0

          melee_weapons << "#{weapon_name} (#{skill}) I:#{ini} #{@stat_color}O:#{off}#{@reset} #{@stat_color}D:#{def_val}#{@reset} #{@stat_color}d:#{dmg}#{@reset}"
        end

        if npc.respond_to?(:melee2) && npc.melee2 && !npc.melee2.strip.empty?
          weapon_name = npc.melee2.strip
          skill = npc.melee2s || 0
          ini = npc.melee2i || 0
          off = npc.melee2o || 0
          def_val = npc.melee2d || 0
          dmg = npc.melee2dam || 0

          melee_weapons << "#{weapon_name} (#{skill}) I:#{ini} #{@stat_color}O:#{off}#{@reset} #{@stat_color}D:#{def_val}#{@reset} #{@stat_color}d:#{dmg}#{@reset}"
        end
        
        # Missile combat - use ORIGINAL weapon names
        if npc.respond_to?(:missile) && npc.missile && !npc.missile.strip.empty?
          weapon_name = npc.missile.strip
          skill = npc.missiles || 0
          off = npc.missileo || 0
          dmg = npc.missiledam || 0
          range = npc.missilerange ? "#{npc.missilerange}m" : "30m"

          missile_weapons << "#{weapon_name} (#{skill}) O:#{off} R:#{range} #{@stat_color}d:#{dmg}#{@reset}"
        end
        
        # Display weapons
        if melee_weapons.any?
          f += "   Weapons: #{melee_weapons.join(' | ')}\n"
        end
        if missile_weapons.any?
          f += "   Missile: #{missile_weapons.join(' | ')}"
          # Add spell lore info on same line as missile if applicable
          if npc.respond_to?(:spells) && npc.spells && npc.spells.length > 0
            domain = nil
            domain_skill = 0
            
            if npc.tiers["SPIRIT"] && npc.tiers["SPIRIT"]["Attunement"] && npc.tiers["SPIRIT"]["Attunement"]["skills"]
              npc.tiers["SPIRIT"]["Attunement"]["skills"].each do |dom, val|
                if val > domain_skill
                  domain = dom
                  domain_skill = val
                end
              end
            end
            
            if domain && domain_skill > 0
              total_lore = spirit + npc.get_attribute("SPIRIT", "Attunement") + domain_skill
              f += " | #{domain}Lore:#{total_lore}"
            end
          end
          f += "\n"
        elsif npc.respond_to?(:spells) && npc.spells && npc.spells.length > 0
          # If no missile weapons but has spells, add lore info on its own line
          domain = nil
          domain_skill = 0
          
          if npc.tiers["SPIRIT"] && npc.tiers["SPIRIT"]["Attunement"] && npc.tiers["SPIRIT"]["Attunement"]["skills"]
            npc.tiers["SPIRIT"]["Attunement"]["skills"].each do |dom, val|
              if val > domain_skill
                domain = dom
                domain_skill = val
              end
            end
          end
          
          if domain && domain_skill > 0
            total_lore = spirit + npc.get_attribute("SPIRIT", "Attunement") + domain_skill
            f += "   MagicLore: #{domain}Lore:#{total_lore}\n"
          end
        end
      end
      
      # Equipment and money for humanoids (not monsters)
      if npc.respond_to?(:type) && !npc.type.to_s.match(/Monster:|Animal:|monster/i)
        # Load equipment generation if not loaded
        unless defined?(generate_npc_equipment)
          load File.join($pgmdir, "includes/equipment_tables.rb")
        end
        
        # Generate equipment and money
        equipment = generate_npc_equipment(npc.type, npc.level)
        
        # Determine social status for money calculation
        social_status = case npc.type
        when /Noble/ then "N"
        when /Merchant/ then "UC"
        when /Priest/ then "MC"
        when /Smith/, /Bard/ then "LMC"
        else "LC"
        end
        
        money = generate_money(social_status, npc.level)
        money_value = money.split(' ').first.to_i
        
        # Compact money format
        money_str = ""
        if money_value >= 100
          gp = money_value / 100
          money_str += "#{gp}g"
        end
        if money_value >= 10
          sp = (money_value % 100) / 10
          money_str += "#{sp}s" if sp > 0
        end
        cp = money_value % 10
        money_str += "#{cp}c" if cp > 0
        
        # Shorten equipment list
        equip_short = equipment.take(3).join(', ')
        equip_short += "..." if equipment.length > 3
        
        f += "   #{@stat_color}Equip: #{equip_short} | $: #{money_str}#{@reset}\n"
      end
      
      # Special abilities for monsters (skip generic/unknown text)
      if npc.respond_to?(:special_abilities) && npc.special_abilities && 
         !npc.special_abilities.to_s.downcase.include?("unknown")
        f += "   Special: #{npc.special_abilities}\n"
      end
    end
  end
  
  f += "\n" + ("═" * width) + "\n"
  
  # Output handling
  if cli == "cli_direct"
    # Direct CLI mode - save and print
    # Save clean version without ANSI codes for editing
    File.write("saved/encounter_new.npc", f.pure, perm: 0644)
    # Display version with colors
    print f
    
    if !e.is_no_encounter? && e.npcs.length > 0
      # Loop to allow viewing multiple NPCs
      loop do
        # Option to view detailed NPC
        puts "\nEnter NPC number (1-#{e.npcs.length}) for details, 'e' to edit, or press Enter to exit"
        input = STDIN.gets.chomp
        
        if input.match?(/^\d+$/) && input.to_i.between?(1, e.npcs.length)
          # Load the NPC output module if not loaded
          unless defined?(npc_output_new)
            load File.join($pgmdir, "cli_npc_output_new.rb")
          end
          npc_output_new(e.get_npc(input.to_i - 1), "cli_direct")
          
          # After viewing NPC, redisplay the encounter
          system("clear") || system("cls")
          print f
        elsif input == "e"
          # Use vim with settings to avoid binary file warnings
          if $editor.include?("vim") || $editor.include?("vi")
            system("#{$editor} -c 'set fileformat=unix' saved/encounter_new.npc")
          else
            system("#{$editor} saved/encounter_new.npc")
          end
          # Redisplay after editing
          system("clear") || system("cls")
          print f
        else
          # Exit the loop on any other key
          break
        end
      end
    end
    
    return f
  elsif cli == "cli"
    # TUI mode - just return the colored string without printing
    return f
  else
    # Plain mode - return without colors
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

# Missing function from npc_output_new.rb
def generate_money(status, level)
  base = case status
         when "N" then 100 * level  # Noble
         when "UC" then 50 * level  # Upper Class
         when "MC" then 30 * level  # Middle Class
         when "LMC" then 15 * level # Lower Middle Class
         when "LC" then 8 * level   # Lower Class
         when "S" then 2 * level    # Slave
         else 10 * level
         end

  variance = rand(base / 2) - base / 4
  total = base + variance
  "#{total} silver"
end

# Keep the old compact format as an alternative
def enc_output_new_compact(e, cli)
  # This would be the current enc_output_new function
  # Keeping it for quick combat reference
  enc_output_new(e, cli)
end