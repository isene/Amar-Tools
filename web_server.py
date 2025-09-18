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

        # Create a temporary Ruby script that calls the function
        ruby_code = f"""
# Load the Amar Tools environment
Dir.chdir('{RUBY_DIR}')
$LOAD_PATH.unshift('{RUBY_DIR}')
$pgmdir = '{RUBY_DIR}'

# Load all required files
require_relative 'includes/includes.rb'
require_relative 'cli_npc_output_new.rb'

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

    # Generate output exactly as TUI does (without colors for web)
    output = npc_output_new(npc, 'web', 120)
    puts output
when 'encounter'
    # Load encounter system
    require_relative 'cli_enc_output_new.rb'

    # Initialize global variables needed for encounter output
    $Day = 1  # 1 = day, 0 = night
    $Terrain = rand(8)  # 0-7 for different terrain types
    $Level = rand(1..5)  # Random level modifier

    enc = EncNew.new
    output = enc_output_new(enc, 'web', 120)
    puts output
when 'monster'
    # Load monster system
    require_relative 'includes/class_monster_new.rb'

    # Pick a random monster type
    monster_types = ["Wolf", "Bear", "Dragon", "Orc", "Goblin", "Troll", "Giant Spider", "Dire Wolf"]
    monster_type = monster_types.sample
    level = rand(1..5)

    begin
      monster = MonsterNew.new(monster_type, level)
      puts "Generated Monster:"
      puts "Name: #{{monster.name || monster_type}}"
      puts "Type: #{{monster.type}}"
      puts "Level: #{{monster.level}}"
      puts "SIZE: #{{monster.SIZE}}"
      puts "Body Points: #{{monster.BP}}"
      puts "Damage Bonus: #{{monster.DB}}"
      puts "Movement: #{{monster.MD}}"
      if monster.special_abilities && !monster.special_abilities.to_s.empty?
        abilities = monster.special_abilities.is_a?(Array) ? monster.special_abilities.join(', ') : monster.special_abilities.to_s
        puts "Special Abilities: #{{abilities}}"
      end
      puts ""
      puts "A fearsome creature with natural weapons and abilities."
    rescue => e
      # Fallback if monster system isn't fully loaded
      puts "Generated Monster:"
      puts "Name: #{{monster_type}}"
      puts "Level: #{{level}}"
      puts "A dangerous creature encountered in the wild."
      puts ""
      puts "Note: Full monster stats require complete monster tables."
      puts "Error: #{{e.message}}"
    end
when 'weather'
    # Load weather system
    require_relative 'includes/weather.rb'

    # Initialize weather globals
    $weather_n = 5   # Normal weather
    $wind_dir_n = 0  # Wind direction
    $wind_str_n = 0  # Wind strength
    $mn = rand(14)   # Random month (0-13)

    # Generate a weather day
    weather_day = Weather_day.new($weather_n, $wind_dir_n, $wind_str_n, $mn, rand(30))
    puts "Weather for today:"
    puts "Conditions: #{{weather_day.weather}}"
    puts "Wind: Direction #{{weather_day.wind_dir}}, Strength #{{weather_day.wind_str}}"
    puts "Special: #{{weather_day.special || 'None'}}"
when 'town'
    # Load town system
    require_relative 'includes/class_town.rb'
    town = Town.new
    puts "Town: " + town.name
    puts "Population: " + town.population.to_s
when 'names'
    # Simple name generation using predefined lists
    puts "Random Names Generated:"
    puts ""

    # Sample fantasy names
    male_names = ["Aldric", "Bran", "Caelum", "Darian", "Eamon", "Finn", "Gareth", "Hadric", "Ivan", "Joren", "Kael", "Lucian", "Magnus", "Nolan", "Orin", "Piers", "Quinn", "Roderick", "Silas", "Theron"]
    female_names = ["Aria", "Brenna", "Cora", "Dahlia", "Elara", "Freya", "Gaia", "Helena", "Isla", "Jessa", "Kira", "Luna", "Mira", "Nova", "Ophelia", "Petra", "Quinn", "Rhea", "Sera", "Tessa"]
    surnames = ["Blackwood", "Stormwind", "Ironforge", "Goldleaf", "Silverblade", "Thornwick", "Ravencrest", "Brightstar", "Shadowmere", "Frostborn", "Emberfall", "Moonwhisper", "Starweaver", "Dragonborn", "Nightfall"]

    puts "Male Names:"
    5.times do
      first = male_names.sample
      last = surnames.sample
      puts "  #{{first}} #{{last}}"
    end

    puts ""
    puts "Female Names:"
    5.times do
      first = female_names.sample
      last = surnames.sample
      puts "  #{{first}} #{{last}}"
    end

    puts ""
    puts "Single Names (Fantasy):"
    fantasy_names = ["Zephyr", "Mystral", "Umbra", "Solara", "Vortex", "Zenith", "Nexus", "Prism", "Echo", "Raven"]
    5.times do
      puts "  #{{fantasy_names.sample}}"
    end
when 'roll'
    # Open-ended d6 roll
    roll = rand(1..6)
    total = roll
    explanation = "Initial roll: #{{roll}}"

    while roll == 6
        roll = rand(1..6)
        total += roll
        explanation += "\\nRolled 6! Bonus roll: #{{roll}}"
    end

    puts "Final Result: #{{total}}"
    puts explanation
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
            return {'success': True, 'output': result.stdout.strip()}
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

if __name__ == '__main__':
    print("=" * 60)
    print("  Amar RPG Tools - Web Interface")
    print("=" * 60)
    print(f"Ruby backend directory: {RUBY_DIR}")
    print("Starting Flask server on http://localhost:5000")
    print("Press Ctrl+C to stop")
    print("=" * 60)

    app.run(debug=True, host='0.0.0.0', port=5000)