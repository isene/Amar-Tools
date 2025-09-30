#!/usr/bin/env python3
"""
Amar RPG Tools - Web Interface
Python Flask server that calls the Ruby TUI backend for identical functionality
"""

from flask import Flask, render_template, request, jsonify, send_from_directory, Response
import subprocess
import json
import os
import tempfile
import shutil
import re
import threading
import time

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
    '21': 'color: #0000ff',   # Blue (gale wind)
    '25': 'color: #005faf',   # Blue (Walmaer)
    '27': 'color: #005fff',   # Deep blue (very strong wind)
    '28': 'color: #008700',   # Dark green
    '33': 'color: #0087ff',   # Medium blue (strong wind)
    '39': 'color: #00afff',   # Blue (very windy)
    '41': 'color: #00d75f',   # Green (Anashina)
    '45': 'color: #00d7ff',   # Turquoise
    '75': 'color: #5fafff',   # Light blue (windy)
    '87': 'color: #5fffff',   # Light cyan (mainly clear)
    '117': 'color: #87d7ff', # Soft blue (soft wind)
    '123': 'color: #87ffff',  # Light cyan (lucid)
    '126': 'color: #af00af',  # Purple (MacGillan)
    '130': 'color: #af5f00',  # Brown (Alesia)
    '139': 'color: #af87af',  # Light purple (Fal Munir)
    '204': 'color: #ff5f87',  # Pink (Juba/Elaari)
    '209': 'color: #ff875f',  # Light orange (Fenimaal)
    '213': 'color: #ff87ff',  # Light magenta (Gwendyll)
    '230': 'color: #ffffd7',  # Light yellow (Ielina)
    '231': 'color: #ffffff',  # White (Cal Amae)
    '238': 'color: #444444',  # Dark gray (new moon)
    '239': 'color: #4e4e4e',  # Dark gray (Mestronorpha)
    '242': 'color: #6c6c6c',  # Dark gray (overcast)
    '244': 'color: #808080',  # Medium gray (cloudy and gray)
    '246': 'color: #949494',  # Gray (mainly cloudy)
    '249': 'color: #b2b2b2',  # Light gray (misty)
    '252': 'color: #d0d0d0',  # Light gray (waxing)
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

        # Check if this is just a reset code
        if codes in ['0', '39', '49']:
            return '</span>'  # Close current span

        for code in code_parts:
            if code == '0':
                continue  # Skip but don't return - might have other codes
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
                level = params.get('level', 0) if params.get('level') else 'rand(1..3)'  # Default random level
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
                town_size = params.get('town_size', 1)  # Default to 1 house
                town_var = params.get('town_var', 0)
                # Only use random if explicitly set to 0
                if town_size == 0: town_size = 'rand(1..100)'
                if town_var == 0: town_var = 'rand(1..6)'
                param_str = f'["{town_name}", {town_size}, {town_var}]'
            else:
                param_str = '["", 1, rand(1..6)]'  # Default to 1 house
        elif function_name == 'encounter':
            # Build parameter string for encounter generation
            if params:
                time = params.get('time', 1)  # 1=day, 0=night
                terrain = params.get('terrain', 1)  # 0-7
                level_mod = params.get('level_mod', 0)  # +/- modifier
                encounter_type = params.get('encounter_type', '')  # Specific encounter type from 90 options
                number = params.get('number', 0)  # 0=random, 1-10 specific number
                param_str = f'[{time}, {terrain}, {level_mod}, "{encounter_type}", {number}]'
            else:
                param_str = '[1, 1, 0, "", 0]'
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

        # Create a temporary Ruby script that calls the function
        ruby_code = f"""
# Load the Amar Tools environment
Dir.chdir('{RUBY_DIR}')
$LOAD_PATH.unshift('{RUBY_DIR}')
$pgmdir = '{RUBY_DIR}'

# Load rcurses first for color support
require '{RUBY_DIR}/lib/rcurses.rb'

# Load all required files
require '{RUBY_DIR}/includes/includes.rb'
require '{RUBY_DIR}/cli_npc_output_new.rb'

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

    # Revolutionary weapon assignment for 3-tier system based on Wield Weapon skill
    begin
      wield_weapon_total = 0
      if npc.tiers && npc.tiers["BODY"] && npc.tiers["BODY"]["Melee Combat"] && npc.tiers["BODY"]["Melee Combat"]["skills"]
        wield_weapon_skill = npc.tiers["BODY"]["Melee Combat"]["skills"]["Wield Weapon"] || 0
        wield_weapon_total = npc.get_skill_total("BODY", "Melee Combat", "Wield Weapon") rescue wield_weapon_skill
      end

      # Assign weapon based on Wield Weapon total
      weapon_capability = [wield_weapon_total / 3, 8].min  # Scale down and cap at 8
      available_weapons = $Melee.select do |weapon|
        weapon[2].to_i <= weapon_capability && weapon[2].to_i > 0
      end

      if available_weapons.length > 0
        # Randomly select a weapon the character can wield
        selected_weapon = available_weapons.sample

        # Store weapon info for output enhancement
        npc.instance_variable_set(:@assigned_weapon_name, selected_weapon[0].strip)
        npc.instance_variable_set(:@assigned_weapon_skill, wield_weapon_total)
        npc.instance_variable_set(:@assigned_weapon_stats, selected_weapon)

        # Add weapon getter methods
        npc.define_singleton_method(:assigned_weapon_name) do
          @assigned_weapon_name
        end
        npc.define_singleton_method(:assigned_weapon_skill) do
          @assigned_weapon_skill
        end
        npc.define_singleton_method(:assigned_weapon_stats) do
          @assigned_weapon_stats
        end
      end
    rescue => e
      # Skip weapon assignment if 3-tier structure is incomplete
    end

    # Generate output exactly as TUI does (with CLI colors for web)
    output = npc_output_new(npc, 'cli', 120)
    puts output
when 'encounter'
    # Load encounter system
    require '{RUBY_DIR}/cli_enc_output_new.rb'

    # Get parameters from input
    params = {param_str} rescue [1, 1, 0, "", 0]
    time = params[0] || 1
    terrain = params[1] || 1
    level_mod = params[2] || 0
    encounter_type = params[3] || ""
    number = params[4] || 0

    # Set global variables for encounter generation
    $Day = time
    $Terrain = terrain
    $Terraintype = terrain + (8 * time)
    $Level = level_mod

    # Use encounter type directly (supports all 90 encounter types from TUI)
    selected_type = encounter_type.empty? ? "" : encounter_type
    enc_number = number == 0 ? rand(1..6) : number

    # Generate encounter with specific encounter type (modern system with 90 types)
    enc = EncNew.new(selected_type, enc_number, $Terraintype, level_mod)
    output = enc_output_new(enc, 'cli', 120)
    puts output
when 'monster'
    # Use actual monster generation from TUI with exact format_monster_new function
    require '{RUBY_DIR}/includes/class_monster_new.rb'

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
    # Use FULL TUI weather generation with moon phases and holy days
    require '{RUBY_DIR}/lib/rcurses.rb'
    require '{RUBY_DIR}/includes/weather.rb'
    require '{RUBY_DIR}/includes/tables/weather.rb'
    require '{RUBY_DIR}/includes/tables/month.rb'

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

    # Authentic Amar god colors for each month
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
                  else 14           # Default cyan
                  end

    # Output with exact TUI colors, moon phases, and holy days
    puts "WEATHER GENERATOR".fg(14).b
    puts ("═" * 90)
    # EXPLICIT TEST: Make MacGillan purple
    month_name = $Month[$mn]
    if month_name == "MacGillan"
      month_name = month_name.fg(126)  # Purple for MacGillan
    else
      month_name = month_name.fg(month_color)
    end
    puts "Month: ".fg(13).b + month_name.b
    puts ""

    # Show a full month of weather with moon phases and holy days
    w.day.each_with_index do |day_weather, idx|
      day = idx + 1

      # Build complete line
      line = ""
      line += ("Day " + day.to_s.rjust(2) + ": ").fg(88).b

      # Weather column
      weather_text = $Weather[day_weather.weather] || "Unknown"
      weather_colored = case weather_text.downcase
                       when /clear skies/ then weather_text.fg(51).b         # Cyan bold
                       when /clear/ then weather_text.fg(45).b               # Turquoise bold
                       when /sunny/ then weather_text.fg(226).b              # Yellow bold
                       when /lucid/ then weather_text.fg(123).b              # Light cyan bold
                       when /partly cloudy/ then weather_text.fg(250).b      # Lighter gray bold
                       when /mainly cloudy/ then weather_text.fg(246).b      # Gray bold
                       when /mainly clear/ then weather_text.fg(87).b        # Light cyan bold
                       when /cloudy and gray/ then weather_text.fg(244).b    # Medium gray bold
                       when /cloudy/ then weather_text.fg(247).b             # Light gray bold
                       when /overcast/ then weather_text.fg(242).b           # Dark gray bold
                       when /misty/ then weather_text.fg(249).b              # Light gray bold
                       when /fog/ then weather_text.fg(247).b                # Fog gray bold
                       when /rain/ then weather_text.fg(33).b                # Blue bold
                       when /drizzle/ then weather_text.fg(75).b             # Light blue bold
                       when /storm/ then weather_text.fg(196).b              # Red bold
                       when /lightning/ then weather_text.fg(214).b          # Orange bold
                       when /thunder/ then weather_text.fg(172).b            # Orange bold
                       when /snow/ then weather_text.fg(255).b               # White bold
                       when /blizzard/ then weather_text.fg(231).b           # Pure white bold
                       else weather_text.fg(7).b
                       end
      line += weather_colored
      # Add plain padding (no color)
      padding_length = [35 - weather_text.length, 0].max
      line += " " * padding_length

      # Wind - just print it
      if day_weather.wind_str > 0
        wind_base = $Wind_str[day_weather.wind_str]
        wind_dir = $Wind_dir[day_weather.wind_dir]
        wind_text = wind_base + " (" + wind_dir + ")"
        wind_colored = case day_weather.wind_str
                      when 1 then wind_text.fg(117).b  # Soft - lighter blue bold
                      when 2 then wind_text.fg(75).b   # Windy - light blue bold
                      when 3 then wind_text.fg(39).b   # Very windy - blue bold
                      when 4 then wind_text.fg(33).b   # Strong - medium blue bold
                      when 5 then wind_text.fg(27).b   # Very strong - deep blue bold
                      when 6 then wind_text.fg(21).b   # Gale - dark blue bold
                      else wind_text.fg(51).b          # Default cyan bold
                      end
        line += wind_colored
        # Add plain padding
        wind_padding = [22 - wind_text.length, 0].max
        line += " " * wind_padding
      else
        line += " " * 22  # Plain spaces for empty wind column
      end

      # Holy days - just print it
      if day_weather.respond_to?(:special) && day_weather.special && !day_weather.special.empty?
        special_text = day_weather.special
        holy_colored = case special_text
                      when /Ikalio/i then ("★ " + special_text).fg(226).b
                      when /MacGillan/i then ("★ " + special_text).fg(126).b
                      when /Macgillan/i then ("★ " + special_text).fg(126).b  # Lowercase variant
                      when /Anashina/i then ("★ " + special_text).fg(41).b
                      when /Gwendyll/i then ("★ " + special_text).fg(213).b
                      when /Fionella/i then ("★ " + special_text).fg(126).b
                      when /Elaari/i then ("★ " + special_text).fg(204).b
                      when /Ish Nakil/i then ("★ " + special_text).fg(196).b
                      when /Fenimaal/i then ("★ " + special_text).fg(209).b
                      when /Alesia/i then ("★ " + special_text).fg(130).b
                      when /Shalissa/i then ("★ " + special_text).fg(117).b
                      when /Walmaer/i then ("★ " + special_text).fg(25).b
                      when /Juba/i then ("★ " + special_text).fg(204).b
                      when /Cal Amae/i then ("★ " + special_text).fg(231).b
                      when /Kraagh/i then ("★ " + special_text).fg(245).b
                      when /Moltan/i then ("★ " + special_text).fg(202).b
                      when /Fal Munir/i then ("★ " + special_text).fg(139).b
                      when /Maleko/i then ("★ " + special_text).fg(172).b
                      when /Mestronorpha/i then ("★ " + special_text).fg(239).b
                      when /Elesi/i then ("★ " + special_text).fg(229).b
                      when /Ielina/i then ("★ " + special_text).fg(230).b
                      when /Man Peggon|harvest/i then ("★ " + special_text).fg(130).b
                      when /Taroc|solstice/i then ("★ " + special_text).fg(248).b
                      else ("★ " + special_text).fg(245).b
                      end
        line += holy_colored
        holy_len = ("★ " + special_text).length
        # Add plain padding
        holy_padding = [20 - holy_len, 0].max
        line += " " * holy_padding
      else
        line += " " * 20  # Plain spaces for empty holy day column
      end

      # Moon phases column
      moon_symbols = {{
        1 => ["●", "New"],
        8 => ["◐", "Waxing"],
        15 => ["○", "Full"],
        22 => ["◑", "Waning"]
      }}

      if moon_symbols.key?(day)
        moon_sym, moon_name = moon_symbols[day]
        moon_text = moon_sym + " " + moon_name
        moon_colored = case day
                      when 1 then moon_text.fg(238).b    # Dark gray for new bold
                      when 8 then moon_text.fg(252).b    # Light gray for waxing bold
                      when 15 then moon_text.fg(229).b   # Bold yellow for full
                      when 22 then moon_text.fg(245).b   # Medium gray for waning bold
                      end
        line += moon_colored
      end

      # Output the complete line
      puts line

      # Add separator every 7 days
      puts ("─" * 90) if (day % 7) == 0 && day != w.day.length
    end
when 'town'
    # Use actual town generation from TUI
    require '{RUBY_DIR}/includes/class_town.rb'
    require '{RUBY_DIR}/includes/tables/town.rb'
    require '{RUBY_DIR}/includes/functions.rb'

    # Get parameters
    params = {param_str} rescue ["", 1, "rand(1..6)"]
    town_name = params[0] || ""
    town_size = params[1].is_a?(String) ? eval(params[1]) : (params[1] || 1)
    town_var = params[2].is_a?(String) ? eval(params[2]) : (params[2] || rand(1..6))

    # Suppress stdout progress output during town generation by redirecting to /dev/null
    original_stdout = $stdout
    $stdout = File.open('/dev/null', 'w')

    # Generate town exactly as TUI does
    town = Town.new(town_name, town_size, town_var)

    # Restore stdout and close the null file
    $stdout.close
    $stdout = original_stdout

    # Format exactly like TUI does
    town_type = case town.town_size
                when 1..4 then "CASTLE"
                when 5..25 then "VILLAGE"
                when 26..99 then "TOWN"
                else "CITY"
                end

    puts town_type.fg(14).b + " OF " + town.town_name.upcase.fg(46)
    puts "─" * 60
    puts "Houses: ".fg(13) + town.town.size.to_s.fg(7) + "  " + "Residents: ".fg(13) + town.town_residents.to_s.fg(7)
    puts ""

    # Show houses with enhanced coloring for better differentiation
    town.town.each_with_index do |house, house_idx|
      # House header with distinct color
      puts "#" + house_idx.to_s.fg(202) + ": ".fg(13) + house[0].fg(226).b
      house[1..-1].each do |resident|
        if resident =~ /(.+?) \\(([MF]) (\\d+)\\) (.+?) \\[(\\d+)\\] (.+)/
          name = $1
          sex = $2
          age = $3
          race = $4
          level = $5
          personality = $6

          # Color coding for different elements
          sex_colored = sex == "M" ? sex.fg(75) : sex.fg(213)  # Blue for male, pink for female
          age_colored = age.fg(245)  # Gray for age

          # Race coloring based on type
          race_colored = case race.downcase
                        when /human/ then race.fg(229)
                        when /elf|elv/ then race.fg(120)
                        when /dwarf|dwarv/ then race.fg(130)
                        when /halfling/ then race.fg(178)
                        when /lizardfolk/ then race.fg(34)
                        when /troll/ then race.fg(28)
                        else race.fg(7)
                        end

          # Personality with varied colors
          personality_colored = case personality.downcase
                               when /aggressive|violent|angry/ then personality.fg(196)
                               when /friendly|kind|generous/ then personality.fg(118)
                               when /clever|intelligent|wise/ then personality.fg(141)
                               when /sneaky|cunning|sly/ then personality.fg(208)
                               when /brave|courageous|bold/ then personality.fg(214)
                               when /timid|shy|nervous/ then personality.fg(183)
                               when /greedy|selfish|miserly/ then personality.fg(220)
                               when /honest|truthful|sincere/ then personality.fg(87)
                               else personality.fg(252)
                               end

          puts "  " + name.fg(226) + " (" + sex_colored + " " + age_colored + ") " + race_colored + " [" + level.fg(202).b + "] " + personality_colored
        else
          puts "  " + resident.fg(7)
        end
      end
    end
when 'names'
    # Use actual name generation from TUI
    require '{RUBY_DIR}/includes/functions.rb'
    require '{RUBY_DIR}/includes/tables/names.rb'

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
    require '{RUBY_DIR}/includes/d6s.rb'

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

    # Output exactly as TUI does (but skip "Press any key" for web)
    puts ""
    results.each do |r|
      puts r
    end
    puts ""
when 'npc_old'
    # Generate using the ACTUAL old Npc class (exactly like TUI)
    $pgmdir = '{RUBY_DIR}'  # Set program directory
    require '{RUBY_DIR}/includes/class_npc.rb'
    require 'date'

    # Get parameters from input
    params = {param_str} rescue ["", "", 0, "", "", 0, 0, 0, ""]
    name, type, level, area, sex, age, height, weight, description = params

    # Use empty values as defaults for random generation
    name = nil if name.empty?
    type = nil if type.empty?
    area = nil if area.empty?
    sex = nil if sex.empty?
    age = nil if age == 0
    height = nil if height == 0
    weight = nil if weight == 0
    description = nil if description.empty?

    # Load weapon tables for assignment
    $Melee = Array.new
    $Melee[0] =  [ "Weapon", "Type", "Str", "Dam", "Init", "Off", "Def", "HP", "Wt" ]
    $Melee[1] =  [ "Unarmed ", "Unarmed",                    0,-4, 1,-2,-4, 0, 0 ]
    $Melee[2] =  [ "Knife   ", "Knife",                      1,-2, 2,-2,-3, 8, 0.4 ]
    $Melee[3] =  [ "Short sword", "1H",                      2,-2, 3,-1,-1,12, 0.6 ]
    $Melee[4] =  [ "Rapier  ", "1H",                         2,-2, 4, 0,-1, 7, 0.7 ]
    $Melee[5] =  [ "Knife*2 ", "Knife",                      3,-2, 2,-1,-2, 8, 0.8 ]
    $Melee[6] =  [ "Staff   ", "Polearm",                    3,-2, 6, 0, 2, 7, 1.5 ]
    $Melee[7] =  [ "Light mace", "1H",                       3,-2, 3,-1,-2, 8, 1 ]
    $Melee[8] =  [ "Hatchet/Knife", "1H",                    3,-1, 3,-1,-2, 8, 0.8 ]
    $Melee[9] =  [ "Longsword", "1H",                        4,-1, 5, 0, 0,12, 1.2 ]
    $Melee[10] = [ "Spear 2H", "Polearm",                    4,-1, 7, 0, 2, 7, 2 ]
    $Melee[11] = [ "Club    ", "1H",                         4,-2, 4,-1,-2, 8, 1.6 ]
    $Melee[12] = [ "H. mace 2H", "2H",                       4, 0, 4, 0, 0, 8, 1.8 ]
    $Melee[13] = [ "B. sword 2H", "2H",                      4, 0, 6, 0, 1,12, 2 ]
    $Melee[14] = [ "Longsword/Buc", "1H/Shield",             4,-1, 5, 1, 1,12, 2 ]
    $Melee[15] = [ "B. sword/Buc", "1H/Shield",              5,-1, 6, 1, 1,12, 2.8 ]
    $Melee[16] = [ "Br. axe/Buc", "1H/Shield",               5, 0, 4, 0, 1, 8, 3 ]
    $Melee[17] = [ "B. axe 2H", "2H",                        5, 2, 5,-1, 0, 8, 2.5 ]
    $Melee[18] = [ "Great sword", "2H",                      7, 2, 8, 1, 1,12, 2.2 ]
    $Melee[19] = [ "Halberd  ", "Polearm",                   7, 1, 8, 0, 3, 7, 3.5 ]
    $Melee[20] = [ "Great axe", "2H",                        8, 4, 7, 0, 0, 8, 3.2 ]
    $Melee[21] = [ "Maul 2H  ", "2H",                        8, 3, 6,-1,-1, 8, 4 ]

    # Load missile weapon tables for assignment
    $Missile = Array.new
    $Missile[0] =  [ "Weapon",          "Type",     "Str","Dam","Off","Rng","Max","Init", "Wt" ]
    $Missile[1] =  [ "Rock [2]",        "Rock",     0,    -3,   -2,   15,   40,   5,      0.2 ]
    $Missile[2] =  [ "Th Knife [2]",    "Knife",    1,    -2,   -1,   15,   25,   5,      0.2 ]
    $Missile[3] =  [ "Sling [1]",       "Sling",    2,    -1,   -3,   40,   120,  0,      0.3 ]
    $Missile[4] =  [ "X-bow(L) [½]",    "Crossbow", 2,    2,    2,    20,   100,  0,      1.5 ]
    $Missile[5] =  [ "Bow(L) [1]",      "Bow",      2,    1,    0,    30,   130,  0,      1.5 ]
    $Missile[6] =  [ "X-bow(M) [⅓]",    "Crossbow", 3,    3,    2,    25,   175,  0,      2   ]
    $Missile[7] =  [ "Javelin [1]",     "Javelin",  3,    0,    -2,   20,   40,   0,      2   ]
    $Missile[8] =  [ "Bow(M) [1]",      "Bow",      4,    2,    0,    35,   160,  0,      2   ]
    $Missile[9] =  [ "X-bow(H) [¼]",    "Crossbow", 4,    4,    2,    30,   250,  0,      3   ]
    $Missile[10] = [ "Bow(H)  [1]",     "Bow",      6,    3,    0,    40,   190,  0,      2.5 ]
    $Missile[11] = [ "Bow(H2) [1]",     "Bow",      8,    4,    0,    45,   215,  0,      3   ]
    $Missile[12] = [ "Bow(H3) [1]",     "Bow",      10,   5,    0,    50,   240,  0,      3.5 ]

    # Create legacy NPC using exact TUI parameters with randomization
    srand(Time.now.to_i + rand(10000))  # Ensure randomization

    # Initialize required data structures before creating NPC
    begin
      npc = Npc.new(name, type, level, area, sex, age, height, weight, description)
    rescue => e
      # If NPC creation fails due to missing structures, create simplified version
      puts "Legacy NPC creation failed, using simplified approach: " + e.message

      # Create basic character stats manually
      basic_npc = Object.new
      basic_npc.instance_variable_set(:@name, name || ["John", "Jane", "Alex", "Sam"].sample)
      basic_npc.instance_variable_set(:@type, type || "Commoner")
      basic_npc.instance_variable_set(:@level, level || rand(1..5))
      basic_npc.instance_variable_set(:@area, area || "Amaronir")
      basic_npc.instance_variable_set(:@sex, sex || ["M", "F"].sample)
      basic_npc.instance_variable_set(:@age, age || rand(18..60))
      basic_npc.instance_variable_set(:@height, height || rand(150..190))
      basic_npc.instance_variable_set(:@weight, weight || rand(50..90))
      basic_npc.instance_variable_set(:@description, description || "")

      # Generate random legacy stats
      basic_npc.instance_variable_set(:@size, rand(1..5))
      basic_npc.instance_variable_set(:@strng, rand(2..8))  # STR for weapon assignment
      basic_npc.instance_variable_set(:@endur, rand(1..6))
      basic_npc.instance_variable_set(:@coord, rand(1..8))
      basic_npc.instance_variable_set(:@learn, rand(1..10))
      basic_npc.instance_variable_set(:@aware, rand(1..6))
      basic_npc.instance_variable_set(:@magap, rand(0..12))

      # Add all the getter methods using do/end blocks
      basic_npc.define_singleton_method(:name) do
        @name
      end
      basic_npc.define_singleton_method(:type) do
        @type
      end
      basic_npc.define_singleton_method(:level) do
        @level
      end
      basic_npc.define_singleton_method(:area) do
        @area
      end
      basic_npc.define_singleton_method(:sex) do
        @sex
      end
      basic_npc.define_singleton_method(:age) do
        @age
      end
      basic_npc.define_singleton_method(:height) do
        @height
      end
      basic_npc.define_singleton_method(:weight) do
        @weight
      end
      basic_npc.define_singleton_method(:description) do
        @description
      end
      basic_npc.define_singleton_method(:size) do
        @size
      end
      basic_npc.define_singleton_method(:strng) do
        @strng
      end
      basic_npc.define_singleton_method(:endur) do
        @endur
      end
      basic_npc.define_singleton_method(:coord) do
        @coord
      end
      basic_npc.define_singleton_method(:learn) do
        @learn
      end
      basic_npc.define_singleton_method(:aware) do
        @aware
      end
      basic_npc.define_singleton_method(:magap) do
        @magap
      end

      # Add other required stats with random values
      basic_npc.instance_variable_set(:@balance, rand(1..10))
      basic_npc.instance_variable_set(:@dtraps, rand(1..8))
      basic_npc.instance_variable_set(:@climb, rand(1..8))
      basic_npc.instance_variable_set(:@react, rand(1..10))
      basic_npc.instance_variable_set(:@dodge, rand(1..10))
      basic_npc.instance_variable_set(:@tracking, rand(1..8))
      basic_npc.instance_variable_set(:@hide, rand(1..8))
      basic_npc.instance_variable_set(:@modhide, @hide)
      basic_npc.instance_variable_set(:@mvqt, rand(1..8))
      basic_npc.instance_variable_set(:@modmvqt, @mvqt)
      basic_npc.instance_variable_set(:@ride, rand(1..8))
      basic_npc.instance_variable_set(:@sleight, rand(1..8))
      basic_npc.instance_variable_set(:@swim, rand(1..8))
      basic_npc.instance_variable_set(:@db, rand(1..4))
      basic_npc.instance_variable_set(:@tumble, rand(1..8))
      basic_npc.instance_variable_set(:@bp, rand(5..12))
      basic_npc.instance_variable_set(:@md, rand(1..6))
      basic_npc.instance_variable_set(:@enc, rand(3..10))
      basic_npc.instance_variable_set(:@armour, ["None", "Leather armour", "Chain mail"].sample)
      basic_npc.instance_variable_set(:@socstatus, ["LC", "LMC", "MC", "UMC", "UC"].sample)
      basic_npc.instance_variable_set(:@status, rand(-3..3))
      basic_npc.instance_variable_set(:@ap, rand(0..3))
      basic_npc.instance_variable_set(:@money, rand(0..1000))
      basic_npc.instance_variable_set(:@maglore, rand(0..15))
      basic_npc.instance_variable_set(:@magtype1, ["fire", "water", "air", "earth", "protection", "magic"].sample)
      basic_npc.instance_variable_set(:@splore, rand(0..15))
      basic_npc.instance_variable_set(:@cult, ["Alesia", "Fal Munir", "Anashina", "Cal Amae", "Maleko"].sample)
      basic_npc.instance_variable_set(:@cultstat1, ["Interested", "Initiated", "Devoted"].sample)

      # Add getter methods for all stats
      [:balance, :dtraps, :climb, :react, :dodge, :tracking, :hide, :modhide, :mvqt, :modmvqt, :ride, :sleight, :swim, :db, :tumble, :bp, :md, :enc, :armour, :socstatus, :status, :ap, :money, :maglore, :magtype1, :splore, :cult, :cultstat1].each do |method|
        basic_npc.define_singleton_method(method) do
          instance_variable_get("@" + method.to_s)
        end
      end

      npc = basic_npc
    end

    # Weapon assignment based on STR (legacy system rule)
    character_str = npc.strng.to_i
    available_weapons = $Melee.select do |weapon|
      weapon[2].to_i <= character_str && weapon[2].to_i > 0
    end

    if available_weapons.length > 0
      # Randomly select a weapon the character can wield
      selected_weapon = available_weapons.sample
      npc.instance_variable_set(:@wpn_name, selected_weapon[0].strip)
      npc.instance_variable_set(:@wpn_skill, character_str + rand(0..5))  # Skill based on STR + random
      # Calculate proper initiative: Character Reaction Speed + Weapon INI modifier
      character_reaction = npc.react || rand(1..10)
      npc.instance_variable_set(:@wpn_ini, character_reaction + selected_weapon[4])
      npc.instance_variable_set(:@wpn_off, selected_weapon[5])
      npc.instance_variable_set(:@wpn_def, selected_weapon[6])
      npc.instance_variable_set(:@wpn_dam, selected_weapon[3])
      npc.instance_variable_set(:@wpn_hp, selected_weapon[7])
      npc.instance_variable_set(:@wpn_range, "")

      # Define getter methods for weapon properties
      npc.define_singleton_method(:wpn_name) do
        @wpn_name
      end
      npc.define_singleton_method(:wpn_skill) do
        @wpn_skill
      end
      npc.define_singleton_method(:wpn_ini) do
        @wpn_ini
      end
      npc.define_singleton_method(:wpn_off) do
        @wpn_off
      end
      npc.define_singleton_method(:wpn_def) do
        @wpn_def
      end
      npc.define_singleton_method(:wpn_dam) do
        @wpn_dam
      end
      npc.define_singleton_method(:wpn_hp) do
        @wpn_hp
      end
      npc.define_singleton_method(:wpn_range) do
        @wpn_range
      end
    end

    # Missile weapon assignment (for appropriate character types)
    missile_types = ["Archer", "Ranger", "Hunter", "Soldier", "Warrior"]
    if missile_types.include?(npc.type) || rand(1..4) == 1  # 25% chance for other types
      available_missiles = $Missile.select do |weapon|
        weapon[2].to_i <= character_str && weapon[2].to_i >= 0
      end

      if available_missiles.length > 0
        selected_missile = available_missiles.sample
        npc.instance_variable_set(:@msl_name, selected_missile[0].strip)
        npc.instance_variable_set(:@msl_skill, character_str + rand(0..5))
        # Missile INI = Character Reaction + Coordination/2 + Missile Init modifier (official Amar rules)
        character_coord = npc.coord || rand(1..8)
        character_reaction = npc.react || rand(1..10)
        missile_ini = character_reaction + (character_coord / 2).to_i + selected_missile[7]
        npc.instance_variable_set(:@msl_ini, missile_ini)
        npc.instance_variable_set(:@msl_off, selected_missile[4])
        npc.instance_variable_set(:@msl_dam, selected_missile[3])
        npc.instance_variable_set(:@msl_range, selected_missile[5])

        # Add missile weapon getter methods
        npc.define_singleton_method(:msl_name) do
          @msl_name
        end
        npc.define_singleton_method(:msl_skill) do
          @msl_skill
        end
        npc.define_singleton_method(:msl_ini) do
          @msl_ini
        end
        npc.define_singleton_method(:msl_off) do
          @msl_off
        end
        npc.define_singleton_method(:msl_dam) do
          @msl_dam
        end
        npc.define_singleton_method(:msl_range) do
          @msl_range
        end
      end
    end

    # Exact TUI legacy output format (complete version)
    output = ""
    header_width = 71
    output += "#" * header_width + "\n"
    output += "Created: " + Date.today.to_s.rjust(header_width - 9) + "\n"
    output += "Name:".ljust(9) + npc.name.to_s + "\n"
    output += "Type:".ljust(9) + (npc.type.to_s + " (" + npc.level.to_s + ")").ljust(23)
    output += "Sex:".ljust(5) + npc.sex.to_s.ljust(18)
    output += "Height:".ljust(8) + npc.height.to_s + "\n"
    output += "Area:".ljust(9) + npc.area.to_s.ljust(23)
    output += "Age:".ljust(5) + npc.age.to_s.ljust(18)
    output += "Weight:".ljust(8) + npc.weight.to_s + "\n"
    output += "-----------------------------------------------------------------------\n"
    output += "Description: " + (npc.description || '') + "\n"
    output += "-----------------------------------------------------------------------\n"

    # Complete original 3-column stats layout (full version)
    output += "SIZE:".ljust(9) + npc.size.to_s.ljust(11)
    output += "Balance:".ljust(17) + npc.balance.to_s.ljust(9)
    output += "Detect Traps:".ljust(17) + npc.dtraps.to_s.ljust(9) + "\n"

    output += "STRNG:".ljust(9) + npc.strng.to_s.ljust(11)
    output += "Climb:".ljust(17) + npc.climb.to_s.ljust(9)
    output += "Reaction Speed:".ljust(17) + npc.react.to_s.ljust(9) + "\n"

    output += "ENDUR:".ljust(9) + npc.endur.to_s.ljust(11)
    output += "Dodge:".ljust(17) + npc.dodge.to_s.ljust(9)
    output += "Tracking:".ljust(17) + npc.tracking.to_s.ljust(9) + "\n"

    output += "COORD:".ljust(9) + npc.coord.to_s.ljust(11)
    output += "Hide:".ljust(17) + (npc.hide.to_s + "/" + npc.modhide.to_s).ljust(9)
    # Add special skills with asterisks (right column)
    if npc.respond_to?(:percept1) && npc.percept1 && !npc.percept1.empty?
      output += "*" + (npc.percept1 + ":").ljust(16) + npc.percept1s.to_s.ljust(9)
    end
    output += "\n"

    output += "LEARN:".ljust(9) + npc.learn.to_s.ljust(11)
    output += "Mvqt:".ljust(17) + (npc.mvqt.to_s + "/" + npc.modmvqt.to_s).ljust(9)
    output += "\n"

    output += "AWARE:".ljust(9) + npc.aware.to_s.ljust(11)
    output += "Ride:".ljust(17) + npc.ride.to_s.ljust(9)
    # Add medical lore if exists
    if npc.respond_to?(:medicall) && npc.medicall && npc.medicall > 0
      output += "Medical lore:".ljust(17) + npc.medicall.to_s.ljust(9)
    end
    output += "\n"

    output += "MAGAP:".ljust(9) + npc.magap.to_s.ljust(11)
    output += "Sleight:".ljust(17) + npc.sleight.to_s.ljust(9)
    # Add read/write if exists
    if npc.respond_to?(:readwrite) && npc.readwrite && npc.readwrite > 0
      output += "Read/write:".ljust(17) + npc.readwrite.to_s.ljust(9)
    end
    output += "\n"

    output += " ".ljust(20)
    output += "Swim:".ljust(17) + npc.swim.to_s.ljust(9)
    # Add spoken if exists
    if npc.respond_to?(:spoken) && npc.spoken && npc.spoken > 0
      output += "Spoken:".ljust(17) + npc.spoken.to_s.ljust(9)
    end
    output += "\n"

    # Combat stats with lore skills
    output += "DB:".ljust(9) + npc.db.to_s.ljust(11)
    output += "Tumble:".ljust(17) + npc.tumble.to_s.ljust(9)
    if npc.respond_to?(:lore1) && npc.lore1 && !npc.lore1.empty?
      output += "*" + (npc.lore1 + ":").ljust(16) + npc.lore1s.to_s.ljust(9)
    end
    output += "\n"

    output += "BP:".ljust(9) + npc.bp.to_s.ljust(11)
    if npc.respond_to?(:physical1) && npc.physical1 && !npc.physical1.empty?
      output += "*" + (npc.physical1 + ":").ljust(16) + npc.physical1s.to_s.ljust(9)
    end
    if npc.respond_to?(:lore2) && npc.lore2 && !npc.lore2.empty?
      output += "*" + (npc.lore2 + ":").ljust(16) + npc.lore2s.to_s.ljust(9)
    end
    output += "\n"

    output += "MD:".ljust(9) + npc.md.to_s.ljust(11)
    if npc.respond_to?(:physical2) && npc.physical2 && !npc.physical2.empty?
      output += "*" + (npc.physical2 + ":").ljust(16) + npc.physical2s.to_s.ljust(9)
    end
    if npc.respond_to?(:lore3) && npc.lore3 && !npc.lore3.empty?
      output += "*" + (npc.lore3 + ":").ljust(16) + npc.lore3s.to_s.ljust(9)
    end
    output += "\n"

    output += "-----------------------------------------------------------------------\n"

    # Cult information (if any)
    if npc.respond_to?(:cult) && npc.cult && !npc.cult.empty?
      output += "Cult:".ljust(9) + npc.cult.to_s
      if npc.respond_to?(:cultstat1) && npc.cultstat1
        output += ", " + npc.cultstat1.to_s
      end
      if npc.respond_to?(:cs)
        output += " (" + npc.cs.to_s + ")"
      end
      output += "\n-----------------------------------------------------------------------\n"
    end

    # Equipment and status section
    output += "ENC:".ljust(9) + npc.enc.to_s.ljust(11)
    output += "Armour:".ljust(10) + (npc.armour || "None").ljust(15)
    output += "Social status:".ljust(16) + (npc.socstatus || "MC").ljust(9) + "\n"

    output += "Status:".ljust(9) + npc.status.to_s.ljust(11)
    output += "AP:".ljust(10) + npc.ap.to_s.ljust(15)
    output += "Money:".ljust(16) + npc.money.to_s.ljust(9) + "\n"

    output += "-----------------------------------------------------------------------\n"

    # Magic and spells section
    has_spells = false

    # Check for spells first (outside the magic section)
    if npc.respond_to?(:spell0)
      (0..8).each do |i|
        if npc.respond_to?("spell" + i.to_s)
          begin
            spell_val = npc.send("spell" + i.to_s, 0) rescue 0
            if spell_val && spell_val != 0
              has_spells = true
              break
            end
          rescue
            # Skip if method doesn't work
          end
        end
      end
    end

    if npc.respond_to?(:maglore) && npc.maglore && npc.maglore > 0
      output += "Magick lore:".ljust(14) + npc.maglore.to_s.ljust(6)
      if npc.respond_to?(:magtype1) && npc.magtype1
        output += "Magick type:".ljust(14) + npc.magtype1.ljust(12)
      end
      if npc.respond_to?(:splore) && npc.splore
        output += "Spell lore:".ljust(14) + npc.splore.to_s.ljust(6)
      end
      output += "\n\n"

      # Check for spells first
      if npc.respond_to?(:spell0)
        (0..8).each do |i|
          if npc.respond_to?("spell" + i.to_s)
            begin
              spell_val = npc.send("spell" + i.to_s, 0) rescue 0
              if spell_val && spell_val != 0
                has_spells = true
                break
              end
            rescue
              # Skip if method doesn't work
            end
          end
        end
      end

      if has_spells
        # Complete spell table with names and details (like TUI)
        output += "SPELL".ljust(20) + "LEVEL".ljust(7) + "DR".ljust(4) + "A?".ljust(4) + "R?".ljust(4) + "CT".ljust(4) + "DUR".ljust(5) + "RNG".ljust(5) + "WT".ljust(6) + "AoE".ljust(12) + "\n"

        # For now, show placeholder spells since we don't have the spell database
        spell_names = ["Prot. f Magic", "Prot. f Water", "Prot. f Fire", "Prot. f Undeads", "Prot. f Demons", "Armor"]
        (0..5).each do |spell_idx|
          if npc.respond_to?("spell" + spell_idx.to_s)
            begin
              spell_val = npc.send("spell" + spell_idx.to_s, 0) rescue 0
              if spell_val && spell_val > 0
                spell_name = (spell_names[spell_idx] || "Spell " + spell_idx.to_s).ljust(20)
                output += spell_name + spell_val.to_s.ljust(7) + "11".ljust(4) + "P".ljust(4) + "Y".ljust(4) + "1r".ljust(4) + "2m".ljust(5) + "T".ljust(5) + "".ljust(6) + "1C*".ljust(12) + "\n"
              end
            rescue
              # Skip if method fails
            end
          end
        end
        output += "\n"
      end
      output += "-----------------------------------------------------------------------\n"
    end

    # Complete weapons table (like TUI)
    output += "WEAPON".ljust(19) + "SKILL".ljust(9) + "INI".ljust(8) + "OFF".ljust(7) + "DEF".ljust(7) + "DAM".ljust(7) + "HP".ljust(6) + "RANGE".ljust(8) + "\n"

    # Get weapon data from legacy NPC properties
    weapon_found = false

    # Check if NPC has wpn_name property (primary weapon)
    if npc.respond_to?(:wpn_name) && npc.wpn_name && !npc.wpn_name.empty? && npc.wpn_name != "Unarmed"
      weapon_name = npc.wpn_name.ljust(19)
      weapon_skill = (npc.wpn_skill || 0).to_s.ljust(9)
      weapon_ini = (npc.wpn_ini || 0).to_s.ljust(8)
      weapon_off = (npc.wpn_off || 0).to_s.ljust(7)
      weapon_def = (npc.wpn_def || 0).to_s.ljust(7)
      weapon_dam = (npc.wpn_dam || 0).to_s.ljust(7)
      weapon_hp = (npc.wpn_hp || 0).to_s.ljust(6)
      weapon_range = (npc.wpn_range || "").to_s.ljust(8)
      output += weapon_name + weapon_skill + weapon_ini + weapon_off + weapon_def + weapon_dam + weapon_hp + weapon_range + "\n"
      weapon_found = true
    end

    # Show missile weapon if assigned
    if npc.respond_to?(:msl_name) && npc.msl_name && !npc.msl_name.empty?
      missile_name = npc.msl_name.ljust(19)
      missile_skill = (npc.msl_skill || 0).to_s.ljust(9)
      missile_ini = (npc.msl_ini || 0).to_s.ljust(8)
      missile_off = (npc.msl_off || 0).to_s.ljust(7)
      missile_dam = (npc.msl_dam || 0).to_s.ljust(7)
      missile_range = (npc.msl_range || 0).to_s.ljust(7)
      output += missile_name + missile_skill + missile_ini + missile_off + "N/A".ljust(7) + missile_dam + "N/A".ljust(6) + missile_range + "\n"
      weapon_found = true
    end

    # Always show unarmed as backup/additional weapon with proper initiative
    unarmed_skill = (npc.respond_to?(:unarmed) ? npc.unarmed : 0).to_s
    character_reaction = npc.respond_to?(:react) ? npc.react : rand(1..10)
    unarmed_ini = character_reaction + 1  # Unarmed base INI modifier is +1
    output += "Unarmed".ljust(19) + unarmed_skill.ljust(9) + unarmed_ini.to_s.ljust(8) + "5".ljust(7) + "4".ljust(7) + "-3".ljust(7) + "0".ljust(6) + "\n"
    weapon_found = true

    if weapon_found
      output += "\n"
    end

    output += "#######################################################################\n"

    puts output
when 'encounter_old'
    # ULTRATHINK: Just call the exact TUI approach - simple and clean

    # Get parameters
    params = {param_str} rescue [1, 1, 0, "", 0]
    time, terrain, level_mod, encounter_type, number = params

    # Step 1: Use the EXACT TUI calculation
    # Load everything the TUI loads
    require '{RUBY_DIR}/includes/includes.rb'
    require '{RUBY_DIR}/includes/class_enc.rb'
    require 'date'

    # Set the EXACT same globals as TUI
    $Day = time
    $Terrain = terrain
    $Level = level_mod
    $Terraintype = $Terrain + (8 * $Day)

    # Call the EXACT same generation as TUI
    encounter_spec = encounter_type.empty? ? "" : encounter_type
    encounter_number = number == 0 ? rand(1..6) : number
    encounter_number = [encounter_number, 10].min

    # Generate exactly like TUI
    enc = Enc.new(encounter_spec, encounter_number)
    e = enc.encounter

    # Step 2: Format for web output cleanly
    puts "############################<By Amar Tools>############################"
    puts ($Day == 1 ? "Day:   Rural     " : "Night: City      ") + "Created: " + Date.today.to_s.rjust(30)
    puts ""

    # Step 3: Output the actual encounters with proper formatting
    if e && e.length > 0
      has_real_encounter = false
      counter = 1
      e.each do |encounter_entry|
        if encounter_entry.is_a?(Hash) && encounter_entry["string"] == "NO ENCOUNTER"
          # Skip the "NO ENCOUNTER" placeholder
        elsif encounter_entry.is_a?(Hash) && encounter_entry["string"]
          # Format the hash encounter properly
          description = encounter_entry["string"]
          puts counter.to_s + ". " + description
          counter += 1
          has_real_encounter = true
        else
          puts counter.to_s + ". " + encounter_entry.to_s
          counter += 1
          has_real_encounter = true
        end
      end

      if !has_real_encounter
        puts "NO ENCOUNTER"
      end
    else
      puts "NO ENCOUNTER"
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
    """Get specific NPC from encounter with preserved stats"""
    params = request.get_json() or {}

    # Generate detailed NPC using the encounter character's stats
    npc_params = {
        'name': params.get('name', ''),
        'type': params.get('type', ''),
        'level': params.get('level', 1),
        'sex': params.get('sex', ''),
        'age': params.get('age', 0)
    }

    # Use the regular NPC generation with encounter character parameters
    result = call_ruby_function('npc', npc_params)
    return jsonify(result)


@app.route('/api/town_relationships', methods=['POST'])
def generate_town_relationships():
    """Generate relationship diagram for specific town"""
    try:
        params = request.get_json() or {}
        town_data = params.get('town_data', '')

        print(f"DEBUG: Generating relationships for town data length: {len(town_data)}")

        # Convert HTML town data back to plain text with proper line breaks
        clean_town_data = town_data.replace('<br>', '\n')  # Convert <br> to newlines first
        clean_town_data = re.sub(r'<[^>]*>', '', clean_town_data)  # Then remove HTML tags
        clean_town_data = clean_town_data.replace('\u2500', '─')  # Fix Unicode line

        # Create unique temp file for this town
        import time
        timestamp = int(time.time())
        temp_town_file = f'/tmp/web_town_{timestamp}.npc'

        with open(temp_town_file, 'w') as f:
            f.write(clean_town_data)

        print(f"DEBUG: Created temp file: {temp_town_file}")

        # Use subprocess to call Ruby relationship generation
        ruby_command = [
            'ruby', '-e', f'''
Dir.chdir("{RUBY_DIR}")
require '{RUBY_DIR}/includes/town_relations.rb'
town_relations("{temp_town_file}")
town_dot2txt("{temp_town_file}")
            '''
        ]

        result = subprocess.run(ruby_command, capture_output=True, text=True, cwd=RUBY_DIR)
        print(f"DEBUG: Ruby result: {result.returncode}, stdout: {result.stdout}, stderr: {result.stderr}")

        # Check for generated PNG
        expected_png = temp_town_file.replace('.npc', '.png')
        print(f"DEBUG: Looking for: {expected_png}")

        if os.path.exists(expected_png):
            print(f"DEBUG: Found PNG: {expected_png}")
            # Copy to static with unique name to avoid caching issues
            static_dir = os.path.join(RUBY_DIR, 'static')
            os.makedirs(static_dir, exist_ok=True)
            final_image_path = os.path.join(static_dir, f'town_relationships_{timestamp}.png')
            shutil.copy2(expected_png, final_image_path)

            # Clean up temp files
            for temp_file in [temp_town_file, expected_png, temp_town_file.replace('.npc', '.dot'), temp_town_file.replace('.npc', '_relations.txt')]:
                try:
                    if os.path.exists(temp_file):
                        os.remove(temp_file)
                except:
                    pass

            return jsonify({'success': True, 'image_url': f'/static/town_relationships_{timestamp}.png'})
        else:
            print(f"DEBUG: PNG not found")
            return jsonify({'success': False, 'error': f'No PNG generated at {expected_png}'})

    except Exception as e:
        print(f"DEBUG: Exception: {e}")
        return jsonify({'success': False, 'error': str(e)})

@app.route('/static/<path:filename>')
def serve_static(filename):
    """Serve static files like images"""
    static_dir = os.path.join(RUBY_DIR, 'static')
    return send_from_directory(static_dir, filename)

if __name__ == '__main__':
    print("=" * 60)
    print("  Amar RPG Tools - Web Interface")
    print("=" * 60)
    print(f"Ruby backend directory: {RUBY_DIR}")
    print("Starting Flask server on http://localhost:5001")
    print("Press Ctrl+C to stop")
    print("=" * 60)

    app.run(debug=True, host='0.0.0.0', port=5001)