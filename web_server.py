#!/usr/bin/env python3
"""
Amar RPG Tools - Web Interface
Python Flask server that calls the Ruby TUI backend for identical functionality
"""

from flask import Flask, render_template, request, jsonify, send_from_directory
import subprocess
import json
import os
import tempfile
import shutil
import re
from datetime import datetime

# ANSI to CSS color mapping
ANSI_TO_CSS = {
    # Standard colors (30-37, 90-97)
    '30': 'color: #000000',  # Black
    '31': 'color: #800000',  # Red
    '32': 'color: #008000',  # Green
    '33': 'color: #808000',  # Yellow
    '34': 'color: #000080',  # Blue
    '35': 'color: #800080',  # Magenta
    '36': 'color: #008080',  # Cyan
    '37': 'color: #c0c0c0',  # White
    '90': 'color: #808080',  # Bright Black
    '91': 'color: #ff0000',  # Bright Red
    '92': 'color: #00ff00',  # Bright Green
    '93': 'color: #ffff00',  # Bright Yellow
    '94': 'color: #0000ff',  # Bright Blue
    '95': 'color: #ff00ff',  # Bright Magenta
    '96': 'color: #00ffff',  # Bright Cyan
    '97': 'color: #ffffff',  # Bright White

    # 256-color palette (key colors used in TUI)
    '7': 'color: #c0c0c0',    # White
    '10': 'color: #00ff00',   # Bright green
    '11': 'color: #ffff00',   # Bright yellow
    '13': 'color: #ff00ff',   # Bright magenta
    '14': 'color: #00ffff',   # Bright cyan
    '15': 'color: #ffffff',   # Bright white
    '28': 'color: #008700',   # Dark green
    '34': 'color: #00af00',   # Green
    '40': 'color: #00d700',   # Bright green
    '46': 'color: #00ff00',   # Very bright green
    '51': 'color: #00ffff',   # Cyan
    '82': 'color: #5fff00',   # Lime green
    '88': 'color: #870000',   # Dark red
    '111': 'color: #87afff',  # Light blue
    '118': 'color: #87ff00',  # Bright lime
    '124': 'color: #af0000',  # Red
    '154': 'color: #afff00',  # Yellow-green
    '160': 'color: #d70000',  # Bright red
    '166': 'color: #d75f00',  # Orange-red
    '172': 'color: #d78700',  # Orange
    '178': 'color: #d7af00',  # Light orange
    '184': 'color: #d7d700',  # Yellow-orange
    '190': 'color: #d7ff00',  # Light yellow
    '195': 'color: #d7ffff',  # Light cyan
    '196': 'color: #ff0000',  # Bright red
    '202': 'color: #ff5f00',  # Red-orange
    '208': 'color: #ff8700',  # Orange
    '214': 'color: #ffaf00',  # Gold
    '226': 'color: #ffff00',  # Yellow
    '229': 'color: #ffffaf',  # Light yellow
    '240': 'color: #585858',  # Dark gray
    '243': 'color: #767676',  # Medium gray
    '245': 'color: #8a8a8a',  # Light gray
    '247': 'color: #9e9e9e',  # Light gray
    '248': 'color: #a8a8a8',  # Light gray
    '250': 'color: #bcbcbc',  # Very light gray
    '251': 'color: #c6c6c6',  # Very light gray
    '255': 'color: #eeeeee',  # Almost white
}

def convert_ansi_to_css(text):
    """Convert ANSI escape codes to HTML with CSS styling"""
    if not text:
        return text

    # Pattern for ANSI escape sequences
    ansi_pattern = r'\x1b\[([0-9;]*)m'

    def replace_ansi(match):
        codes = match.group(1)
        if not codes:
            return '</span>'  # Reset code

        styles = []
        code_parts = codes.split(';') if codes else ['0']

        for code in code_parts:
            if code == '0':
                return '</span>'  # Reset
            elif code == '1':
                styles.append('font-weight: bold')
            elif code == '22':
                styles.append('font-weight: normal')
            elif code == '4':
                styles.append('text-decoration: underline')
            elif code == '24':
                styles.append('text-decoration: none')
            elif code.startswith('38;5;'):
                # 256-color foreground
                color_code = code.split(';')[2]
                if color_code in ANSI_TO_CSS:
                    styles.append(ANSI_TO_CSS[color_code])
                else:
                    styles.append(f'color: #{int(color_code):02x}{int(color_code):02x}{int(color_code):02x}')
            elif code in ANSI_TO_CSS:
                styles.append(ANSI_TO_CSS[code])

        if styles:
            return f'<span style="{"; ".join(styles)}">'
        return ''

    # Replace ANSI codes with HTML spans
    result = re.sub(ansi_pattern, replace_ansi, text)

    # Ensure we close any open spans
    if '<span' in result and result.count('<span') > result.count('</span>'):
        result += '</span>'

    # Convert line breaks to HTML
    result = result.replace('\n', '<br>')

    return result

app = Flask(__name__)

# Configuration
RUBY_DIR = os.path.dirname(os.path.abspath(__file__))
RUBY_SCRIPT = os.path.join(RUBY_DIR, 'cli_npc_output_new.rb')

def call_ruby_function(function_name, params=None):
    """Call Ruby functions directly to get exact TUI output"""
    try:
        param_str = '[]'  # Default empty parameters

        if function_name == 'npc':
            # Build parameter string for NPC generation
            if params:
                name = params.get('name', '').strip()
                race = params.get('race', '').strip()
                type_val = params.get('type', '').strip()
                level = params.get('level', 0) if params.get('level') else 0
                area = params.get('area', '').strip()
                sex = params.get('sex', '').strip()
                age = params.get('age', 0) if params.get('age') else 0
                height = params.get('height', 0) if params.get('height') else 0
                weight = params.get('weight', 0) if params.get('weight') else 0
                description = params.get('description', '').strip()

                # Build parameter array for Ruby
                param_str = f'["{name}", "{race}", "{type_val}", {level}, "{area}", "{sex}", {age}, {height}, {weight}, "{description}"]'
            else:
                param_str = '["", "", "", 0, "", "", 0, 0, 0, ""]'
        elif function_name == 'weather':
            # Build parameter string for weather generation
            if params:
                month = params.get('month', 0)
                condition = params.get('condition', 0)
                wind_direction = params.get('wind_direction', 0)
                wind_strength = params.get('wind_strength', 0)
                param_str = f'[{month}, {condition}, {wind_direction}, {wind_strength}]'
            else:
                param_str = '[0, 0, 0, 0]'
        elif function_name == 'names':
            # Build parameter string for name generation
            if params:
                name_type = params.get('name_type', 'all')
                count = params.get('count', 20)
                # Convert name_type to index for $Names array
                name_idx = 0  # Default to random
                if name_type == 'human_male': name_idx = 0
                elif name_type == 'human_female': name_idx = 1
                elif name_type == 'dwarven_male': name_idx = 2
                elif name_type == 'dwarven_female': name_idx = 3
                elif name_type == 'elven_male': name_idx = 4
                elif name_type == 'elven_female': name_idx = 5
                elif name_type == 'lizardfolk': name_idx = 6
                elif name_type == 'troll': name_idx = 7
                elif name_type == 'araxi': name_idx = 8
                elif name_type == 'fantasy_male': name_idx = 9
                elif name_type == 'fantasy_female': name_idx = 10
                elif name_type == 'places': name_idx = 12  # Village/Town
                elif name_type == 'weapons': name_idx = 15
                param_str = f'[{name_idx}, {count}]'
            else:
                param_str = '[0, 20]'
        elif function_name == 'town':
            # Build parameter string for town generation
            if params:
                town_name = params.get('town_name', '').strip()
                town_size = params.get('town_size', 0)
                town_var = params.get('town_var', 0)
                # Limit town size to 200 for web to prevent server overload
                if town_size == 0:
                    town_size = 'rand(1..50)'  # Smaller random range for web
                else:
                    town_size = min(town_size, 200)  # Cap at 200
                if town_var == 0: town_var = 'rand(1..6)'
                param_str = f'["{town_name}", {town_size}, {town_var}]'
            else:
                param_str = '["", rand(1..100), rand(1..6)]'
        elif function_name == 'encounter':
            # Build parameter string for encounter generation
            if params:
                time = params.get('time', 1)  # 1=day, 0=night
                terrain = params.get('terrain', 1)  # 0-7
                level_mod = params.get('level_mod', 0)  # +/- modifier
                race = params.get('race', 0)  # 0=random, 1-11 specific races
                number = params.get('number', 0)  # 0=random, 1-20 specific number
                param_str = f'[{time}, {terrain}, {level_mod}, {race}, {number}]'
            else:
                param_str = '[1, 1, 0, 0, 0]'
        elif function_name == 'monster':
            # Build parameter string for monster generation
            if params:
                monster_type = params.get('monster_type', '').strip()
                level = params.get('level', 0)
                if not monster_type: monster_type = 'random'
                if level == 0: level = 'rand(1..3)'
                param_str = f'["{monster_type}", {level}]'
            else:
                param_str = '["random", rand(1..3)]'
        elif function_name == 'encounter_npc':
            # Build parameter string for encounter NPC detail
            if params:
                npc_index = params.get('npc_index', 0)
                name = params.get('name', '').strip()
                sex = params.get('sex', '').strip()
                type_val = params.get('type', '').strip()
                level = params.get('level', 1)
                age = params.get('age', 0)
                param_str = f'[{npc_index}, "{name}", "{sex}", "{type_val}", {level}, {age}]'
            else:
                param_str = '[0, "", "", "", 1, 0]'

        # Create a temporary Ruby script that calls the function
        ruby_code = f"""
# Load the Amar Tools environment
Dir.chdir('{RUBY_DIR}')
$LOAD_PATH.unshift('{RUBY_DIR}')
$pgmdir = '{RUBY_DIR}'

# Load all required files
require_relative 'includes/includes.rb'
require_relative 'cli_npc_output_new.rb'

# Define colorize_output function (simplified for web)
def colorize_output(text, type)
  case type
  when :header then text.fg(14).b
  when :subheader then text.fg(13)
  when :label then text.fg(13)
  when :value then text.fg(7)
  when :success then text.fg(46)
  when :warning then text.fg(214)
  when :dice then text.fg(202)
  when :name then text.fg(226)
  else text.fg(7)
  end
end

# Call the requested function
case '{function_name}'
when 'npc'
    params = {param_str}
    name, race, type, level, area, sex, age, height, weight, description = params

    # Use empty values as defaults for random generation
    name = nil if name.empty?
    race = nil if race.empty?
    type = nil if type.empty?
    area = nil if area.empty?
    sex = nil if sex.empty?
    age = nil if age == 0
    height = nil if height == 0
    weight = nil if weight == 0
    description = nil if description.empty?

    # Create NPC using exact TUI method
    npc = NpcNew.new(name, type, level, area, sex, age, height, weight, description)

    # Generate output exactly as TUI does (with CLI colors for web)
    output = npc_output_new(npc, 'cli', 120)
    puts output
when 'encounter'
    # Load encounter system
    require_relative 'cli_enc_output_new.rb'

    # Get parameters from input
    params = {param_str} rescue [1, 1, 0, 0, 0]
    time = params[0] || 1
    terrain = params[1] || 1
    level_mod = params[2] || 0
    race = params[3] || 0
    number = params[4] || 0

    # Set global variables for encounter generation
    $Day = time
    $Terrain = terrain
    $Terraintype = terrain + (8 * time)
    $Level = level_mod

    # Map race parameter to race name
    races = ["Random", "Human", "Elf", "Half-elf", "Dwarf", "Goblin", "Lizard Man", "Centaur", "Ogre", "Troll", "Araxi", "Faerie"]
    selected_race = race == 0 ? "Random" : races[race]

    # Generate encounter with parameters - exact TUI approach
    # Use number parameter (0 = random, specific number = that encounter)
    enc = EncNew.new(selected_race, number, $Terraintype, level_mod)

    # Store encounter object for detailed NPC views
    encounter_file = File.join($pgmdir, "saved", "last_encounter.json")
    Dir.mkdir(File.join($pgmdir, "saved")) unless Dir.exist?(File.join($pgmdir, "saved"))

    # Serialize encounter NPCs for later retrieval
    npc_data = []
    if enc.npcs && enc.npcs.length > 0
      enc.npcs.each_with_index do |npc, idx|
        npc_data << {{
          "index" => idx,
          "name" => npc.name,
          "type" => npc.type,
          "level" => npc.level,
          "sex" => npc.sex,
          "age" => npc.age,
          "area" => npc.area,
          "height" => npc.height,
          "weight" => npc.weight,
          "description" => npc.description
        }}
      end
    end

    require 'json'
    File.write(encounter_file, npc_data.to_json)

    output = enc_output_new(enc, 'cli', 120)
    puts output
when 'monster'
    # Use actual monster generation from TUI with exact format_monster_new function
    require_relative 'includes/class_monster_new.rb'

    # Load monster stats
    unless defined?($MonsterStats)
      load File.join($pgmdir, "includes/tables/monster_stats_new.rb")
    end

    # Get parameters
    params = {param_str} rescue ["random", "rand(1..3)"]
    monster_type_param = params[0] || "random"
    level = params[1].is_a?(String) ? eval(params[1]) : (params[1] || rand(1..3))

    # Get monster list
    monster_list = $MonsterStats.keys.reject do |k|
      k == "default"
    end.sort

    # Select monster type
    if monster_type_param == "random" || monster_type_param.empty?
      monster_type = monster_list.sample
    else
      monster_type = monster_type_param
    end

    # Create monster exactly as TUI does
    monster = MonsterNew.new(monster_type, level)

    # Format output exactly as TUI format_monster_new function
    content_width = 85  # Fixed width for web
    puts monster.name.fg(46) + " (" + monster.type.fg(7) + ", Level " + monster.level.to_s.fg(7) + ")"
    puts "─" * content_width
    puts ""

    # Physical stats with exact TUI formatting
    size_val = monster.SIZE
    size_display = size_val % 1 == 0.5 ? (size_val.floor.to_s + "½") : size_val.to_s
    bp_val = monster.BP.is_a?(Float) ? monster.BP.round : monster.BP
    db_val = monster.DB.is_a?(Float) ? monster.DB.round : monster.DB
    md_val = monster.MD.is_a?(Float) ? monster.MD.round : monster.MD

    puts "SIZE: ".fg(13) + size_display.fg(7) + " (" + monster.weight.round.to_s.fg(7) + "kg)  " +
         "BP: ".fg(13) + bp_val.to_s.fg(7) + "  " +
         "DB: ".fg(13) + db_val.to_s.fg(7) + "  " +
         "MD: ".fg(13) + md_val.to_s.fg(7)
    puts ""

    # Special abilities
    if monster.special_abilities && !monster.special_abilities.empty?
      puts "SPECIAL ABILITIES:".fg(13)
      puts "  " + monster.special_abilities.fg(46)
      puts ""
    end

    # Weapons/Attacks with exact TUI format
    puts "WEAPONS/ATTACKS:".fg(13)
    puts "  " + "Attack".ljust(20).fg(13) + "Skill".rjust(6).fg(13) + "Init".rjust(6).fg(13) + "Off".rjust(5).fg(13) + "Def".rjust(5).fg(13) + "Damage".rjust(8).fg(13)

    if monster.tiers && monster.tiers["BODY"] && monster.tiers["BODY"]["Melee Combat"] && monster.tiers["BODY"]["Melee Combat"]["skills"]
      monster.tiers["BODY"]["Melee Combat"]["skills"].each do |skill, value|
        next if value == 0
        total = monster.get_skill_total("BODY", "Melee Combat", skill)

        # Calculate weapon stats based on skill type and monster DB
        db = monster.DB.is_a?(Float) ? monster.DB.round : monster.DB
        if skill.downcase.include?("unarmed") || skill.downcase.include?("claw") || skill.downcase.include?("bite")
          init = 3 + (monster.level / 2)
          off = total + 2
          def_val = total
          damage = -4 + db
        else
          init = 4
          off = total + 1
          def_val = total + 1
          damage = db + 2
        end

        # Color code damage
        damage_color = case damage
                       when -10..-5 then 88
                       when -4..-2 then 124
                       when -1..0 then 166
                       when 1..2 then 226
                       when 3..4 then 154
                       when 5..6 then 118
                       when 7..9 then 82
                       when 10..14 then 46
                       else 40
                       end

        puts "  " + skill.capitalize.ljust(20).fg(7) + total.to_s.rjust(6).fg(202) + init.to_s.rjust(6).fg(7) + off.to_s.rjust(5).fg(46) + def_val.to_s.rjust(5).fg(214) + damage.to_s.rjust(8).fg(damage_color)
      end
    end
when 'weather'
    # Use actual weather generation from TUI
    require_relative 'includes/weather.rb'
    require_relative 'includes/tables/weather.rb'
    require_relative 'includes/tables/month.rb'

    # Get parameters from input or use defaults
    params = {param_str} rescue [0, 0, 0, 0]
    month = params[0] || 0
    weather_input = params[1] || 0
    wind_dir = params[2] || 0
    wind_str = params[3] || 0

    # Use actual TUI defaults and logic
    $mn = month == 0 ? rand(1..13) : month
    weather = weather_input == 0 ? 5 : weather_input
    wind = wind_str == 0 ? 0 : (wind_str - 1)

    # Generate full weather month as TUI does
    w = Weather_month.new($mn, weather, wind)

    # Output with exact TUI colors
    # Color month header with god-specific color
    month_color = case $mn
                 when 1 then 231   # Cal Amae
                 when 2 then 230   # Elesi
                 when 3 then 41    # Anashina
                 when 4 then 213   # Gwendyll
                 when 5 then 163   # MacGillan
                 when 6 then 204   # Juba
                 when 7 then 248   # Taroc
                 when 8 then 130   # Man Peggon
                 when 9 then 172   # Maleko
                 when 10 then 139  # Fal Munir
                 when 11 then 202  # Moltan
                 when 12 then 245  # Kraagh
                 when 13 then 239  # Mestronorpha
                 else 226          # Default
                 end

    puts "☀ WEATHER FOR ".fg(14).b + $Month[$mn].upcase.fg(month_color).b + " ☀".fg(14).b
    puts "─" * 60
    puts ""

    (1..30).each do |day|
      day_weather = w.day[day-1]
      if day_weather
        # Get weather condition and symbol
        weather_condition = $Weather[day_weather.weather] || "Clear"
        weather_symbol = case weather_condition
                        when /Clear/ then "☀"
                        when /cloud|Cloud/ then "☁"
                        when /rain|Rain/ then "☂"
                        when /lightning|thunder|storm/ then "⛈"
                        when /fog|Fog|mist|Mist/ then "🌫"
                        when /snow|Snow/ then "❄"
                        else "☀"
                        end

        # Format weather with symbol and ". ." (temperature indicators)
        weather_line = "#{weather_condition} #{weather_symbol}. . ".ljust(35)

        # Format wind with symbols
        wind_strength = $Wind_str[day_weather.wind_str] || "No wind"
        wind_dir = $Wind_dir[day_weather.wind_dir] || ""
        wind_symbol = case wind_strength
                     when "No wind" then "○"
                     when "Soft wind" then "◡"
                     when "Windy" then "◐"
                     when "Very windy" then "●"
                     else "○"
                     end

        # Wind direction arrows
        dir_arrow = case wind_dir
                   when "N" then "↑"
                   when "NE" then "↗"
                   when "E" then "→"
                   when "SE" then "↘"
                   when "S" then "↓"
                   when "SW" then "↙"
                   when "W" then "←"
                   when "NW" then "↖"
                   else ""
                   end

        wind_line = wind_symbol + " " + wind_strength
        wind_line += " " + dir_arrow + " " + wind_dir if wind_dir != ""
        wind_line = wind_line.ljust(20)

        # Calculate correct Amar moon phases with symbols
        moon_phase = case ((day - 1) / 7).to_i
                     when 0 then "● New"      # First week
                     when 1 then "◐ Waxing"   # Second week
                     when 2 then "○ Full"     # Third week
                     when 3 then "◑ Waning"   # Fourth week
                     else "● New"             # Beyond 4 weeks
                     end

        # Check for authentic Amar god holy days (from wiki mythology page)
        special_line = ""
        case $mn
        when 3  # Anashina month
          special_line = "★ Anashina" if day == 4
        when 4  # Gwendyll month
          special_line = "★ Gwendyll" if day == 12
        when 5  # MacGillan month
          if day == 18
            special_line = "★ Fenimaal"
          elsif day == 21
            special_line = "★ Fionella"
          end
        when 6  # Juba month
          if day == 15
            special_line = "★ Ish Nakil"
          elsif day == 28
            special_line = "★ Elaari"
          end
        when 7  # Taroc month
          special_line = "★ Ikalio" if day == 14
        end

        # Add recurring god observances (from TUI examples)
        if day == 8 && special_line.empty?
          special_line = "★ Alesia"  # Alesia day (8th of various months)
        end

        # Format the complete line exactly like TUI
        base_line = day.to_s.rjust(2).fg(202) + ": " + weather_line.fg(7) + wind_line.fg(51)

        # Add special events with god-specific colors
        if !special_line.empty?
          # Color based on authentic Amar god colors (from your table)
          god_color = case special_line
                     when /Anashina/ then 41    # Anashina (Nature goddess)
                     when /Fionella/ then 163   # MacGillan month color (Fionella's month)
                     when /Elaari/ then 204     # Juba month color (Elaari in Juba)
                     when /Gwendyll/ then 213   # Gwendyll month color
                     when /Ish Nakil/ then 204  # Juba month color (Ish Nakil in Juba)
                     when /Fenimaal/ then 163   # MacGillan month color (Fenimaal in MacGillan)
                     when /Ikalio/ then 248     # Taroc month color (Ikalio in Taroc)
                     when /Alesia/ then 230     # Elesi month color (Alesia likely in Elesi)
                     when /Juba/ then 204       # Juba month color
                     when /Solstice|New Year|Harvest/ then 172  # Seasonal events (Maleko color)
                     else 226                   # Default yellow
                     end

          padding = " " * 15
          puts base_line + padding + special_line.fg(god_color) + " " + moon_phase.fg(111)
        else
          # No special event, just add moon phase at the end with right alignment
          padding = " " * 50
          puts base_line + padding + moon_phase.fg(111)
        end
      end

      # Add blank line after each week
      puts "" if day % 7 == 0
    end

    puts ""
    puts "SUMMARY:".fg(14).b
    puts "Month: ".fg(13) + $Month[$mn].fg(226) + " has ".fg(7) + "30 days".fg(202)
    weather_names = ["", "Arctic", "Winter", "Cold", "Cool", "Normal", "Warm", "Hot", "Very hot", "Extreme heat"]
    weather_name = weather_names[$weather_n.to_i] || "Normal"
    puts "Weather pattern: ".fg(13) + weather_name.fg(51)
    puts ""
    puts "Legend:".fg(13)
    puts "  Moon phases: New → Waxing → First Quarter → Full → Waning → Last Quarter".fg(111)
    puts "  Special days: Religious festivals and important dates".fg(195)
when 'town'
    # Use actual town generation from TUI
    require_relative 'includes/class_town.rb'
    require_relative 'includes/tables/town.rb'
    require_relative 'includes/functions.rb'

    # Get parameters
    params = {param_str} rescue ["", "rand(1..100)", "rand(1..6)"]
    town_name = params[0] || ""
    town_size = params[1].is_a?(String) ? eval(params[1]) : (params[1] || rand(1..100))
    town_var = params[2].is_a?(String) ? eval(params[2]) : (params[2] || rand(1..6))

    # Suppress progress output during town generation
    require 'stringio'
    original_stdout = $stdout
    $stdout = StringIO.new

    # Generate town exactly as TUI does
    town = Town.new(town_name, town_size, town_var)

    # Restore stdout
    $stdout = original_stdout

    # Fix name formatting - add proper prefix
    display_name = town.town_name
    if !display_name.empty?
      case town_size
      when 1..5
        display_name = "Castle of " + display_name unless display_name.start_with?("Castle")
      when 6..25
        display_name = "Village of " + display_name unless display_name.start_with?("Village")
      when 26..100
        display_name = "Town of " + display_name unless display_name.start_with?("Town")
      else
        display_name = "City of " + display_name unless display_name.start_with?("City")
      end
    end

    puts display_name.fg(14).b
    puts "─" * 60
    puts "Population: ".fg(13) + town.town_residents.to_s.fg(202) + " residents in ".fg(7) + town.town_size.to_s.fg(202) + " houses".fg(7)
    puts ""

    # Show ALL residents organized by establishment
    if town.town && town.town.length > 0
      resident_count = 0
      town.town.each_with_index do |establishment, est_idx|
        next unless establishment && establishment.length > 0

        # First element is establishment name
        establishment_name = establishment[0]
        puts establishment_name.upcase.fg(14).b + ":"

        # Rest are residents
        (1...establishment.length).each do |res_idx|
          resident = establishment[res_idx]
          if resident && !resident.empty?
            resident_count += 1
            puts "  " + resident_count.to_s.rjust(2).fg(202) + ". " + resident.fg(226)
          end
        end
        puts ""
      end

      puts ""
      puts "SUMMARY:".fg(14).b
      puts "Total detailed residents: ".fg(13) + resident_count.to_s.fg(226).b
      if resident_count < town.town_residents
        remaining = town.town_residents - resident_count
        puts "Additional population: ".fg(13) + remaining.to_s.fg(202) + " (families, workers, background NPCs)".fg(7)
      end
      puts "Settlement type: ".fg(13) + (town_size <= 5 ? "Castle" : town_size <= 25 ? "Village" : town_size <= 100 ? "Town" : "City").fg(51)
    else
      puts "No resident data available".fg(240)
    end
when 'names'
    # Use actual name generation from TUI
    require_relative 'includes/functions.rb'
    require_relative 'includes/tables/names.rb'

    # Get parameters
    params = {param_str} rescue [0, 20]
    name_idx = params[0] || 0
    count = params[1] || 20

    # Use random name type if 0
    name_idx = rand($Names.length) if name_idx == 0

    # Generate names exactly as TUI does
    puts $Names[name_idx][0].upcase.fg(14).b + " NAMES"
    puts "─" * 40
    puts ""

    count.times do |i|
      name = naming($Names[name_idx][0])
      puts "  " + (i + 1).to_s.rjust(2).fg(202) + ". " + name.fg(226)
    end
when 'roll'
    # Use actual oD6 function exactly as TUI does - 10 rolls with colors
    require_relative 'includes/d6s.rb'

    # Roll 10 O6 dice with gradient coloring based on result (exact TUI code)
    results = []
    10.times do
      roll = oD6
      # Gradient coloring based on roll value - exact TUI logic
      roll_color = case roll
                   when -99..-4 then 88   # Dark red for terrible fumbles
                   when -3 then 124        # Red for fumbles
                   when -2 then 160        # Light red
                   when -1 then 166        # Orange-red
                   when 0 then 172         # Orange
                   when 1 then 178         # Light orange
                   when 2 then 184         # Yellow-orange
                   when 3 then 190         # Light yellow
                   when 4 then 226         # Yellow
                   when 5 then 154         # Yellow-green
                   when 6 then 118         # Light green
                   when 7 then 82          # Green
                   when 8 then 46          # Bright green
                   when 9 then 40          # Brighter green
                   when 10..11 then 34     # Deep green for criticals
                   when 12..14 then 28     # Darker green for high criticals
                   else 22                 # Very dark green for extreme criticals
                   end
      roll_str = roll.to_s.rjust(3).fg(roll_color)
      if roll >= 10
        results << "#{{roll_str}} " + "(Critical!)".fg(46).b
      elsif roll <= -3
        results << "#{{roll_str}} " + "(Fumble!)".fg(196).b
      else
        results << "#{{roll_str}}"
      end
    end

    # Output exactly as TUI does
    puts "OPEN ENDED D6 ROLLS (O6)".fg(14).b
    puts "─" * 40
    puts ""
    results.each do |r|
      puts r
    end
    puts ""
    puts "Press any key to continue...".fg(240)
when 'weather_pdf'
    # Generate weather PDF using TUI system
    require_relative 'includes/weather.rb'
    require_relative 'includes/weather2latex.rb'
    require_relative 'includes/tables/weather.rb'
    require_relative 'includes/tables/month.rb'

    # Get parameters from input or use defaults
    params = {param_str} rescue [0, 5, 0]
    month = params[0] || rand(1..13)
    weather = params[1] || 5
    wind = params[2] || 0

    # Set weather globals
    $mn = month
    $weather_n = weather
    $wind_dir_n = wind
    $wind_str_n = 0

    puts "WEATHER PDF GENERATOR".fg(14).b
    puts "─" * 60
    puts "Month: ".fg(13) + $Month[$mn].fg(226)
    puts "Weather: ".fg(13) + ["", "Snow storm", "Heavy snow", "Light snow", "Hail", "Normal", "Sunny", "Hot", "Sweltering"][$weather_n].fg(51)
    puts ""

    # Generate weather month for PDF
    w = Weather_month.new($mn, $weather_n, $wind_dir_n)

    # Generate LaTeX content
    latex_content = weather_out_latex(w, "cli")

    # Write LaTeX file
    Dir.mkdir("saved") unless Dir.exist?("saved")
    latex_file = "saved/weather.tex"
    File.write(latex_file, latex_content)

    puts "LaTeX file generated: ".fg(13) + "saved/weather.tex".fg(226)
    puts ""
    puts "PDF Generation:".fg(14).b
    puts "To generate PDF, run:".fg(7)
    puts "  cd saved && pdflatex weather.tex".fg(51)
    puts ""
    puts "The PDF will contain:".fg(13)
    puts "• Daily weather conditions for ".fg(7) + $Month[$mn].fg(226)
    puts "• Temperature and wind patterns".fg(7)
    puts "• Moon phases and special events".fg(7)
    puts "• Printable calendar format".fg(7)
when 'encounter_npc'
    # Get specific NPC from stored encounter with preserved stats
    require_relative 'cli_enc_output_new.rb'
    require 'json'

    # Load stored encounter data
    encounter_file = File.join($pgmdir, "saved", "last_encounter.json")

    if File.exist?(encounter_file)
      # Parse parameters
      params = {param_str} rescue [0, "", "", "", 0, 0]
      name = params[1] || ""

      # Load encounter NPCs
      npc_data_array = JSON.parse(File.read(encounter_file))

      # Find the NPC by name
      npc_data = npc_data_array.find do |data|
        data["name"] == name
      end

      if npc_data
        # Recreate the EXACT same NPC with same parameters
        # This should generate the same weapons/armor as the encounter
        npc = NpcNew.new(
          npc_data["name"],
          npc_data["type"],
          npc_data["level"],
          npc_data["area"],
          npc_data["sex"],
          npc_data["age"],
          npc_data["height"],
          npc_data["weight"],
          npc_data["description"]
        )

        # Generate full detailed output
        output = npc_output_new(npc, 'cli', 120)
        puts output
      else
        puts "NPC not found in stored encounter data"
      end
    else
      puts "No stored encounter data found"
    end
else
    puts "Unknown function: {function_name}"
end
"""

        # Execute the Ruby code
        result = subprocess.run(
            ['ruby', '-e', ruby_code],
            capture_output=True,
            text=True,
            cwd=RUBY_DIR,
            env={**os.environ, 'LANG': 'en_US.UTF-8', 'LC_ALL': 'en_US.UTF-8'}
        )

        if result.returncode == 0:
            # Convert ANSI codes to HTML/CSS for web display
            html_output = convert_ansi_to_css(result.stdout.strip())
            return {'success': True, 'output': html_output}
        else:
            error_msg = result.stderr.strip() if result.stderr.strip() else "Ruby execution failed"
            return {'success': False, 'error': error_msg}

    except Exception as e:
        return {'success': False, 'error': str(e)}

@app.route('/')
def index():
    """Main page with TUI-style interface"""
    return render_template('index.html')

@app.route('/api/npc', methods=['POST'])
def generate_npc():
    """Generate NPC using exact TUI backend"""
    params = request.get_json() or {}
    result = call_ruby_function('npc', params)
    return jsonify(result)

@app.route('/api/encounter', methods=['POST'])
def generate_encounter():
    """Generate encounter using TUI backend"""
    params = request.get_json() or {}
    result = call_ruby_function('encounter', params)
    return jsonify(result)

@app.route('/api/monster', methods=['POST'])
def generate_monster():
    """Generate monster using TUI backend"""
    params = request.get_json() or {}
    result = call_ruby_function('monster', params)
    return jsonify(result)

@app.route('/api/town', methods=['POST'])
def generate_town():
    """Generate town using TUI backend"""
    params = request.get_json() or {}
    result = call_ruby_function('town', params)
    return jsonify(result)

@app.route('/api/weather', methods=['POST'])
def generate_weather():
    """Generate weather using TUI backend"""
    params = request.get_json() or {}
    result = call_ruby_function('weather', params)
    return jsonify(result)

@app.route('/api/names', methods=['POST'])
def generate_names():
    """Generate names using TUI backend"""
    params = request.get_json() or {}
    result = call_ruby_function('names', params)
    return jsonify(result)

@app.route('/api/roll', methods=['POST'])
def roll_dice():
    """Roll open-ended d6 using TUI backend"""
    result = call_ruby_function('roll', {})
    return jsonify(result)

@app.route('/api/encounter_npc/<int:npc_index>', methods=['POST'])
def get_encounter_npc(npc_index):
    """Get specific NPC from last encounter with preserved stats"""
    params = request.get_json() or {}
    params['npc_index'] = npc_index
    result = call_ruby_function('encounter_npc', params)
    return jsonify(result)

@app.route('/api/weather_pdf', methods=['POST'])
def generate_weather_pdf():
    """Generate weather PDF using TUI backend"""
    params = request.get_json() or {}
    result = call_ruby_function('weather_pdf', params)
    return jsonify(result)

@app.route('/download/weather.pdf')
def download_weather_pdf():
    """Download the generated weather PDF"""
    pdf_path = os.path.join(RUBY_DIR, 'saved', 'weather.pdf')
    if os.path.exists(pdf_path):
        return send_from_directory(
            os.path.join(RUBY_DIR, 'saved'),
            'weather.pdf',
            as_attachment=True,
            download_name=f'amar-weather-{datetime.now().strftime("%Y%m%d")}.pdf'
        )
    else:
        return jsonify({'error': 'PDF not found'}), 404

if __name__ == '__main__':
    print("=" * 60)
    print("  Amar RPG Tools - Web Interface")
    print("=" * 60)
    print(f"Ruby backend directory: {RUBY_DIR}")
    print("Starting Flask server on http://localhost:5000")
    print("Press Ctrl+C to stop")
    print("=" * 60)

    app.run(debug=True, host='0.0.0.0', port=5000)