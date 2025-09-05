#!/usr/bin/env ruby
# encoding: utf-8

# AMAR TUI - Terminal User Interface for Amar RPG Tools
# Based on rcurses library
# Author: Geir Isene & Claude

# REQUIRED GEMS
begin
  require 'rcurses'
  include Rcurses
  include Rcurses::Input
  include Rcurses::Cursor
rescue LoadError
  puts "ERROR: Amar TUI requires rcurses gem"
  puts "Install with: gem install rcurses"
  exit 1
end

require 'io/console'
require 'fileutils'

# GLOBAL VARS & CONSTANTS
@version = "1.0.0"
@pgmdir = File.dirname(__FILE__)

# Load includes
load File.join(@pgmdir, "includes/includes.rb")

# CONFIGURATION
@config = {
  show_borders: true,
  color_mode: true,
  auto_save: true,
  last_npc: nil,
  last_encounter: nil
}

CONFIG_FILE = File.join(Dir.home, '.amar_tui.conf')

# COLOR SCHEME
@colors = {
  header: 24,      # Dark blue
  menu: 236,       # Dark gray
  content: 232,    # Very dark (almost black)
  highlight: 226,  # Yellow
  border: 245,     # Light gray
  error: 196,      # Red
  success: 46,     # Green
  info: 39        # Cyan
}

# HELP TEXT
@help = <<~HELP
  AMAR RPG TOOLS - TUI Version #{@version}
  
  MAIN MENU NAVIGATION:
    j/↓    Move down in menu
    k/↑    Move up in menu
    Enter  Select menu item
    q      Quit application
    ?      Show this help
    
  NPC/ENCOUNTER VIEW:
    j/↓    Scroll down
    k/↑    Scroll up
    PgDn   Page down
    PgUp   Page up
    e      Edit in editor
    s      Save to file
    r      Regenerate
    ESC    Back to menu
    
  SHORTCUTS:
    n      Quick NPC generation
    e      Quick encounter generation
    m      Quick monster generation
    d      Roll dice
    w      Weather generation
    t      Town generation
HELP

# HELPER METHODS
def save_config
  File.write(CONFIG_FILE, @config.to_json)
rescue => e
  # Silent fail for config save
end

def load_config
  if File.exist?(CONFIG_FILE)
    @config = JSON.parse(File.read(CONFIG_FILE), symbolize_names: true)
  end
rescue => e
  # Use defaults if config load fails
end

def init_screen
  Rcurses.init!
  Rcurses::Cursor.hide  # Hide cursor
  @rows, @cols = IO.console.winsize
  
  # Create main panes
  #                     x   y   width        height      fg              bg
  @header = Pane.new(   1,  1,  @cols,       2,          255,            @colors[:header])
  @menu   = Pane.new(   2,  4,  30,          @rows - 5,  255,            @colors[:menu])
  @content= Pane.new(   34, 4,  @cols - 35,  @rows - 5,  255,            @colors[:content])
  @footer = Pane.new(   1,  @rows, @cols,    1,          255,            @colors[:info])
  
  # Set borders
  if @config[:show_borders]
    @menu.border = true
    @content.border = true
  end
  
  # Initialize menu
  @menu_items = [
    "── NEW 3-TIER SYSTEM ──",
    "1. Generate NPC",
    "2. Generate Encounter", 
    "3. Generate Monster",
    "",
    "── OLD SYSTEM ──",
    "4. Old NPC Generator",
    "5. Old Encounter",
    "",
    "── UTILITIES ──",
    "6. Roll Dice",
    "7. Weather Generator",
    "8. Town Generator",
    "9. Name Generator",
    "",
    "── OPTIONS ──",
    "B. Toggle Borders",
    "C. Color Mode",
    "H. Help",
    "Q. Quit"
  ]
  @menu_index = 1  # Start at first selectable item
  
  refresh_all
end

def refresh_all
  @header.full_refresh
  @menu.full_refresh
  @content.full_refresh
  @footer.full_refresh
  draw_header
  draw_menu
  draw_footer
end

def draw_header
  title = " AMAR RPG TOOLS - TUI v#{@version} ".center(@cols)
  subtitle = " The Ultimate Amar RPG Toolkit ".center(@cols)
  
  @header.say(title + "\n" + subtitle)
end

def draw_menu
  menu_text = ""
  
  @menu_items.each_with_index do |item, idx|
    if item.empty? || item.start_with?("──")
      # Section header or blank
      if item.start_with?("──") && @config[:color_mode]
        menu_text += "\e[1;36m#{item}\e[0m\n"  # Cyan bold
      else
        menu_text += item + "\n"
      end
    elsif idx == @menu_index
      # Highlighted item
      if @config[:color_mode]
        menu_text += "\e[1;33;44m▸ #{item}\e[0m\n"  # Yellow on blue
      else
        menu_text += "▸ #{item}\n"
      end
    else
      menu_text += "  #{item}\n"
    end
  end
  
  @menu.say(menu_text)
end

def draw_footer
  help = " [?] Help | [↑↓] Navigate | [Enter] Select | [q] Quit "
  @footer.say(help.center(@cols))
end

def show_content(text)
  @content.text = text
  @content.ix = 0
  @content.refresh
end

def show_popup(title, content, width = 60, height = 20)
  # Calculate popup position (centered)
  x = (@cols - width) / 2
  y = (@rows - height) / 2
  
  # Create popup pane
  popup = Pane.new(x, y, width, height, 255, 234)
  popup.border = true
  
  # Format content with title
  formatted = "═" * (width - 4) + "\n"
  formatted += title.center(width - 4) + "\n"  
  formatted += "─" * (width - 4) + "\n"
  formatted += content
  
  popup.say(formatted)
  
  # Wait for key to dismiss
  loop do
    key = getch
    break if key == "\e" || key == "q" || key == "\r"
    
    case key
    when "j", "\e[B"  # Down
      popup.linedown
    when "k", "\e[A"  # Up
      popup.lineup
    when "\e[6~"  # PgDn
      popup.pagedown
    when "\e[5~"  # PgUp
      popup.pageup
    end
  end
  
  refresh_all
end

def handle_menu_navigation
  key = getch
  
  case key
  when "j", "\e[B"  # Down arrow
    loop do
      @menu_index = (@menu_index + 1) % @menu_items.length
      break unless @menu_items[@menu_index].empty? || @menu_items[@menu_index].start_with?("──")
    end
    draw_menu
    
  when "k", "\e[A"  # Up arrow  
    loop do
      @menu_index = (@menu_index - 1) % @menu_items.length
      break unless @menu_items[@menu_index].empty? || @menu_items[@menu_index].start_with?("──")
    end
    draw_menu
    
  when "\r"  # Enter
    execute_menu_item
    
  when "?"
    show_popup("HELP", @help)
    
  when "q", "Q"
    return false
    
  # Shortcuts
  when "n", "1"
    generate_npc_new
  when "e", "2"
    generate_encounter_new
  when "m", "3"
    generate_monster_new
  when "d", "6"
    roll_dice_ui
  when "w", "7"
    generate_weather_ui
  when "t", "8"
    generate_town_ui
  when "b", "B"
    toggle_borders
  when "h", "H"
    show_popup("HELP", @help)
  end
  
  true
end

def execute_menu_item
  item = @menu_items[@menu_index]
  
  case item
  when /Generate NPC/
    generate_npc_new
  when /Generate Encounter/
    generate_encounter_new
  when /Generate Monster/
    generate_monster_new
  when /Old NPC/
    generate_npc_old
  when /Old Encounter/
    generate_encounter_old
  when /Roll Dice/
    roll_dice_ui
  when /Weather/
    generate_weather_ui
  when /Town/
    generate_town_ui
  when /Name/
    generate_name_ui
  when /Toggle Borders/
    toggle_borders
  when /Color Mode/
    toggle_colors
  when /Help/
    show_popup("HELP", @help)
  when /Quit/
    return false
  end
end

def toggle_borders
  @config[:show_borders] = !@config[:show_borders]
  @menu.border = @config[:show_borders]
  @content.border = @config[:show_borders]
  refresh_all
  show_content("Borders #{@config[:show_borders] ? 'enabled' : 'disabled'}")
end

def toggle_colors
  @config[:color_mode] = !@config[:color_mode]
  refresh_all
  show_content("Color mode #{@config[:color_mode] ? 'enabled' : 'disabled'}")
end

# NPC GENERATION (NEW SYSTEM)
def generate_npc_new
  show_content("Generating NPC (New 3-Tier System)...\n\nPress any key for random, or:\n1-6 for level\nOr ESC to cancel")
  
  key = getch
  return if key == "\e"
  
  level = key.to_i if key =~ /[1-6]/
  level ||= 0  # Random
  
  # Generate NPC
  begin
    npc = NpcNew.new("", "", level)
    
    # Format output
    output = format_npc_new(npc)
    show_content(output)
    
    # Handle NPC view navigation
    handle_content_view(npc, :npc)
  rescue => e
    show_content("Error generating NPC: #{e.message}")
  end
end

# ENCOUNTER GENERATION (NEW SYSTEM) 
def generate_encounter_new
  show_content("Generating Encounter...\n\nPress any key for random encounter\nOr ESC to cancel")
  
  key = getch
  return if key == "\e"
  
  begin
    # Generate random encounter
    enc = EncNew.new
    
    # Format output
    output = format_encounter_new(enc)
    show_content(output)
    
    # Handle encounter view navigation
    handle_content_view(enc, :encounter)
  rescue => e
    show_content("Error generating encounter: #{e.message}")
  end
end

def format_npc_new(npc)
  output = "═" * 60 + "\n"
  output += "NPC: #{npc.name} (#{npc.sex}, #{npc.age})\n"
  output += "Type: #{npc.type} | Level: #{npc.level}\n"
  output += "─" * 60 + "\n\n"
  
  # Stats
  output += "CHARACTERISTICS:\n"
  output += "  SIZE: #{npc.SIZE}\n"
  output += "  BODY: #{npc.get_characteristic('BODY')}\n"
  output += "  MIND: #{npc.get_characteristic('MIND')}\n"
  output += "  SPIRIT: #{npc.get_characteristic('SPIRIT')}\n\n"
  
  # Derived stats
  output += "DERIVED STATS:\n"
  output += "  BP: #{npc.BP} | DB: #{npc.DB} | MD: #{npc.MD}\n\n"
  
  # Skills
  output += "KEY SKILLS:\n"
  npc.tiers.each do |char, attrs|
    attrs.each do |attr_name, attr_data|
      next unless attr_data.is_a?(Hash) && attr_data["skills"]
      attr_data["skills"].each do |skill, value|
        next if value == 0
        total = npc.get_skill_total(char, attr_name, skill)
        output += "  #{skill}: #{total}\n"
      end
    end
  end
  
  output
end

def format_encounter_new(enc)
  output = "═" * 60 + "\n"
  output += "ENCOUNTER: #{enc.enc_attitude}\n"
  output += "#{enc.summary}\n"
  output += "─" * 60 + "\n\n"
  
  enc.npcs.each_with_index do |npc, idx|
    output += "#{idx + 1}. #{npc.name} - #{npc.type} [Level #{npc.level}]\n"
    output += "   BP: #{npc.BP} | DB: #{npc.DB} | MD: #{npc.MD}\n"
    
    # Show primary weapon
    if npc.respond_to?(:melee_weapon) && npc.melee_weapon
      output += "   Weapon: #{npc.melee_weapon}\n"
    end
    output += "\n"
  end
  
  output
end

def handle_content_view(object, type)
  loop do
    key = getch
    
    case key
    when "\e", "q"  # ESC or q to go back
      break
    when "j", "\e[B"  # Scroll down
      @content.linedown
    when "k", "\e[A"  # Scroll up
      @content.lineup
    when "\e[6~"  # PgDn
      @content.pagedown
    when "\e[5~"  # PgUp
      @content.pageup
    when "r"  # Regenerate
      if type == :npc
        generate_npc_new
      elsif type == :encounter
        generate_encounter_new
      elsif type == :monster
        generate_monster_new
      end
      break
    when "s"  # Save
      save_to_file(object, type)
    when "e"  # Edit in external editor
      edit_in_editor(@content.text)
    end
  end
end

def save_to_file(object, type)
  timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
  filename = "saved/#{type}_#{timestamp}.txt"
  
  FileUtils.mkdir_p("saved")
  File.write(filename, @content.text)
  
  show_popup("SAVED", "Saved to: #{filename}\n\nPress any key to continue")
end

def edit_in_editor(text)
  require 'tempfile'
  
  Tempfile.create(['amar', '.txt']) do |f|
    f.write(text)
    f.flush
    
    editor = ENV['EDITOR'] || 'vim'
    system("#{editor} #{f.path}")
    
    # Could reload content here if needed
  end
end

# DICE ROLLER
def roll_dice_ui
  show_popup("DICE ROLLER", "Enter dice notation (e.g., 3d6+2):\n\nOr press ESC to cancel")
  
  # Simple dice roller implementation
  dice_input = ""
  loop do
    key = getch
    break if key == "\e"
    
    if key == "\r" && !dice_input.empty?
      result = roll_dice(dice_input)
      show_popup("DICE RESULT", "Rolling: #{dice_input}\n\nResult: #{result}")
      break
    elsif key =~ /[0-9d+\-]/
      dice_input += key
      show_popup("DICE ROLLER", "Enter dice notation: #{dice_input}\n\nPress Enter to roll")
    end
  end
end

def roll_dice(notation)
  # Parse dice notation like "3d6+2"
  if notation =~ /(\d+)d(\d+)([+\-]\d+)?/
    num = $1.to_i
    sides = $2.to_i
    mod = $3.to_i
    
    total = (1..num).map { rand(1..sides) }.sum + mod
    return total
  else
    return "Invalid notation"
  end
end

# MONSTER GENERATION (NEW SYSTEM)
def generate_monster_new
  show_content("Generating Monster...\n\nPress any key for random monster\nOr ESC to cancel")
  
  key = getch
  return if key == "\e"
  
  begin
    # Get random monster type from monster_stats
    load File.join(@pgmdir, "includes/tables/monster_stats_new.rb") unless defined?($MonsterStats)
    monster_type = $MonsterStats.keys.sample
    level = rand(1..6)
    
    monster = MonsterNew.new(monster_type, level)
    
    # Format output
    output = format_monster_new(monster)
    show_content(output)
    
    # Handle monster view navigation
    handle_content_view(monster, :monster)
  rescue => e
    show_content("Error generating monster: #{e.message}")
  end
end

def format_monster_new(monster)
  output = "═" * 60 + "\n"
  output += "MONSTER: #{monster.name} (Level #{monster.level})\n"
  output += "Type: #{monster.type}\n"
  output += "─" * 60 + "\n\n"
  
  # Physical stats
  output += "PHYSICAL:\n"
  output += "  Weight: #{monster.weight} kg | SIZE: #{monster.SIZE}\n"
  output += "  BP: #{monster.BP} | DB: #{monster.DB} | MD: #{monster.MD}\n\n"
  
  # Special abilities
  if monster.special_abilities && !monster.special_abilities.empty?
    output += "SPECIAL ABILITIES:\n"
    output += "  #{monster.special_abilities}\n\n"
  end
  
  # Combat skills
  output += "COMBAT SKILLS:\n"
  monster.tiers["BODY"]["Melee Combat"]["skills"].each do |skill, value|
    next if value == 0
    total = monster.get_skill_total("BODY", "Melee Combat", skill)
    output += "  #{skill}: #{total}\n"
  end
  
  # Spells if any
  if monster.spells && !monster.spells.empty?
    output += "\nSPELLS:\n"
    monster.spells.each do |spell|
      output += "  #{spell['name']} (#{spell['domain']})\n"
    end
  end
  
  output
end

# NPC GENERATION (OLD SYSTEM)
def generate_npc_old
  show_content("Generating NPC (Old System)...\n\nPress any key to continue\nOr ESC to cancel")
  
  key = getch
  return if key == "\e"
  
  begin
    # Use the old system
    npc_string = `ruby #{File.join(@pgmdir, "randomizer.rb")} npc`
    show_content(npc_string)
    
    # Simple navigation for old system output
    loop do
      key = getch
      case key
      when "\e", "q"
        break
      when "j", "\e[B"
        @content.linedown
      when "k", "\e[A" 
        @content.lineup
      when "\e[6~"
        @content.pagedown
      when "\e[5~"
        @content.pageup
      when "r"
        generate_npc_old
        break
      when "s"
        save_to_file(npc_string, :npc_old)
      end
    end
  rescue => e
    show_content("Error generating NPC: #{e.message}")
  end
end

# ENCOUNTER GENERATION (OLD SYSTEM)
def generate_encounter_old
  show_content("Generating Encounter (Old System)...\n\nPress any key to continue\nOr ESC to cancel")
  
  key = getch
  return if key == "\e"
  
  begin
    # Use the old system
    enc_string = `ruby #{File.join(@pgmdir, "randomizer.rb")} enc`
    show_content(enc_string)
    
    # Simple navigation
    loop do
      key = getch
      case key
      when "\e", "q"
        break
      when "j", "\e[B"
        @content.linedown
      when "k", "\e[A"
        @content.lineup
      when "\e[6~"
        @content.pagedown
      when "\e[5~"
        @content.pageup
      when "r"
        generate_encounter_old
        break
      when "s"
        save_to_file(enc_string, :encounter_old)
      end
    end
  rescue => e
    show_content("Error generating encounter: #{e.message}")
  end
end

# WEATHER GENERATOR
def generate_weather_ui
  show_content("Generating Weather...\n\nPress any key to continue\nOr ESC to cancel")
  
  key = getch
  return if key == "\e"
  
  begin
    # Generate weather
    weather_string = `ruby #{File.join(@pgmdir, "randomizer.rb")} weather`
    
    # Format for display
    output = "═" * 60 + "\n"
    output += "WEATHER CONDITIONS\n"
    output += "─" * 60 + "\n\n"
    output += weather_string
    
    show_content(output)
    
    # Simple navigation
    loop do
      key = getch
      case key
      when "\e", "q"
        break
      when "r"
        generate_weather_ui
        break
      when "s"
        save_to_file(output, :weather)
      end
    end
  rescue => e
    show_content("Error generating weather: #{e.message}")
  end
end

# TOWN GENERATOR  
def generate_town_ui
  show_content("Generating Town...\n\nEnter town size (1-5):\n1=Hamlet 2=Village 3=Town 4=City 5=Metropolis\n\nOr press ESC to cancel")
  
  key = getch
  return if key == "\e"
  
  size = key.to_i
  size = rand(1..5) if size < 1 || size > 5
  
  begin
    # Generate town
    town_string = `ruby #{File.join(@pgmdir, "randomizer.rb")} town #{size}`
    
    # Format for display
    output = "═" * 60 + "\n"
    output += "TOWN DETAILS\n"
    output += "─" * 60 + "\n\n"
    output += town_string
    
    show_content(output)
    
    # Navigation
    loop do
      key = getch
      case key
      when "\e", "q"
        break
      when "j", "\e[B"
        @content.linedown
      when "k", "\e[A"
        @content.lineup
      when "\e[6~"
        @content.pagedown
      when "\e[5~"
        @content.pageup
      when "r"
        generate_town_ui
        break
      when "s"
        save_to_file(output, :town)
      end
    end
  rescue => e
    show_content("Error generating town: #{e.message}")
  end
end

# NAME GENERATOR
def generate_name_ui
  cultures = ["Norse", "Greek", "Roman", "Egyptian", "Japanese", "Chinese", 
              "Arabic", "Celtic", "Slavic", "Fantasy"]
  
  menu_text = "Select Name Culture:\n\n"
  cultures.each_with_index do |culture, idx|
    menu_text += "#{idx + 1}. #{culture}\n"
  end
  menu_text += "\n0. Random\n\nOr press ESC to cancel"
  
  show_content(menu_text)
  
  key = getch
  return if key == "\e"
  
  culture_idx = key.to_i
  culture = culture_idx > 0 && culture_idx <= cultures.length ? cultures[culture_idx - 1] : cultures.sample
  
  begin
    # Generate multiple names
    output = "═" * 60 + "\n"
    output += "#{culture.upcase} NAMES\n"
    output += "─" * 60 + "\n\n"
    
    output += "MALE NAMES:\n"
    10.times do
      name = `ruby #{File.join(@pgmdir, "randomizer.rb")} name #{culture} male`.strip
      output += "  #{name}\n"
    end
    
    output += "\nFEMALE NAMES:\n"
    10.times do
      name = `ruby #{File.join(@pgmdir, "randomizer.rb")} name #{culture} female`.strip
      output += "  #{name}\n"
    end
    
    show_content(output)
    
    # Navigation
    loop do
      key = getch
      case key
      when "\e", "q"
        break
      when "j", "\e[B"
        @content.linedown
      when "k", "\e[A"
        @content.lineup
      when "r"
        generate_name_ui
        break
      when "s"
        save_to_file(output, :names)
      end
    end
  rescue => e
    show_content("Error generating names: #{e.message}")
  end
end

# MAIN LOOP
def main_loop
  load_config
  init_screen
  
  running = true
  while running
    running = handle_menu_navigation
  end
  
  save_config
rescue => e
  File.write("amar_tui_error.log", "#{Time.now}: #{e.message}\n#{e.backtrace.join("\n")}")
ensure
  Rcurses.cleanup!
  Rcurses::Cursor.show  # Show cursor again
end

# START APPLICATION
if __FILE__ == $0
  main_loop
end