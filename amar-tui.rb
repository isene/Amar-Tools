#!/usr/bin/env ruby
# encoding: utf-8

# AMAR TUI - Terminal User Interface for Amar RPG Tools
# Based on rcurses library
# Author: Geir Isene & Claude

# Wrap everything to catch top-level errors
begin

# REQUIRED GEMS
begin
  require 'rcurses'
  include Rcurses
  include Rcurses::Input
rescue LoadError
  puts "ERROR: Amar TUI requires rcurses gem"
  puts "Install with: gem install rcurses"
  exit 1
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

require 'io/console'
require 'fileutils'
require 'json'  # Needed for config save/load
require 'stringio'  # For suppressing output
require 'fcntl'  # For non-blocking IO

# GLOBAL VARS & CONSTANTS
@version = "1.0.0"
$pgmdir = File.dirname(__FILE__)  # Global for includes

# Debug logging
begin
  $debug_log = File.open("/tmp/amar_tui_debug.log", "w")
  $debug_log.sync = true
rescue => e
  puts "Warning: Could not open debug log: #{e.message}"
  $debug_log = nil
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def debug(msg)
  return unless $debug_log
  begin
    $debug_log.puts "[#{Time.now}] #{msg}"
    $debug_log.flush
  rescue => e
    # Silent fail if debug log fails
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

debug "Starting TUI - version #{@version}"
debug "Program directory: #{$pgmdir}"

# Load includes
begin
  debug "Loading includes..."
  includes_file = File.join($pgmdir, "includes/includes.rb")
  debug "Loading from: #{includes_file}"
  debug "File exists: #{File.exist?(includes_file)}"
  
  load includes_file
  debug "Includes loaded successfully"
  
  # Load CLI output functions
  debug "Loading CLI output functions..."
  npc_output_file = File.join($pgmdir, "cli_npc_output_new.rb")
  if File.exist?(npc_output_file)
    load npc_output_file
    debug "Loaded cli_npc_output_new.rb"
  else
    debug "cli_npc_output_new.rb not found at #{npc_output_file}"
  end
  
  enc_output_file = File.join($pgmdir, "cli_enc_output_new.rb")
  if File.exist?(enc_output_file)
    load enc_output_file
    debug "Loaded cli_enc_output_new.rb"
  else
    debug "cli_enc_output_new.rb not found at #{enc_output_file}"
  end
  
  # Load old system output functions
  old_npc_file = File.join($pgmdir, "cli_npc_output.rb")
  if File.exist?(old_npc_file)
    load old_npc_file
    debug "Loaded cli_npc_output.rb"
  end
  
  old_enc_file = File.join($pgmdir, "cli_enc_output.rb")
  if File.exist?(old_enc_file)
    load old_enc_file
    debug "Loaded cli_enc_output.rb"
  end
  
  town_output_file = File.join($pgmdir, "cli_town_output.rb")
  if File.exist?(town_output_file)
    load town_output_file
    debug "Loaded cli_town_output.rb"
  end
  
  # Verify critical classes and variables are loaded
  debug "Checking loaded classes and variables..."
  debug "NpcNew defined: #{defined?(NpcNew)}"
  debug "EncNew defined: #{defined?(EncNew)}"
  debug "MonsterNew defined: #{defined?(MonsterNew)}"
  debug "$ChartypeNew defined: #{defined?($ChartypeNew)}"
  debug "$ChartypeNew has #{$ChartypeNew.keys.length if defined?($ChartypeNew) && $ChartypeNew} keys" if defined?($ChartypeNew) && $ChartypeNew
rescue => e
  debug "Error loading includes: #{e.message}"
  debug e.backtrace.join("\n") if e.backtrace
  puts "Fatal: Could not load includes - #{e.message}"
  exit 1
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

debug "After includes load block"

# Test point after includes
debug "About to define configuration"

# CONFIGURATION
@config = {
  show_borders: true,
  auto_save: true,
  last_npc: nil,
  last_encounter: nil
}

debug "Configuration initialized"

debug "Defining CONFIG_FILE constant"
CONFIG_FILE = File.join(Dir.home, '.amar_tui.conf')
debug "CONFIG_FILE defined as: #{CONFIG_FILE}"

# COLOR SCHEME
debug "Defining colors hash"
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
debug "Colors defined"

# HELP TEXT
debug "Defining help text"
@help = <<~HELP
  MAIN MENU NAVIGATION:
    j/↓    Move down in menu
    k/↑    Move up in menu
    Enter  Select menu item
    TAB    Switch focus between panes
    q      Quit application
    ?      Show this help

  SHORTCUTS:
    The first letter of each menu item acts as a shortcut key.
    You can also use number keys 1-9 for quick selection.

  CONTENT VIEW NAVIGATION:
    j/↓    Scroll down
    k/↑    Scroll up
    Space  Page down
    PgUp   Page up
    g      Go to top
    G      Go to bottom
    e      Edit in external editor (when content present)
    y      Copy to clipboard
    s      Save to file
    r      Re-generate content (roll again)
    Ctrl-L Refresh/redraw screen
    ESC/q  Back to menu

  INPUT WIZARDS:
    ESC    Cancel at any prompt
    Enter  Accept current input/default
    Tab    Auto-complete (where available)

  SPECIAL KEYS:
    →      Activate menu item (when menu focused)
    ←      Return to menu (when content focused)
    v      Toggle view (for maps/images)
    o      Open file (for PDFs)
HELP
debug "Help text defined"

# HELPER METHODS
debug "Defining helper methods"
def save_config
  File.write(CONFIG_FILE, @config.to_json)
rescue => e
  # Silent fail for config save
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def load_config
  if File.exist?(CONFIG_FILE)
    @config = JSON.parse(File.read(CONFIG_FILE), symbolize_names: true)
  end
rescue => e
  # Use defaults if config load fails
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def init_screen
  debug "Initializing screen..."

  begin
    debug "Calling Rcurses.init!"
    Rcurses.init!
    # Clear screen immediately to remove any artifacts
    Rcurses.clear_screen
    debug "Rcurses initialized"
  rescue => e
    debug "Error initializing Rcurses: #{e.message}"
    raise
  end
  
  begin
    debug "Hiding cursor"
    Cursor.hide  # Hide cursor
    debug "Cursor hidden"
  rescue => e
    debug "Error hiding cursor: #{e.message}"
    raise
  end
  
  # Get terminal size - fallback to defaults if console not available
  debug "Getting terminal size..."
  if IO.console
    @rows, @cols = IO.console.winsize
    debug "Terminal size: #{@rows}x#{@cols}"
  else
    @rows, @cols = 24, 80  # Default terminal size
    debug "Using default terminal size: #{@rows}x#{@cols}"
  end
  
  # Create main panes
  debug "Creating panes..."
  begin
    #                     x   y   width        height      fg              bg
    debug "Creating header pane"
    @header = Pane.new(   1,  1,  @cols,       1,          255,            237)  # Medium grey background
    debug "Creating menu pane"
    @menu   = Pane.new(   2,  3,  30,          @rows - 4,  255,            232)  # Black background
    debug "Creating content pane"
    @content= Pane.new(   34, 3,  @cols - 35,  @rows - 4,  255,            @colors[:content])
    debug "Creating footer pane"
    @footer = Pane.new(   1,  @rows, @cols,    1,          255,            237)  # Medium grey background
    debug "All panes created"
  rescue => e
    debug "Error creating panes: #{e.message}"
    debug e.backtrace.join("\n")
    raise
  end
  
  # Set initial focus and borders
  @focus = :menu if !defined?(@focus)
  if @config[:show_borders]
    # Only show border on focused pane
    @menu.border = (@focus == :menu)
    @content.border = (@focus == :content)
  end
  
  # Initialize menu
  @menu_items = [
    "── NEW 3-TIER SYSTEM ──",
    "N. Generate NPC",
    "E. Generate Encounter",
    "M. Generate Monster",
    "",
    "── WORLD BUILDING ──",
    "T. Town/City Generator",
    "R. Town Relations",
    "V. Show Town Relations Map",
    "W. Weather Generator",
    "G. Name Generator",
    "",
    "── AI TOOLS ──",
    "A. Generate Adventure",
    "C. Describe Encounter",
    "D. Describe NPC",
    "I. Generate NPC Image",
    "S. Show Latest NPC Image",
    "",
    "── UTILITIES ──",
    "O. Roll Open Ended d6",
    "?. Help",
    "",
    "── LEGACY SYSTEM ──",
    "1. Old NPC Generator",
    "2. Old Encounter",
    "",
    "Q. Quit"
  ]
  @menu_index = 1  # Start at first selectable item
  @focus = :menu   # Track which pane has focus (:menu or :content)

  refresh_all
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
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

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def recreate_panes
  # Store current content
  old_content = @content.text if @content

  # Get new dimensions
  @rows, @cols = IO.console.winsize

  # Clear screen
  Rcurses.clear_screen  # Clear screen and move cursor home

  # Recreate panes with new dimensions
  @header = Pane.new(   1,  1,  @cols,       1,          255,            234)  # Dark grey background
  @menu   = Pane.new(   2,  3,  30,          @rows - 4,  255,            232)  # Black background
  @content= Pane.new(   34, 3,  @cols - 35,  @rows - 4,  255,            @colors[:content])
  @footer = Pane.new(   1,  @rows, @cols,    1,          255,            234)  # Dark grey background

  # Set initial focus and borders
  @focus = :menu if !defined?(@focus)
  if @config[:show_borders]
    # Only show border on focused pane
    @menu.border = (@focus == :menu)
    @content.border = (@focus == :content)
  end

  # Redraw everything
  draw_header
  draw_menu
  draw_footer

  # Restore content
  @content.say(old_content) if old_content

  refresh_all
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def draw_header
  # Left justify the title text with padding
  title = " AMAR RPG TOOLS - The Ultimate Amar RPG Toolkit | [?] Help"
  @header.say(title)
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def draw_menu
  menu_text = ""

  @menu_items.each_with_index do |item, idx|
    if item.empty? || item.start_with?("──")
      # Section header or blank
      if item.start_with?("──") && true
        # Different colors for different sections
        color = case item
                when /NEW 3-TIER/ then 42   # Green
                when /LEGACY/ then 240       # Grey for legacy
                when /WORLD BUILDING/ then 131  # Brown/orange
                when /AI TOOLS/ then 103     # Light purple
                when /UTILITIES/ then 133    # Light magenta
                else 36  # Default cyan
                end
        menu_text += item.fg(color).b + "\n"
      else
        menu_text += item + "\n"
      end
    elsif idx == @menu_index
      # Highlighted item - RTFM style (bold arrow, underlined item)
      if true
        menu_text += "→ ".b + item.u + "\n"  # Bold arrow, underlined item
      else
        menu_text += "→ " + item.u + "\n"  # Underlined item
      end
    else
      # Grey out legacy items
      if item =~ /^[45]\. Old/
        menu_text += "  " + item.fg(240) + "\n"  # Grey for legacy
      else
        menu_text += "  #{item}\n"
      end
    end
  end

  @menu.say(menu_text)
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def update_border_colors
  # Toggle borders based on focus (like RTFM)
  # Only the focused pane gets a border
  if @focus == :menu
    @menu.border = true
    @content.border = false
  else
    @menu.border = false
    @content.border = true
  end
  # Refresh borders to show/hide them
  @menu.border_refresh
  @content.border_refresh
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def return_to_menu
  # Clear any displayed image first
  clear_terminal_image

  # Clear content (without changing focus)
  @content.say("")
  @content.ix = 0

  # Then return focus to menu
  if @focus != :menu
    @focus = :menu
    update_border_colors if @config[:show_borders]
  end

  draw_footer
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def draw_footer
  # Build footer with left-aligned help and right-aligned version
  if @focus == :content && @content.text && !@content.text.strip.empty?
    help = " [↑↓] Scroll | [e] Edit | [TAB] Back to Menu | [q] Quit"
  else
    help = " [↑↓] Navigate | [Enter] Select | [TAB] Switch Focus | [r] Refresh | [q] Quit"
  end
  version_text = "v#{@version} "
  
  # Calculate padding
  padding_len = @cols - help.length - version_text.length
  padding = " " * [padding_len, 0].max
  
  # Combine left help, padding, and right version
  footer_text = help + padding + version_text
  
  # Ensure it doesn't exceed terminal width
  if footer_text.length > @cols
    footer_text = footer_text[0...@cols]
  end
  
  @footer.say(footer_text)
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def show_footer_message(message, duration = 0)
  # Show a temporary footer message without it being immediately overwritten
  @footer.clear
  @footer.say(" #{message}".ljust(@cols))
  sleep(duration) if duration > 0
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def grey_out_content
  # Grey out existing content by converting it to grey color
  if @content.text && !@content.text.empty?
    # Add spacing if last prompt ended
    current_text = @content.text
    if @last_prompt_ended
      current_text = current_text + "\n"
      @last_prompt_ended = false
    end
    # Strip all existing ANSI codes and recolor in grey
    greyed = current_text.pure.fg(240)
    @content.say(greyed)
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def show_content(text)
  debug "show_content called with #{text.to_s.length} chars"
  debug "Color mode enabled: #{true}"

  # Switch focus to content pane when showing content
  if @focus != :content
    @focus = :content
    update_border_colors if @config[:show_borders]
    draw_footer  # Update footer for content pane help
  end

  # Reset prompt ended flag without adding newline
  if @last_prompt_ended
    @last_prompt_ended = false
  end

  # Don't convert ANSI codes - rcurses handles them natively
  # The .fg() methods produce proper ANSI codes that rcurses understands
  debug "Displaying text with ANSI codes intact"

  @content.say(text)
  @content.ix = 0
rescue => e
  debug "Error in show_content: #{e.message}"
  debug e.backtrace.join("\n") if e.backtrace
  raise
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def convert_ansi_to_rcurses(text)
  debug "convert_ansi_to_rcurses called with #{text.length} chars"
  
  # Check if text has ANSI codes
  if text =~ /\e\[/
    debug "Input contains ANSI codes"
  else
    debug "No ANSI codes in input"
  end
  
  # Map ANSI color codes to rcurses 256-color palette
  ansi_to_256 = {
    # Basic colors (30-37, 90-97 for bright)
    '30' => 0,    # Black
    '31' => 1,    # Red
    '32' => 2,    # Green
    '33' => 3,    # Yellow
    '34' => 4,    # Blue
    '35' => 5,    # Magenta
    '36' => 6,    # Cyan
    '37' => 7,    # White
    '90' => 8,    # Bright Black
    '91' => 9,    # Bright Red
    '92' => 10,   # Bright Green
    '93' => 11,   # Bright Yellow
    '94' => 12,   # Bright Blue
    '95' => 13,   # Bright Magenta
    '96' => 14,   # Bright Cyan
    '97' => 15,   # Bright White
    
    # Common bright combinations with 1;
    '1;30' => 8,   # Bright Black
    '1;31' => 9,   # Bright Red
    '1;32' => 10,  # Bright Green
    '1;33' => 11,  # Bright Yellow  
    '1;34' => 12,  # Bright Blue
    '1;35' => 13,  # Bright Magenta
    '1;36' => 14,  # Bright Cyan
    '1;37' => 15,  # Bright White
    '0;37' => 7,   # Normal White
    '0;34' => 4,   # Normal Blue
    
    # 256-color codes from CLI
    '38;5;202' => 202,  # Bright orange for weapons
    '38;5;229' => 229,  # Light cream for description
  }
  
  result = ""
  i = 0
  
  while i < text.length
    # Check for ANSI escape sequence
    if text[i] == "\e" && text[i+1] == "["
      # Extract the full ANSI sequence
      match = text[i..-1].match(/\A\e\[([0-9;]*?)m/)
      if match
        code = match[1]
        
        # Handle reset
        if code == "0" || code == ""
          # Don't add reset codes, rcurses handles this differently
          i += match[0].length
          next
        end
        
        # Convert to rcurses color
        if color = ansi_to_256[code]
          # Start a new colored section
          # Find the end of this colored text (next ANSI code or end of string)
          start_pos = i + match[0].length
          end_pos = start_pos
          
          while end_pos < text.length
            if text[end_pos] == "\e" && text[end_pos+1] == "["
              break
            end
            end_pos += 1
          end
          
          # Extract the text to color
          colored_text = text[start_pos...end_pos]
          
          # Apply rcurses color
          if code.start_with?('1;')
            # Bold + color
            result += colored_text.fg(color).b
          else
            result += colored_text.fg(color)
          end
          
          i = end_pos
          next
        end
        
        # Skip unhandled ANSI codes
        i += match[0].length
      else
        result += text[i]
        i += 1
      end
    else
      result += text[i]
      i += 1
    end
  end
  
  result
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def show_help
  content_width = @cols - 35

  # Show TUI version in header
  help_text = colorize_output("HELP - TUI Version 1.0.0", :header) + "\n"
  help_text += colorize_output("─" * content_width, :header) + "\n\n"

  # Add subtle coloring to help content
  help_lines = @help.split("\n")
  help_lines.each do |line|
    if line.start_with?("  ")
      # Indented lines - commands/items
      if line.include?(" - ")
        parts = line.split(" - ", 2)
        help_text += colorize_output(parts[0], :value) + " - " + parts[1].fg(240) + "\n"
      else
        help_text += colorize_output(line, :value) + "\n"
      end
    elsif line.end_with?(":")
      # Section headers
      help_text += colorize_output(line, :subheader) + "\n"
    else
      # Regular text
      help_text += line.fg(7) + "\n"
    end
  end

  help_text += "\n" + colorize_output("─" * content_width, :header) + "\n"
  help_text += colorize_output("NAVIGATION:", :subheader) + "\n"
  help_text += colorize_output("  →/RIGHT", :value) + "     - Activate menu item (when in menu)".fg(240) + "\n"
  help_text += colorize_output("  ←/LEFT", :value) + "      - Return to menu (when viewing content)".fg(240) + "\n"
  help_text += colorize_output("  TAB", :value) + "         - Switch between panes".fg(240) + "\n"
  help_text += "\n" + colorize_output("SCROLLING:", :subheader) + "\n"
  help_text += colorize_output("  j / DOWN", :value) + "    - Scroll down".fg(240) + "\n"
  help_text += colorize_output("  k / UP", :value) + "      - Scroll up".fg(240) + "\n"
  help_text += colorize_output("  SPACE/PgDn", :value) + "  - Page down".fg(240) + "\n"
  help_text += colorize_output("  b / PgUp", :value) + "    - Page up".fg(240) + "\n"
  help_text += colorize_output("  g / HOME", :value) + "    - Go to top".fg(240) + "\n"
  help_text += colorize_output("  G / END", :value) + "     - Go to bottom".fg(240) + "\n"
  help_text += colorize_output("  ESC/q", :value) + "       - Return to menu".fg(240) + "\n"
  
  show_content(help_text)
  
  # Handle scrolling in content pane
  loop do
    key = getchr
    break if key == "ESC" || key == "q" || key == "ESC" || key == "LEFT"
    
    case key
    when "j", "DOWN"
      @content.linedown
    when "k", "UP"  
      @content.lineup
    when " ", "PgDOWN"
      @content.pagedown
    when "b", "PgUP"
      @content.pageup
    when "g", "HOME"
      @content.ix = 0
      @content.refresh
    when "G", "END"
      # Go to end of content
      max_ix = [@content.text.lines.count - @content.h + 2, 0].max
      @content.ix = max_ix
      @content.refresh
    end
  end
  
  # Return focus to menu when done
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
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
    key = getchr
    break if key == "ESC" || key == "q" || key == "\r"
    
    case key
    when "j", "DOWN"  # Down
      popup.linedown
    when "k", "UP"  # Up
      popup.lineup
    when "PgDOWN"  # PgDn
      popup.pagedown
    when "PgUP"  # PgUp
      popup.pageup
    end
  end
  
  refresh_all
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def handle_menu_navigation
  debug "Waiting for key input..."
  begin
    key = getchr
    debug "Got key: #{key.inspect}"
  rescue => e
    debug "Error getting key: #{e.message}"
    debug e.backtrace.join("\n") if e.backtrace
    raise
  end
  
  case key
  when "j", "DOWN"  # Down arrow
    if @focus == :menu
      loop do
        @menu_index = (@menu_index + 1) % @menu_items.length
        break unless @menu_items[@menu_index].empty? || @menu_items[@menu_index].start_with?("──")
      end
      draw_menu
    else
      @content.linedown
    end

  when "k", "UP"  # Up arrow
    if @focus == :menu
      loop do
        @menu_index = (@menu_index - 1) % @menu_items.length
        break unless @menu_items[@menu_index].empty? || @menu_items[@menu_index].start_with?("──")
      end
      draw_menu
    else
      @content.lineup
    end
    
  when "\r", "ENTER"  # Enter
    result = execute_menu_item
    return false if result == false
    
  when "?"
    show_help
    
  when "q", "Q"
    return false
    
  # Shortcuts - NEW 3-TIER SYSTEM
  when "n", "N"
    generate_npc_new
  when "e", "E"
    # Only handle 'e' from menu focus for encounter generation
    # Content editing is handled within each view's own loop
    if @focus == :menu
      generate_encounter_new
    else
    end
  when "m", "M"
    generate_monster_new

  # WORLD BUILDING
  when "t", "T"
    generate_town_ui
  when "r", "R"
    generate_town_relations
  when "v", "V"
    show_latest_town_map
  when "w", "W"
    generate_weather_ui
  when "g", "G"
    generate_name_ui

  # AI TOOLS
  when "a", "A"
    generate_adventure_ai
  when "c", "C"
    describe_encounter_ai
  when "d", "D"
    describe_npc_ai
  when "i", "I"
    generate_npc_image
  when "s", "S"
    show_latest_npc_image

  # UTILITIES
  when "o", "O"
    roll_o6
  when "?"
    show_help

  # LEGACY SYSTEM
  when "1"
    generate_npc_old
  when "2"
    generate_encounter_old
  when "\t"  # Tab to switch focus
    @focus = (@focus == :menu) ? :content : :menu
    update_border_colors if @config[:show_borders]
    draw_footer  # Update footer to show context-aware help

  when "\f", "\x0C"  # Ctrl-L to refresh screen
    Rcurses.clear
    init_screen
    refresh_all

  when "RIGHT"  # Right arrow
    if @focus == :menu
      # When in menu, RIGHT activates the selected item (like Enter)
      result = execute_menu_item
      return false if result == false
    else
      # When in content pane, navigate right (if applicable)
      @content.right if @content.respond_to?(:right)
    end

  when "LEFT"  # Left arrow (not 'h' as that's used for help)
    if @focus == :content
      # When in content pane, LEFT returns to menu (like ESC)
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
      return_to_menu
    else
      # When in menu, navigate left (if applicable)
      @content.left if @content.respond_to?(:left)
    end
  end

  true
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def execute_menu_item
  item = @menu_items[@menu_index]
  debug "Executing menu item: #{item}"

  case item
  when /N\. Generate NPC/
    generate_npc_new
  when /E\. Generate Encounter/
    generate_encounter_new
  when /M\. Generate Monster/
    generate_monster_new
  # WORLD BUILDING
  when /T\. Town\/City/
    generate_town_ui
  when /R\. Town Relations/
    generate_town_relations
  when /V\. Show Town Relations Map/
    show_latest_town_map
  when /W\. Weather/
    generate_weather_ui
  when /G\. Name/
    generate_name_ui

  # AI TOOLS
  when /A\. Generate Adventure/
    generate_adventure_ai
  when /C\. Describe Encounter/
    describe_encounter_ai
  when /D\. Describe NPC/
    describe_npc_ai
  when /I\. Generate NPC Image/
    generate_npc_image
  when /S\. Show Latest NPC Image/
    show_latest_npc_image

  # UTILITIES
  when /O\. Roll Open Ended/
    roll_o6
    browse_saved_files
  when /\?\. Help/
    show_help

  # LEGACY SYSTEM
  when /1\. Old NPC/
    generate_npc_old
  when /2\. Old Encounter/
    generate_encounter_old

  when /Q\. Quit/
    return false
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# O6 - Open Ended d6 roll
def roll_o6
  # Roll 10 O6 dice with gradient coloring based on result
  results = []
  10.times do
    roll = oD6

    # Gradient coloring based on roll value
    # Range from -5 to 15+, using colors from red through yellow to green
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
      results << "#{roll_str} " + "(Critical!)".fg(46).b
    elsif roll <= -3
      results << "#{roll_str} " + "(Fumble!)".fg(196).b
    else
      results << "#{roll_str}"
    end
  end
  
  content_width = @cols - 35
  output = colorize_output("OPEN ENDED D6 ROLLS (O6)", :header) + "\n"
  output += colorize_output("─" * content_width, :header) + "\n\n"
  results.each { |r| output += "#{r}\n" }
  output += "\nPress any key to continue..."
  
  show_content(output)

  # Handle navigation like other views
  @footer.say(" [r] Re-roll | [y] Copy | [s] Save | [ESC/q] Back ".ljust(@cols))

  loop do
    key = getchr
    case key
    when "ESC", "q"
      # Restore menu selection
      @menu_index = saved_menu_index if defined?(saved_menu_index)
      return_to_menu
      break
    when "r"
      # Re-roll dice (generate new set)
      roll_o6
      break
    when "y"
      copy_to_clipboard(output)
      @footer.clear
      @footer.say(" Copied to clipboard! ".ljust(@cols))
      sleep(1)
      @footer.say(" [r] Re-roll | [y] Copy | [s] Save | [ESC/q] Back ".ljust(@cols))
    when "s"
      save_to_file(output, :dice)
    else
      # Any other key also returns to menu (for quick exit)
      @menu_index = saved_menu_index if defined?(saved_menu_index)
      return_to_menu
      break
    end
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end


# NPC GENERATION (NEW SYSTEM)
def generate_npc_new
  debug "Starting generate_npc_new"
  
  # Get inputs using the exact same logic as CLI
  ia = npc_input_new_tui
  if ia.nil?
    debug "User cancelled NPC generation"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  
  debug "Got inputs: #{ia.inspect}"
  
  begin
    # Generate NPC using exact same constructor as CLI
    debug "Creating NpcNew with inputs"
    npc = NpcNew.new(ia[0], ia[1], ia[2], ia[3], ia[4], ia[5], ia[6], ia[7], ia[8])
    debug "NPC created successfully"
    
    # Generate output using exact same format as CLI with colors
    # Pass the content pane width for proper formatting
    content_width = @cols - 35  # Same as content pane width
    output = npc_output_new(npc, "cli", content_width)
    debug "NPC output generated, length: #{output.length}, width: #{content_width}"
    debug "Contains ANSI codes: #{output.include?("\e[")}"
    
    # Display in content pane
    # Show content is handled inside handle_npc_view
    # show_content(output)

    # Handle view with clipboard support
    handle_npc_view(npc, output)
  rescue => e
    debug "Error generating NPC: #{e.message}"
    debug e.backtrace.join("\n") if e.backtrace
    show_content("Error generating NPC: #{e.message}\n\n#{e.backtrace.join("\n")}")
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def npc_input_new_tui
  debug "Starting npc_input_new_tui"
  inputs = []
  
  # Name input
  debug "Getting name input"
  header = colorize_output("NEW SYSTEM NPC GENERATION (3-Tier)", :header) + "\n"
  header += colorize_output("Enter NPC name", :label) + " (or ENTER for random): "
  show_content(header)
  name = get_text_input("")
  return nil if name == :cancelled
  inputs << (name || "")
  debug "Name input: #{name.inspect}"
  
  # Race selection
  races = [
    "Human", "Elf", "Half-elf", "Dwarf", "Goblin", "Lizard Man",
    "Centaur", "Ogre", "Troll", "Araxi", "Faerie"
  ]
  
  race_text = colorize_output("Select Race:", :header) + "\n"
  race_text += colorize_output(" 0", :dice) + ": " + colorize_output("Human", :value) + " (default)\n"
  races.each_with_index do |race, index|
    race_text += colorize_output((index + 1).to_s.rjust(2), :dice) + ": " + colorize_output(race, :value) + "\n"
  end
  race_text += "\n" + "Enter race number: "

  show_content(race_text)
  race_input = get_text_input("")
  return nil if race_input == :cancelled

  race = "Human"
  if race_input && race_input.match?(/^\d+$/)
    race_idx = race_input.to_i
    race = races[race_idx - 1] if race_idx > 0 && race_idx <= races.length
  end
  
  # Filter types based on race
  debug "Filtering types for race: #{race}"
  debug "$ChartypeNew defined: #{defined?($ChartypeNew)}"
  debug "$ChartypeNew class: #{$ChartypeNew.class if defined?($ChartypeNew)}"
  
  # Ensure $ChartypeNew is loaded
  if !defined?($ChartypeNew) || $ChartypeNew.nil?
    debug "Loading chartype_new.rb as $ChartypeNew not defined"
    load File.join($pgmdir, "includes/tables/chartype_new.rb")
    debug "After loading, $ChartypeNew defined: #{defined?($ChartypeNew)}"
  end
  
  if race == "Human"
    types = $ChartypeNew.keys.reject { |k| k.include?(":") }.sort
  else
    race_types = $ChartypeNew.keys.select { |k| k.start_with?("#{race}:") }
    generic_types = ["Commoner", "Farmer", "Merchant", "Thief", "Warrior"]
    types = race_types + generic_types.map { |t| "#{race}: #{t}" }
    types = types.select { |t| $ChartypeNew.key?(t) || generic_types.include?(t.split(": ").last) }
    types.uniq!
    types.sort!
  end
  debug "Found #{types.length} types for #{race}"
  
  # Type selection
  if types.empty?
    types = ["#{race}: Warrior", "#{race}: Commoner"]
  end
  
  # Type selection in columns
  type_text = colorize_output("Character Types", :header) + " (#{types.length} available):\n"
  type_text += colorize_output(" 0", :dice) + ": " + colorize_output("Random", :value) + "\n"

  # Display types in 2 columns if more than 20, or 3 columns if more than 40
  cols = types.length > 40 ? 3 : (types.length > 20 ? 2 : 1)
  col_width = 35

  types.each_with_index do |type_name, index|
    col = index % cols
    if col == 0
      type_text += colorize_output((index + 1).to_s.rjust(2), :dice) + ": "
      type_text += colorize_output(type_name[0..30], :value).ljust(col_width)
    elsif col == cols - 1
      type_text += colorize_output((index + 1).to_s.rjust(2), :dice) + ": "
      type_text += colorize_output(type_name[0..30], :value) + "\n"
    else
      type_text += colorize_output((index + 1).to_s.rjust(2), :dice) + ": "
      type_text += colorize_output(type_name[0..30], :value).ljust(col_width)
    end
  end

  # Add newline if we didn't end on a full row
  type_text += "\n" if types.length % cols != 0
  type_text += "\n"

  show_content(type_text)
  type_input = get_text_input("")
  return nil if type_input == :cancelled
  
  type = ""
  if type_input && type_input.to_i > 0 && type_input.to_i <= types.length
    type = types[type_input.to_i - 1]
  end
  
  # If race is not Human and type doesn't already include race, prepend it
  if race != "Human" && !type.include?(":")
    type = "#{race}: #{type}" if !type.empty?
  end
  
  inputs << type
  
  # Level selection
  level_text = colorize_output("Select character level:", :header) + "\n"
  level_text += colorize_output("0", :dice) + ": " + colorize_output("Random", :value) + "\n"
  level_text += colorize_output("1", :dice) + ": " + colorize_output("Novice", :value) + "\n"
  level_text += colorize_output("2", :dice) + ": " + colorize_output("Apprentice", :value) + "\n"
  level_text += colorize_output("3", :dice) + ": " + colorize_output("Journeyman", :value) + "\n"
  level_text += colorize_output("4", :dice) + ": " + colorize_output("Expert", :value) + "\n"
  level_text += colorize_output("5", :dice) + ": " + colorize_output("Master", :value) + "\n"
  level_text += colorize_output("6", :dice) + ": " + colorize_output("Grandmaster", :value) + "\n"
  level_text += "\n" + "Press number key:".fg(240)
  
  show_content(level_text)
  key = getchr
  return nil if key == "ESC"
  
  level = key =~ /[0-6]/ ? key.to_i : 0
  inputs << level
  
  # Area selection
  area_text = colorize_output("Select area of origin:", :header) + "\n"
  area_text += colorize_output("0", :dice) + ": " + colorize_output("Random", :value) + "\n"
  area_text += colorize_output("1", :dice) + ": " + colorize_output("Amaronir", :value) + "\n"
  area_text += colorize_output("2", :dice) + ": " + colorize_output("Merisir", :value) + "\n"
  area_text += colorize_output("3", :dice) + ": " + colorize_output("Calaronir", :value) + "\n"
  area_text += colorize_output("4", :dice) + ": " + colorize_output("Feronir", :value) + "\n"
  area_text += colorize_output("5", :dice) + ": " + colorize_output("Aleresir", :value) + "\n"
  area_text += colorize_output("6", :dice) + ": " + colorize_output("Rauinir", :value) + "\n"
  area_text += colorize_output("7", :dice) + ": " + colorize_output("Outskirts", :value) + "\n"
  area_text += colorize_output("8", :dice) + ": " + colorize_output("Other", :value) + "\n"
  area_text += "\n" + "Press number key:".fg(240)
  
  show_content(area_text)
  key = getchr
  return nil if key == "ESC"
  
  areas = ["", "Amaronir", "Merisir", "Calaronir", "Feronir", "Aleresir", "Rauinir", "Outskirts", "Other"]
  area = key =~ /[0-8]/ ? areas[key.to_i] : ""
  inputs << area
  
  # Sex selection
  sex_text = colorize_output("Select sex:", :header) + "\n"
  sex_text += colorize_output("0", :dice) + ": " + colorize_output("Random", :value) + "\n"
  sex_text += colorize_output("1", :dice) + ": " + colorize_output("Male", :value) + "\n"
  sex_text += colorize_output("2", :dice) + ": " + colorize_output("Female", :value) + "\n\n"
  sex_text += "Press number key:".fg(240)
  show_content(sex_text)
  key = getchr
  return nil if key == "ESC"
  
  sex = case key
        when "1" then "M"
        when "2" then "F"
        else ""
        end
  inputs << sex
  
  # Age input
  age_text = colorize_output("Enter age", :label) + " (or ENTER/0 for random): "
  show_content(age_text)
  age_input = get_text_input("")
  return nil if age_input == :cancelled
  age = age_input.to_i
  inputs << age
  
  # Physical attributes
  height_text = colorize_output("Enter height in cm", :label) + " (or ENTER/0 for random): "
  show_content(height_text)
  height_input = get_text_input("")
  return nil if height_input == :cancelled
  height = height_input.to_i
  inputs << height
  
  weight_text = colorize_output("Enter weight in kg", :label) + " (or ENTER/0 for random): "
  show_content(weight_text)
  weight_input = get_text_input("")
  return nil if weight_input == :cancelled
  weight = weight_input.to_i
  inputs << weight
  
  # Description
  desc_text = colorize_output("Enter description", :label) + " (optional, ENTER to skip): "
  show_content(desc_text)
  description = get_text_input("")
  return nil if description == :cancelled
  inputs << (description || "")
  
  inputs
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def get_text_input(prompt)
  debug "get_text_input called with prompt: #{prompt}"
  footer_text = colorize_output(" Type input", :label) + " | "
  footer_text += colorize_output("[ENTER]", :success) + " Confirm | "
  footer_text += colorize_output("[ESC]", :error) + " Cancel"
  @footer.say(footer_text.ljust(@cols))

  input = ""
  cursor_pos = 0
  @original_content = nil  # Reset for each new input
  @last_prompt_ended = false  # Track prompt endings

  # Don't add newline if prompt is empty, otherwise ensure we're on the same line
  if prompt && !prompt.empty?
    @content.say(@content.text + prompt)
  end

  loop do
    key = getchr

    case key
    when "ESC", "\e"
      @original_content = nil  # Clean up
      draw_footer
      return :cancelled
    when "ENTER", "\r"
      # Display the final input in cyan without underscore
      if !input.empty?
        final_display = @original_content + input.fg(51)  # Cyan for user input
        @content.say(final_display)
      end
      @original_content = nil  # Clean up
      @last_prompt_ended = true  # Mark that prompt ended
      draw_footer
      return input.empty? ? nil : input
    when "BACK", "\u007F"
      if cursor_pos > 0
        input = input[0...cursor_pos-1] + input[cursor_pos..-1]
        cursor_pos -= 1
      end
    when /^[[:print:]]$/
      input = input[0...cursor_pos] + key + input[cursor_pos..-1]
      cursor_pos += 1
    end

    # Update display - show input on same line as prompt
    current_text = @content.text

    # Store the original content if this is the first keystroke
    @original_content ||= current_text

    # Always use the original content as base and append current input
    display_text = @original_content + input + "_"
    @content.say(display_text)
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def handle_npc_view(npc, output)
  # Save menu state to preserve selection
  saved_menu_index = @menu_index

  # Save menu state to preserve selection
  saved_menu_index = @menu_index

  # Display the NPC content first
  show_content(output)

  # Set focus to content so key handling works properly
  @focus = :content

  # Save NPC to temp file for AI description
  save_dir = File.join($pgmdir || Dir.pwd, "saved")
  Dir.mkdir(save_dir) unless Dir.exist?(save_dir)

  # Clean output for saving
  clean_output = output.respond_to?(:pure) ? output.pure : output.gsub(/\e\[\d+(?:;\d+)*m/, '')

  # Save as temp_new.npc for AI description commands
  temp_file = File.join(save_dir, "temp_new.npc")
  File.write(temp_file, clean_output)

  # Also save as latest NPC
  latest_file = File.join(save_dir, "npc_latest.txt")
  File.write(latest_file, clean_output)

  # Save with character name if available
  if npc.respond_to?(:name) && npc.name && !npc.name.empty?
    # Clean name for filename (remove spaces and special characters)
    safe_name = npc.name.gsub(/[^A-Za-z0-9]/, '')
    if !safe_name.empty?
      name_file = File.join(save_dir, "#{safe_name}.npc")
      File.write(name_file, clean_output)
      @last_npc_name = safe_name  # Store for later use in descriptions and images
      debug "Saved NPC as #{safe_name}.npc"
    end
  end

  # Show instructions including clipboard copy
  @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))

  key = nil  # Initialize key variable
  loop do
    key = getchr

    case key
    when "ESC", "\e", "q", "LEFT"
      debug "NPC view: Exit key pressed, breaking loop"
      break
    when "j", "DOWN"
      debug "NPC view: Down key pressed"
      @content.linedown
    when "k", "UP"
      debug "NPC view: Up key pressed"
      @content.lineup
    when " ", "PgDOWN"
      debug "NPC view: Page down pressed"
      @content.pagedown
    when "b", "PgUP"
      debug "NPC view: Page up pressed"
      @content.pageup
    when "g", "HOME"
      debug "NPC view: Home key pressed"
      @content.ix = 0
      @content.refresh
    when "G", "END"
      debug "NPC view: End key pressed"
      max_ix = [@content.text.lines.count - @content.h + 2, 0].max
      @content.ix = max_ix
      @content.refresh
    when "Y", "y"
      debug "NPC view: Copy key pressed"
      # Copy output to clipboard
      copy_to_clipboard(output)
      # Show confirmation in footer briefly
      footer_text = " ✓ Output copied to clipboard! Press any key to continue... "
      @footer.bg = 28  # Dark green background for success
      @footer.say(footer_text.ljust(@cols))
      @footer.bg = 237  # Reset to medium grey
      sleep(1)
      @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
    when "e", "E"  # Ctrl+E
      # Simple external editor - just like it was working before
      clean_text = output.respond_to?(:pure) ? output.pure : output.gsub(/\e\[\d+(?:;\d+)*m/, '')
      edited_text = edit_in_external_editor(clean_text)

      # Show edited content if it was changed, otherwise show original with colors
      if edited_text && !edited_text.empty? && edited_text.strip != clean_text.strip
        # Re-apply colors to edited text using the same patterns as original
        # Skip coloring for now - just show edited text
        show_content(edited_text)
        output = edited_text  # Update with colored edited version
      else
        show_content(output)
      end

      # Always restore the footer
      @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
    when "r"
      debug "NPC view: Re-roll key pressed"
      # Re-roll with same parameters
      generate_npc_new
      break
    when "s"
      debug "NPC view: Save key pressed"
      # Save to file
      save_to_file(output, :npc)
    when "\f", "\x0C"  # Ctrl-L
      debug "NPC view: Refresh key pressed"
      # Refresh screen
      Rcurses.clear
      init_screen
      refresh_all
      show_content(output)
    else
      debug "NPC view: Unhandled key: '#{key}' (#{key.ord rescue 'special'})"
    end
  end

  debug "=== Exiting handle_npc_view loop, last key was: #{key} ==="
  # Restore menu selection and return focus to menu
  @menu_index = saved_menu_index
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def copy_to_clipboard(text)
  # Remove ANSI color codes if present
  clean_text = text.gsub(/\e\[[\d;]*m/, '')
  
  # Also remove rcurses color formatting if present
  # The .pure method strips rcurses formatting
  if clean_text.respond_to?(:pure)
    clean_text = clean_text.pure
  end
  
  # Try different clipboard commands based on platform
  if system("which pbcopy > /dev/null 2>&1")
    # macOS
    IO.popen('pbcopy', 'w') { |io| io.write(clean_text) }
  elsif system("which xclip > /dev/null 2>&1")
    # Linux with xclip
    IO.popen('xclip -selection clipboard', 'w') { |io| io.write(clean_text) }
  elsif system("which xsel > /dev/null 2>&1")
    # Linux with xsel
    IO.popen('xsel --clipboard --input', 'w') { |io| io.write(clean_text) }
  else
    # Fallback - save to temp file
    File.write('/tmp/amar_tui_clipboard.txt', clean_text)
    show_content(@content.text + "\n\nNote: Clipboard command not found. Output saved to /tmp/amar_tui_clipboard.txt")
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def edit_in_external_editor(text)
  
  # Remove ANSI codes before editing
  clean_text = text.gsub(/\e\[[\d;]*m/, '')

  # Also remove rcurses color formatting if present
  if clean_text.respond_to?(:pure)
    clean_text = clean_text.pure
  end

  # Create temporary file
  require 'tempfile'
  tmpfile = Tempfile.new(['amar_output', '.txt'])
  tmpfile.write(clean_text)
  tmpfile.close
  
  begin

    # Use simple internal editing instead of external editor

    # Show the text in an editable popup
    lines = clean_text.split("\n")
    edited_lines = edit_text_internally(lines)
    edited_text = edited_lines.join("\n")

    
    # Refresh all panes
    init_screen
    refresh_all

    # Return the edited content
    return edited_text
  ensure
    tmpfile.unlink if tmpfile
  end
rescue => e
  nil
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def edit_in_external_editor(text)
  # Simple external editor like RTFM does it
  require 'tempfile'

  tmpfile = Tempfile.new(['amar_edit', '.txt'])
  tmpfile.write(text)
  tmpfile.close

  begin
    # Save terminal state exactly like RTFM
    system("stty -g > /tmp/amar_stty_$$")

    # Clear and reset terminal for editor
    system('clear < /dev/tty > /dev/tty')

    # Launch editor
    editor = ENV.fetch('EDITOR', 'vi')
    system("#{editor} #{tmpfile.path}")

    # Restore terminal state exactly like RTFM
    system("stty $(cat /tmp/amar_stty_$$) < /dev/tty")
    system("rm -f /tmp/amar_stty_$$")

    # Reinitialize the TUI
    init_screen
    refresh_all

    # Read the edited content
    edited_content = File.read(tmpfile.path)
    return edited_content
  rescue => e
    # Cleanup on error
    system("rm -f /tmp/amar_stty_$$")
    init_screen rescue nil
    refresh_all rescue nil
    return text
  ensure
    tmpfile.unlink if tmpfile
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# ENCOUNTER GENERATION (NEW SYSTEM) 
def generate_encounter_new
  debug "Starting generate_encounter_new"
  
  # Get inputs using same logic as CLI
  ia = enc_input_new_tui
  if ia.nil?
    debug "User cancelled encounter generation"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  
  debug "Got encounter inputs: #{ia.inspect}"
  
  begin
    # Generate encounter using exact same constructor as CLI
    # ia[0] = encounter type, ia[1] = number, ia[2] = terrain type, ia[3] = level modifier
    debug "Creating EncNew with inputs"
    enc = EncNew.new(ia[0], ia[1], ia[2], ia[3])
    debug "Encounter created successfully"
    
    # Generate output using exact same format as CLI
    # Pass the content pane width for proper formatting
    content_width = @cols - 35  # Same as content pane width
    output = enc_output_new(enc, "cli", content_width)
    
    # Display in content pane
    show_content(output)
    
    # Handle view with clipboard support
    handle_encounter_view(enc, output)
  rescue => e
    debug "Error generating encounter: #{e.message}"
    debug e.backtrace.join("\n") if e.backtrace
    show_content("Error generating encounter: #{e.message}\n\n#{e.backtrace.join("\n")}")
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def enc_input_new_tui
  debug "Starting enc_input_new_tui"
  
  # Initialize defaults
  $Day = 1 if $Day.nil?
  $Terrain = 1 if $Terrain.nil?
  $Level = 0 if $Level.nil?
  
  # Get night/day
  # Night/day selection
  time_text = colorize_output("NEW SYSTEM ENCOUNTER GENERATION", :header) + "\n"
  time_text += colorize_output("Select time:", :header) + "\n"
  time_text += colorize_output("0", :dice) + ": " + colorize_output("Night", :value) + "\n"
  time_text += colorize_output("1", :dice) + ": " + colorize_output("Day", :value) + " (default)\n\n"
  time_text += "Press number key:".fg(240)
  show_content(time_text)
  key = getchr
  return nil if key == "ESC"
  
  $Day = key == "0" ? 0 : 1
  debug "Day/Night: #{$Day}"
  
  # Get terrain
  terrain_text = colorize_output("Select terrain type:", :header) + "\n"
  terrain_text += colorize_output("0", :dice) + ": " + colorize_output("City", :value) + "\n"
  terrain_text += colorize_output("1", :dice) + ": " + colorize_output("Rural", :value) + "\n"
  terrain_text += colorize_output("2", :dice) + ": " + colorize_output("Road", :value) + "\n"
  terrain_text += colorize_output("3", :dice) + ": " + colorize_output("Plains", :value) + "\n"
  terrain_text += colorize_output("4", :dice) + ": " + colorize_output("Hills", :value) + "\n"
  terrain_text += colorize_output("5", :dice) + ": " + colorize_output("Mountains", :value) + "\n"
  terrain_text += colorize_output("6", :dice) + ": " + colorize_output("Woods", :value) + "\n"
  terrain_text += colorize_output("7", :dice) + ": " + colorize_output("Wilderness", :value) + "\n\n"
  terrain_text += "Press number key:".fg(240)
  
  show_content(terrain_text)
  key = getchr
  return nil if key == "ESC"
  
  $Terrain = key =~ /[0-7]/ ? key.to_i : 1
  $Terraintype = $Terrain + (8 * $Day)
  debug "Terrain: #{$Terrain}, Terraintype: #{$Terraintype}"
  
  # Get level modifier
  level_text = colorize_output("Enter level modifier (+/-)", :header) + "\n"
  level_text += colorize_output("0-9", :dice) + ": Positive modifier\n"
  level_text += colorize_output("-", :dice) + " then number: Negative modifier\n"
  level_text += colorize_output("ENTER", :dice) + ": No modifier (0)\n\n"
  show_content(level_text)
  level_input = get_text_input("")
  return nil if level_input == :cancelled
  
  $Level = level_input.to_i if level_input
  debug "Level modifier: #{$Level}"
  
  # Race selection for humanoid encounters
  races = [
    "Human", "Elf", "Half-elf", "Dwarf", "Goblin", "Lizard Man",
    "Centaur", "Ogre", "Troll", "Araxi", "Faerie"
  ]
  
  race_text = colorize_output("Select race (for humanoid encounters):", :header) + "\n"
  race_text += colorize_output(" 0", :dice) + ": " + colorize_output("Random", :value) + " (default)\n"
  races.each_with_index do |race, index|
    race_text += colorize_output((index + 1).to_s.rjust(2), :dice) + ": " + colorize_output(race, :value) + "\n"
  end
  race_text += "\n" + "Enter race number: "

  show_content(race_text)
  race_input = get_text_input("")
  return nil if race_input == :cancelled

  race = ""
  if race_input && race_input.match?(/^\d+$/)
    race_idx = race_input.to_i
    race = races[race_idx - 1] if race_idx > 0 && race_idx <= races.length
  end
  debug "Selected race: #{race.empty? ? 'Random' : race}"
  
  # Get specific encounter or random
  encounter = ""
  enc_number = 0
  
  # Load encounter tables if not loaded
  unless defined?($Encounters)
    debug "Loading encounters table"
    load File.join($pgmdir, "includes/tables/encounters.rb")
  end
  
  # Return the encounter settings
  [encounter, enc_number, $Terraintype, $Level]
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def handle_encounter_view(enc, output)
  # Save menu state to preserve selection
  saved_menu_index = @menu_index

  # Save menu state to preserve selection
  saved_menu_index = @menu_index

  # Save encounter to temp file for AI description
  save_dir = File.join($pgmdir || Dir.pwd, "saved")
  Dir.mkdir(save_dir) unless Dir.exist?(save_dir)

  # Save clean version
  clean_output = output.respond_to?(:pure) ? output.pure : output.gsub(/\e\[\d+(?:;\d+)*m/, '')
  temp_file = File.join(save_dir, "temp_new.enc")
  File.write(temp_file, clean_output)

  # Also save as encounter_new.npc for AI description commands
  enc_file = File.join(save_dir, "encounter_new.npc")
  File.write(enc_file, clean_output)

  # Save as latest encounter too
  latest_file = File.join(save_dir, "encounter_latest.txt")
  File.write(latest_file, clean_output)

  # Show instructions including clipboard copy and selection
  if enc.npcs && enc.npcs.length > 0
    @footer.say(" [1-9] View NPC | [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [ESC/q] Back ".ljust(@cols))
  else
    @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
  end

  loop do
    key = getchr

    case key
    when "ESC", "\e", "q", "LEFT"
      break
    when /[1-9]/
      # View individual NPC from encounter
      if enc.npcs && enc.npcs.length > 0
        npc_idx = key.to_i - 1
        if npc_idx < enc.npcs.length
          # Get the NPC
          selected_npc = enc.get_npc(npc_idx)

          # Generate NPC output
          npc_out = npc_output_new(selected_npc, "cli", @cols - 35)

          # Show NPC
          show_content(npc_out)

          # Handle NPC view (with nested navigation)
          handle_npc_view(selected_npc, npc_out)

          # Return to encounter view
          show_content(output)
          if enc.npcs && enc.npcs.length > 0
            @footer.say(" [1-9] View NPC | [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [ESC/q] Back ".ljust(@cols))
          else
            @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
          end
        end
      end
    when "j", "DOWN"
      @content.linedown
    when "k", "UP"
      @content.lineup
    when " ", "PgDOWN"
      @content.pagedown
    when "b", "PgUP"
      @content.pageup
    when "g", "HOME"
      @content.ix = 0
      @content.refresh
    when "G", "END"
      max_ix = [@content.text.lines.count - @content.h + 2, 0].max
      @content.ix = max_ix
      @content.refresh
    when "Y", "y"
      # Copy output to clipboard
      copy_to_clipboard(output)
      # Show confirmation in footer briefly
      footer_text = " ✓ Output copied to clipboard! Press any key to continue... "
      @footer.bg = 28  # Dark green background for success
      @footer.say(footer_text.ljust(@cols))
      @footer.bg = 237  # Reset to medium grey
      sleep(1)
      @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
    when "e", "E"
      debug "View: 'e' key matched, calling edit_in_external_editor"
      # Edit in editor - strip ANSI codes first
      clean_text = output.respond_to?(:pure) ? output.pure : output.gsub(/\e\[\d+(?:;\d+)*m/, '')
      debug "View: Cleaned text length = #{clean_text.length}"
      edited_text = edit_in_external_editor(clean_text)
      debug "View: edit_in_external_editor returned, edited_text = #{edited_text ? 'content' : 'nil'}"
      if edited_text
        show_content(edited_text)
      else
        show_content(output)
      end
    when "r"
      # Re-roll with same parameters
      generate_encounter_new
      break
    when "s"
      # Save to file
      save_to_file(output, :encounter)
    when "\f", "\x0C"  # Ctrl-L
      # Refresh screen
      Rcurses.clear
      init_screen
      refresh_all
      show_content(output)
    end
  end

  # Return focus to menu when done viewing
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def format_npc_new(npc)
  content_width = @cols - 35
  output = "NPC: #{npc.name} (#{npc.sex}, #{npc.age})\n"
  output += "Type: #{npc.type} | Level: #{npc.level}\n"
  output += "─" * content_width + "\n\n"
  
  # Stats
  output += "CHARACTERISTICS:\n"
  # Format SIZE for display
  size_display = npc.SIZE % 1 == 0.5 ? "#{npc.SIZE.floor}½" : npc.SIZE.to_s
  output += "  SIZE: #{size_display}\n"
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

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def format_encounter_new(enc)
  content_width = @cols - 35
  output = "ENCOUNTER: #{enc.enc_attitude}\n"
  output += "#{enc.summary}\n"
  output += "─" * content_width + "\n\n"
  
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

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def handle_content_view(object, type)
  # Save menu state to preserve selection
  saved_menu_index = @menu_index

  # Show scrolling instructions in footer
  @footer.say(" [j/↓] Down | [k/↑] Up | [SPACE] PgDn | [b] PgUp | [g] Top | [G] Bottom | [ESC/q] Back ".ljust(@cols))
  
  loop do
    key = getchr
    
    case key
    when "ESC", "\e", "q", "LEFT"  # ESC or q to go back
      break
    when "j", "DOWN"  # Scroll down
      @content.linedown
    when "k", "UP"  # Scroll up
      @content.lineup
    when " ", "PgDOWN"  # Page down
      @content.pagedown
    when "b", "PgUP"  # Page up
      @content.pageup
    when "g", "HOME"  # Go to top
      @content.ix = 0
      @content.refresh
    when "G", "END"  # Go to bottom
      max_ix = [@content.text.lines.count - @content.h + 2, 0].max
      @content.ix = max_ix
      @content.refresh
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
      edited_text = edit_in_external_editor(@content.text)
      show_content(edited_text)  # Update the content with edited text
    end
  end
  
  # Restore normal footer
  draw_footer
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def save_to_file(object, type)
  timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
  filename = "saved/#{type}_#{timestamp}.txt"
  
  FileUtils.mkdir_p("saved")
  File.write(filename, @content.text)
  
  show_popup("SAVED", "Saved to: #{filename}\n\nPress any key to continue")
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# This function is duplicate - removing it to use the proper one above

# COLOR FORMATTING HELPERS
def colorize_output(text, type = :default)
  # Always apply colors
  case type
  when :header
    text.fg(14).b  # Bright cyan bold
  when :subheader
    text.fg(11).b  # Bright yellow bold
  when :label
    text.fg(13)  # Bright magenta (no bold)
  when :value
    text.fg(7)     # White
  when :success
    text.fg(10)    # Bright green (for Off values)
  when :warning
    text.fg(11)    # Bright yellow (for Def values)
  when :error
    text.fg(9)     # Bright red
  when :dice
    text.fg(202)   # Orange (for dice/skill values)
  when :name
    text.fg(15).b  # Bright white bold
  else
    text
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# DICE ROLLER
def roll_dice_ui
  show_popup("DICE ROLLER", "Enter dice notation (e.g., 3d6+2):\n\nOr press ESC to cancel")
  
  # Simple dice roller implementation
  dice_input = ""
  loop do
    key = getchr
    break if key == "ESC"
    
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

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
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

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# MONSTER GENERATION (NEW SYSTEM)
def generate_monster_new
  debug "Starting generate_monster_new"
  
  # Load monster stats if not loaded
  unless defined?($MonsterStats)
    debug "Loading monster_stats_new.rb"
    load File.join($pgmdir, "includes/tables/monster_stats_new.rb")
  end
  
  # Get monster type selection
  monster_list = $MonsterStats.keys.reject { |k| k == "default" }.sort
  
  monster_text = colorize_output("NEW SYSTEM MONSTER GENERATION", :header) + "\n"
  monster_text += colorize_output("Select monster type:", :header) + "\n"
  monster_text += " " + colorize_output("0", :dice) + ": " + colorize_output("Random", :value) + "\n"
  
  # Display in columns for better readability with proper coloring
  monster_list.each_with_index do |monster, index|
    num = (index + 1).to_s.rjust(2)
    monster_text += colorize_output(num, :dice) + ": " + colorize_output(monster.capitalize.ljust(18), :value) + "  "
    monster_text += "\n" if (index + 1) % 3 == 0
  end
  monster_text += "\n" if monster_list.length % 3 != 0
  monster_text += "\n" + "Press number or ENTER for random:".fg(240)
  
  show_content(monster_text)
  monster_input = get_text_input("")
  if monster_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  
  # Select monster
  monster_type = ""
  if monster_input && monster_input.to_i > 0 && monster_input.to_i <= monster_list.length
    monster_type = monster_list[monster_input.to_i - 1]
  else
    monster_type = monster_list.sample
  end
  
  debug "Selected monster: #{monster_type}"
  
  # Get level
  level_text = colorize_output("Select monster level:", :header) + "\n"
  level_text += colorize_output("0", :dice) + ": " + colorize_output("Random", :value) + "\n"
  level_text += colorize_output("1-6", :dice) + ": " + colorize_output("Specific level", :value) + "\n\n"
  level_text += "Press number key:".fg(240)
  show_content(level_text)
  key = getchr
  if key == "ESC" || key == "ESC"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  
  level = key =~ /[1-6]/ ? key.to_i : rand(1..6)
  debug "Monster level: #{level}"
  
  begin
    debug "Creating MonsterNew with type: #{monster_type}, level: #{level}"
    monster = MonsterNew.new(monster_type, level)
    debug "Monster created successfully"
    
    # Format output
    output = format_monster_new(monster)
    show_content(output)
    
    # Handle view with clipboard support
    handle_monster_view(monster, output)
  rescue => e
    debug "Error generating monster: #{e.message}"
    debug e.backtrace.join("\n") if e.backtrace
    show_content("Error generating monster: #{e.message}\n\n#{e.backtrace.join("\n")}")
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def handle_monster_view(monster, output)
  # Save menu state to preserve selection
  saved_menu_index = @menu_index

  @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))

  loop do
    key = getchr

    case key
    when "ESC", "\e", "q", "LEFT"
      break
    when "j", "DOWN"
      @content.linedown
    when "k", "UP"
      @content.lineup
    when " ", "PgDOWN"
      @content.pagedown
    when "b", "PgUP"
      @content.pageup
    when "Y", "y"
      copy_to_clipboard(output)
      footer_text = " ✓ Output copied to clipboard! Press any key to continue... "
      @footer.bg = 28  # Dark green background for success
      @footer.say(footer_text.ljust(@cols))
      @footer.bg = 237  # Reset to medium grey
      sleep(1)
      @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
    when "e", "E"
      debug "View: 'e' key matched, calling edit_in_external_editor"
      # Edit in editor - strip ANSI codes first
      clean_text = output.respond_to?(:pure) ? output.pure : output.gsub(/\e\[\d+(?:;\d+)*m/, '')
      debug "View: Cleaned text length = #{clean_text.length}"
      edited_text = edit_in_external_editor(clean_text)
      debug "View: edit_in_external_editor returned, edited_text = #{edited_text ? 'content' : 'nil'}"
      if edited_text
        show_content(edited_text)
      else
        show_content(output)
      end
    when "r"
      generate_monster_new
      break
    when "s"
      # Save to file
      save_to_file(output, :monster)
    when "\f", "\x0C"  # Ctrl-L
      # Refresh screen
      Rcurses.clear
      init_screen
      refresh_all
      show_content(output)
    end
  end

  # Return focus to menu when done viewing
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def format_monster_new(monster)
  output = ""
  content_width = @cols - 35  # Same as content pane width

  if true
    output += colorize_output("#{monster.name}", :success) + colorize_output(" (#{monster.type}, Level #{monster.level})", :value) + "\n"
    output += colorize_output("─" * content_width, :header) + "\n\n"

    # Physical stats - ensure integers
    # Use the SIZE calculated by the class (includes half-sizes)
    size_val = monster.SIZE
    # Format SIZE for display (3.5 becomes "3½")
    size_display = size_val % 1 == 0.5 ? "#{size_val.floor}½" : size_val.to_s
    bp_val = monster.BP.is_a?(Float) ? monster.BP.round : monster.BP
    db_val = monster.DB.is_a?(Float) ? monster.DB.round : monster.DB
    md_val = monster.MD.is_a?(Float) ? monster.MD.round : monster.MD

    output += colorize_output("SIZE: ", :label) + colorize_output(size_display, :value)
    output += colorize_output(" (#{monster.weight.round}kg)", :value)
    output += "  " + colorize_output("BP: ", :label) + colorize_output(bp_val.to_s, :value)
    output += "  " + colorize_output("DB: ", :label) + colorize_output(db_val.to_s, :value)
    output += "  " + colorize_output("MD: ", :label) + colorize_output(md_val.to_s, :value) + "\n\n"
    
    # Special abilities
    if monster.special_abilities && !monster.special_abilities.empty?
      output += colorize_output("SPECIAL ABILITIES:", :subheader) + "\n"
      output += "  " + colorize_output(monster.special_abilities, :success) + "\n\n"
    end
    
    # Weapons/Attacks
    output += colorize_output("WEAPONS/ATTACKS:", :subheader) + "\n"
    output += "  " + colorize_output("Attack".ljust(20), :label)
    output += colorize_output("Skill".rjust(6), :label)
    output += colorize_output("Init".rjust(6), :label)
    output += colorize_output("Off".rjust(5), :label)
    output += colorize_output("Def".rjust(5), :label)
    output += colorize_output("Damage".rjust(8), :label) + "\n"
    monster.tiers["BODY"]["Melee Combat"]["skills"].each do |skill, value|
      next if value == 0
      total = monster.get_skill_total("BODY", "Melee Combat", skill)

      # Calculate weapon stats based on skill type and monster DB
      db = monster.DB.is_a?(Float) ? monster.DB.round : monster.DB
      if skill.downcase.include?("unarmed") || skill.downcase.include?("claw") || skill.downcase.include?("bite")
        init = 3 + (monster.level / 2)
        off = total + 2
        def_val = total
        damage = -4 + db  # Unarmed base damage is -4, plus DB
        attack_name = skill.capitalize
      else
        # Other weapons
        init = 4
        off = total + 1
        def_val = total + 1
        damage = db + 2
        attack_name = skill.capitalize
      end

      # Color code damage based on value
      damage_color = case damage
                     when -10..-5 then 88   # Dark red for very weak
                     when -4..-2 then 124   # Red for weak
                     when -1..0 then 166    # Orange for minimal
                     when 1..2 then 226     # Yellow for light
                     when 3..4 then 154     # Yellow-green for moderate
                     when 5..6 then 118     # Light green for good
                     when 7..9 then 82      # Green for strong
                     when 10..14 then 46    # Bright green for very strong
                     else 40                # Brighter green for extreme
                     end

      output += "  " + colorize_output(attack_name.ljust(20), :value)
      output += colorize_output(total.to_s.rjust(6), :dice)
      output += colorize_output(init.to_s.rjust(6), :value)
      output += colorize_output(off.to_s.rjust(5), :success)
      output += colorize_output(def_val.to_s.rjust(5), :warning)
      output += damage.to_s.rjust(8).fg(damage_color) + "\n"
    end

    # Skills
    output += "\n" + colorize_output("SKILLS:", :subheader) + "\n"

    # Athletics skills
    athletics_skills = []
    if monster.tiers["BODY"]["Athletics"] && monster.tiers["BODY"]["Athletics"]["skills"]
      monster.tiers["BODY"]["Athletics"]["skills"].each do |skill, value|
        next if value == 0
        total = monster.get_skill_total("BODY", "Athletics", skill)
        athletics_skills << "#{skill}: #{total}"
      end
    end

    # Awareness skills
    awareness_skills = []
    if monster.tiers["MIND"]["Awareness"] && monster.tiers["MIND"]["Awareness"]["skills"]
      monster.tiers["MIND"]["Awareness"]["skills"].each do |skill, value|
        next if value == 0
        total = monster.get_skill_total("MIND", "Awareness", skill)
        awareness_skills << "#{skill}: #{total}"
      end
    end

    # Display skills in two columns
    max_lines = [athletics_skills.length, awareness_skills.length].max
    max_lines.times do |i|
      line = "  "
      if athletics_skills[i]
        line += colorize_output(athletics_skills[i].ljust(30), :value)
      else
        line += " " * 30
      end
      if awareness_skills[i]
        line += colorize_output(awareness_skills[i], :value)
      end
      output += line + "\n"
    end

    # Spells if any
    if monster.spells && !monster.spells.empty?
      output += "\n" + colorize_output("SPELLS:", :subheader) + "\n"
      monster.spells.each do |spell|
        output += "  " + colorize_output(spell['name'], :name) + colorize_output(" (#{spell['domain']})", :label) + "\n"
      end
    end
  else
    # Non-colored version
    output += "#{monster.name} (#{monster.type}, Level #{monster.level})\n"
    output += "─" * content_width + "\n\n"

    # Physical stats - ensure integers
    # Use the SIZE calculated by the class (includes half-sizes)
    size_val = monster.SIZE
    # Format SIZE for display (3.5 becomes "3½")
    size_display = size_val % 1 == 0.5 ? "#{size_val.floor}½" : size_val.to_s
    bp_val = monster.BP.is_a?(Float) ? monster.BP.round : monster.BP
    db_val = monster.DB.is_a?(Float) ? monster.DB.round : monster.DB
    md_val = monster.MD.is_a?(Float) ? monster.MD.round : monster.MD

    output += "SIZE: #{size_display}  BP: #{bp_val}  DB: #{db_val}  MD: #{md_val}\n"
    output += "Weight: #{monster.weight.round} kg\n\n"
    
    # Special abilities
    if monster.special_abilities && !monster.special_abilities.empty?
      output += "SPECIAL ABILITIES:\n"
      output += "  #{monster.special_abilities}\n\n"
    end
    
    # Weapons/Attacks
    output += "WEAPONS/ATTACKS:\n"
    output += "Attack          Skill  Init  Off  Def  Damage\n"
    monster.tiers["BODY"]["Melee Combat"]["skills"].each do |skill, value|
      next if value == 0
      total = monster.get_skill_total("BODY", "Melee Combat", skill)

      # Calculate weapon stats
      db = monster.DB.is_a?(Float) ? monster.DB.round : monster.DB
      if skill.downcase.include?("unarmed") || skill.downcase.include?("claw") || skill.downcase.include?("bite")
        init = 3 + (monster.level / 2)
        off = total + 2
        def_val = total
        damage = db + 1
        attack_name = skill.capitalize
      else
        init = 4
        off = total + 1
        def_val = total + 1
        damage = db + 2
        attack_name = skill.capitalize
      end

      output += "#{attack_name} #{total.to_s.rjust(5)}  #{init.to_s.rjust(4)}  #{off.to_s.rjust(3)}  #{def_val.to_s.rjust(3)}  #{damage.to_s.rjust(6)}\n"
    end

    # Skills
    output += "\nSKILLS:\n"

    # Athletics skills
    athletics_skills = []
    if monster.tiers["BODY"]["Athletics"] && monster.tiers["BODY"]["Athletics"]["skills"]
      monster.tiers["BODY"]["Athletics"]["skills"].each do |skill, value|
        next if value == 0
        total = monster.get_skill_total("BODY", "Athletics", skill)
        athletics_skills << "#{skill}: #{total}"
      end
    end

    # Awareness skills
    awareness_skills = []
    if monster.tiers["MIND"]["Awareness"] && monster.tiers["MIND"]["Awareness"]["skills"]
      monster.tiers["MIND"]["Awareness"]["skills"].each do |skill, value|
        next if value == 0
        total = monster.get_skill_total("MIND", "Awareness", skill)
        awareness_skills << "#{skill}: #{total}"
      end
    end

    # Display skills in two columns
    max_lines = [athletics_skills.length, awareness_skills.length].max
    max_lines.times do |i|
      line = "  "
      line += athletics_skills[i] ? athletics_skills[i].ljust(30) : " " * 30
      line += awareness_skills[i] || ""
      output += line + "\n"
    end

    # Spells if any
    if monster.spells && !monster.spells.empty?
      output += "\nSPELLS:\n"
      monster.spells.each do |spell|
        output += "  #{spell['name']} (#{spell['domain']})\n"
      end
    end
  end
  
  output
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# NPC GENERATION (OLD SYSTEM)
def generate_npc_old
  # Get inputs for old system NPC
  header = colorize_output("OLD SYSTEM NPC GENERATION", :header) + "\n\n"
  header += "Enter name (or ENTER for random): "
  show_content(header)
  name = get_text_input("")
  return if name == :cancelled
  name = "" if name.nil?

  # Type selection
  type_text = colorize_output("Select type (0 for random):", :header) + "\n"
  types = [""] + $Chartype.keys.sort
  types.each_with_index do |t, i|
    next if i == 0
    type_text += colorize_output(i.to_s.rjust(2), :dice) + ": " + colorize_output(t, :value).ljust(25)
    type_text += "\n" if i % 3 == 0
  end
  show_content(type_text + "\n\nEnter number: ")
  type_input = get_text_input("")
  return if type_input == :cancelled
  type = type_input.to_i > 0 ? types[type_input.to_i] : ""

  # Level
  level_text = colorize_output("Level:", :header) + "\n"
  level_text += "1: Untrained  2: Trained some  3: Trained  4: Well trained  5: Master\n\n"
  show_content(level_text + "Enter level (0-5): ")
  level_input = get_text_input("")
  return if level_input == :cancelled
  level = level_input.to_i

  # Area
  area_text = colorize_output("Area:", :header) + "\n"
  area_text += "1: Amaronir  2: Merisir  3: Calaronir  4: Feronir\n"
  area_text += "5: Alerisir  6: Rauinir  7: Outskirts\n\n"
  show_content(area_text + "Enter area (0 for random): ")
  area_input = get_text_input("")
  return if area_input == :cancelled
  area = case area_input.to_i
         when 1 then "Amaronir"
         when 2 then "Merisir"
         when 3 then "Calaronir"
         when 4 then "Feronir"
         when 5 then "Alerisir"
         when 6 then "Rauinir"
         when 7 then "Outskirts"
         else ""
         end

  # Sex
  sex_text = "\n" + colorize_output("Sex (M/F or ENTER for random):", :header) + " "
  show_content(sex_text)
  sex_input = get_text_input("")
  return if sex_input == :cancelled
  sex = sex_input.upcase if sex_input && ["M", "F"].include?(sex_input.upcase)
  sex ||= ""

  # Age, height, weight
  show_content(colorize_output("Age (0 for random):", :header) + " ")
  age = get_text_input("").to_i rescue 0
  return if age == :cancelled

  show_content(colorize_output("Height in cm (0 for random):", :header) + " ")
  height = get_text_input("").to_i rescue 0
  return if height == :cancelled

  show_content(colorize_output("Weight in kg (0 for random):", :header) + " ")
  weight = get_text_input("").to_i rescue 0
  return if weight == :cancelled

  # Description
  show_content(colorize_output("Description (ENTER for none):", :header) + " ")
  description = get_text_input("") || ""
  return if description == :cancelled

  begin
    # Generate using the old Npc class
    npc = Npc.new(name, type, level, area, sex, age, height, weight, description)

    # Format output
    content_width = @cols - 35
    output = colorize_output("OLD SYSTEM NPC", :header) + "\n"
    output += colorize_output("─" * content_width, :header) + "\n\n"

    # Basic info
    output += colorize_output("Name: ", :label) + colorize_output(npc.name, :name) + "\n"
    output += colorize_output("Type: ", :label) + colorize_output(npc.type, :value) + "\n"
    output += colorize_output("Level: ", :label) + colorize_output(npc.level.to_s, :dice) + "\n"
    output += colorize_output("Area: ", :label) + colorize_output(npc.area, :value) + "\n"
    output += colorize_output("Sex: ", :label) + colorize_output(npc.sex, :value) + "\n"
    output += colorize_output("Age: ", :label) + colorize_output(npc.age.to_s, :value) + "\n"
    output += colorize_output("Height: ", :label) + colorize_output("#{npc.height} cm", :value) + "\n"
    output += colorize_output("Weight: ", :label) + colorize_output("#{npc.weight} kg", :value) + "\n"

    if npc.description && !npc.description.empty?
      output += colorize_output("Description: ", :label) + colorize_output(npc.description, :value) + "\n"
    end

    output += "\n"
    output += colorize_output("Physical Stats:", :subheader) + "\n"
    # Format SIZE for display
    size_display = npc.SIZE % 1 == 0.5 ? "#{npc.SIZE.floor}½" : npc.SIZE.to_s
    output += colorize_output("SIZE: ", :label) + colorize_output(size_display, :value)
    output += "  " + colorize_output("BP: ", :label) + colorize_output(npc.BP.to_s, :value)
    output += "  " + colorize_output("DB: ", :label) + colorize_output(npc.DB.to_s, :value)
    output += "  " + colorize_output("MD: ", :label) + colorize_output(npc.MD.to_s, :value)
    output += "  " + colorize_output("ENC: ", :label) + colorize_output(npc.ENC.to_s, :value) + "\n\n"

    # Add more details as needed from the NPC object

    show_content(output)
    
    # Simple navigation for old system output
    loop do
      key = getchr
      case key
      when "ESC", "q"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
        return_to_menu
        break
      when "j", "DOWN"
        @content.linedown
      when "k", "UP"
        @content.lineup
      when "PgDOWN"
        @content.pagedown
      when "PgUP"
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

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# ENCOUNTER GENERATION (OLD SYSTEM)
def generate_encounter_old
  # Get inputs for old system encounter
  header = colorize_output("OLD SYSTEM ENCOUNTER GENERATION", :header) + "\n\n"

  # Day/Night
  day_text = colorize_output("Time:", :header) + "\n"
  day_text += colorize_output("0", :dice) + ": Night\n"
  day_text += colorize_output("1", :dice) + ": Day\n\n"
  show_content(header + day_text + "Enter choice (default=1): ")
  day_input = get_text_input("")
  return if day_input == :cancelled
  $Day = day_input == "0" ? 0 : 1

  # Terrain
  terrain_text = colorize_output("Terrain:", :header) + "\n"
  terrain_text += "0: City  1: Rural  2: Road  3: Plains\n"
  terrain_text += "4: Hills  5: Mountains  6: Woods  7: Wilderness\n\n"
  show_content(terrain_text + "Enter terrain (default=1): ")
  terrain_input = get_text_input("")
  return if terrain_input == :cancelled
  $Terrain = terrain_input.to_i if (0..7).include?(terrain_input.to_i)
  $Terrain ||= 1
  $Terraintype = $Terrain + (8 * $Day)

  # Level modifier
  show_content(colorize_output("Level modifier (+/-, default=0):", :header) + " ")
  level_input = get_text_input("")
  return if level_input == :cancelled
  $Level = level_input.to_i

  begin
    # Generate using the old Enc class with proper parameters
    # First parameter is encounter spec (empty for random), second is number
    enc = Enc.new("", 0)

    # Format output
    content_width = @cols - 35
    output = colorize_output("OLD SYSTEM ENCOUNTER", :header) + "\n"
    output += colorize_output("─" * content_width, :header) + "\n\n"

    # Display encounter details
    if enc.encounter && !enc.encounter.empty?
      # enc.encounter is an array of hashes, get the first one's string
      enc_str = enc.encounter[0]["string"] rescue "Unknown"
      output += colorize_output("Encounter: ", :label) + colorize_output(enc_str, :success) + "\n"
    else
      output += colorize_output("No encounter", :value) + "\n"
    end

    if enc.enc_number && enc.enc_number > 0
      output += colorize_output("Number: ", :label) + colorize_output(enc.enc_number.to_s, :dice) + "\n"
    end

    if enc.enc_attitude
      output += colorize_output("Attitude: ", :label) + colorize_output(enc.enc_attitude, :value) + "\n"
    end

    output += "\n"
    output += "Note: This is a basic random encounter using the old system.\n"
    output += "For more detailed encounters, use the New System generator.\n"

    show_content(output)
    
    # Simple navigation
    loop do
      key = getchr
      case key
      when "ESC", "q"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
        return_to_menu
        break
      when "j", "DOWN"
        @content.linedown
      when "k", "UP"
        @content.lineup
      when "PgDOWN"
        @content.pagedown
      when "PgUP"
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

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# WEATHER GENERATOR
def generate_weather_ui
  debug "Starting generate_weather_ui"

  # Initialize weather globals if needed (5 = Normal)
  $weather_n = 5 if $weather_n.nil?
  $wind_dir_n = 0 if $wind_dir_n.nil?
  $wind_str_n = 0 if $wind_str_n.nil?
  $mn = 0 if $mn.nil?

  if $mn != 0
    $mn = (($mn + 1) % 14)
    $mn = 1 if $mn == 0
  end

  # Get Month - Always use colors for weather UI
  mstring = "WEATHER GENERATOR".fg(14).b + "\n"
  mstring += "Select month:".fg(14).b + "\n"
  7.times do |i|
    mstring += i.to_s.rjust(2).fg(202) + ": "  # Orange for numbers
    mstring += $Month[i].fg(7).ljust(30)  # White for month names
    mstring += (i+7).to_s.rjust(2).fg(202) + ": "
    mstring += $Month[i+7].fg(7) + "\n"
  end
  mstring += "\n" + "Enter month".fg(13) + " (default=#{$mn}): "

  show_content(mstring)
  month_input = get_text_input("")
  if month_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  
  month = month_input.to_i
  month = $mn if month_input.nil? || month_input.empty?
  month = 0 if month < 0
  month = 13 if month > 13
  $mn = month
  
  # Get weather conditions - Always use colors
  weather_text = "\n" + "Select weather conditions:".fg(14).b + "\n\n"
  weather_text += " 1".fg(202) + ": " + "Arctic".fg(51) + "\n"  # Cyan for cold
  weather_text += " 2".fg(202) + ": " + "Winter".fg(195) + "\n"  # Light blue
  weather_text += " 3".fg(202) + ": " + "Cold".fg(117) + "\n"  # Light cyan
  weather_text += " 4".fg(202) + ": " + "Cool".fg(159) + "\n"  # Light blue
  weather_text += " 5".fg(202) + ": " + "Normal".fg(7) + " (default)\n"  # White
  weather_text += " 6".fg(202) + ": " + "Warm".fg(214) + "\n"  # Orange
  weather_text += " 7".fg(202) + ": " + "Hot".fg(196) + "\n"  # Red
  weather_text += " 8".fg(202) + ": " + "Very hot".fg(160) + "\n"  # Dark red
  weather_text += " 9".fg(202) + ": " + "Extreme heat".fg(124) + "\n"  # Very dark red
  weather_text += "\n" + "Enter weather condition".fg(13) + " (default=#{$weather_n}): "

  show_content(weather_text)
  weather_input = get_text_input("")
  if weather_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  
  weather = weather_input.to_i
  weather = $weather_n if weather_input.nil? || weather_input.empty?
  weather = 5 if weather < 1  # Default to 5 (Normal) if invalid
  weather = 9 if weather > 9
  
  # Get wind - Always use colors
  wind_text = "\n" + "Select wind conditions:".fg(14).b + "\n\n"
  wind_text += "Wind Direction:".fg(11).b + "\n"
  wind_text += " 0".fg(202) + ": N   " + "1".fg(202) + ": NE   "
  wind_text += "2".fg(202) + ": E   " + "3".fg(202) + ": SE\n"
  wind_text += " 4".fg(202) + ": S   " + "5".fg(202) + ": SW   "
  wind_text += "6".fg(202) + ": W   " + "7".fg(202) + ": NW\n\n"
  wind_text += "Wind Strength:".fg(11).b + "\n"
  wind_text += " 0".fg(202) + ": Calm   " + "8".fg(202) + ": Light   "
  wind_text += "16".fg(202) + ": Medium   " + "24".fg(202) + ": Strong\n\n"
  wind_text += "Enter combined value".fg(13) + " (0-31, default=#{$wind_dir_n + $wind_str_n * 8}): "

  show_content(wind_text)
  wind_input = get_text_input("")
  if wind_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  
  wind = wind_input.to_i
  wind = $wind_dir_n + $wind_str_n * 8 if wind_input.nil? || wind_input.empty?
  wind = 0 if wind < 0
  wind = 31 if wind > 31
  
  begin
    # Generate weather month
    w = Weather_month.new(month, weather, wind)
    $weather_n = w.day[27].weather
    $wind_dir_n = w.day[27].wind_dir
    $wind_str_n = w.day[27].wind_str
    
    # Create colorized weather output with symbols
    output = ""
    # Authentic Amar god colors for each month
    month_color = case month
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
                  else 226          # Default yellow
                  end
    output += "\n" + "☀ WEATHER FOR #{$Month[month].upcase} ☀".fg(month_color).b + "\n"
    output += ("─" * 60).fg(240) + "\n\n"  # Grey divider
    
    # Weather symbols
    weather_symbols = {
      "Arctic" => "❄",  # Snowflake
      "Winter" => "❄",
      "Cold" => "☁",    # Cloud
      "Cool" => "☁",
      "Normal" => "⛅",  # Sun behind cloud
      "Warm" => "☀",    # Sun
      "Hot" => "☀",
      "Storm" => "⛈",   # Thunder cloud
      "Rain" => "☂"     # Umbrella
    }
    
    # Moon symbols
    moon_symbols = {
      0 => "●",   # New moon (filled circle)
      7 => "◐",   # First quarter
      14 => "○",  # Full moon (empty circle)
      21 => "◑"   # Last quarter
    }
    
    # Display each day with colors
    w.day.each_with_index do |d, i|
      # Build line piece by piece to preserve colors
      line = ""
      
      # Day number - always use color for weather
      line += (i+1).to_s.rjust(2).fg(13)  # Magenta for day numbers
      line += ": "
      
      # Weather description with enhanced gradient coloring
      weather_text = $Weather[d.weather]
      weather_colored = case weather_text
                       when /blizzard/i then weather_text.fg(231).b       # Bold white for blizzard
                       when /snow storm/i then weather_text.fg(255).b      # Bold white for snow storm
                       when /heavy snow/i then weather_text.fg(195)        # Light blue-white for heavy snow
                       when /snow/i then weather_text.fg(255)              # White for snow
                       when /hail/i then weather_text.fg(253)              # Light gray for hail
                       when /thunder/i then weather_text.fg(93).b          # Bold purple for thunder
                       when /lightning/i then weather_text.fg(226).b       # Bold yellow for lightning
                       when /storm/i then weather_text.fg(202).b           # Bold orange for storm
                       when /heavy rain/i then weather_text.fg(21)         # Deep blue for heavy rain
                       when /rain/i then weather_text.fg(33)               # Blue for rain
                       when /drizzle/i then weather_text.fg(111)           # Light blue for drizzle
                       when /sleet/i then weather_text.fg(109)             # Blue-gray for sleet
                       when /fog/i then weather_text.fg(248)               # Gray for fog
                       when /mist/i then weather_text.fg(251)              # Light gray for mist
                       when /overcast/i then weather_text.fg(243)          # Dark gray for overcast
                       when /gray/i then weather_text.fg(245)              # Medium-dark gray
                       when /partly cloudy/i then weather_text.fg(250)     # Light gray for partly cloudy
                       when /mainly cloudy/i then weather_text.fg(247)     # Medium gray
                       when /cloudy/i then weather_text.fg(247)            # Medium gray for cloudy
                       when /mainly clear/i then weather_text.fg(226)      # Yellow for mainly clear
                       when /clear|sunny/i then weather_text.fg(226)       # Yellow for sunny/clear
                       when /lucid/i then weather_text.fg(252)             # Very light gray
                       when /warm/i then weather_text.fg(214)              # Orange for warm
                       when /hot/i then weather_text.fg(196)               # Red for hot
                       when /scorching/i then weather_text.fg(160).b       # Bold dark red for scorching
                       when /freezing/i then weather_text.fg(45).b         # Bold cyan for freezing
                       when /cold/i then weather_text.fg(51)               # Cyan for cold
                       when /cool/i then weather_text.fg(117)              # Light cyan for cool
                       when /breeze/i then weather_text.fg(159)            # Light blue for breeze
                       else weather_text.fg(255)                           # Default white
                       end
      line += weather_colored
      
      # Add weather symbol with color matching the weather
      symbol_added = false
      if weather_text =~ /blizzard|snow storm/i
        line += " " + "❄".fg(231).b
        symbol_added = true
      elsif weather_text =~ /snow/i
        line += " " + "❄".fg(255)
        symbol_added = true
      elsif weather_text =~ /thunder|lightning|storm/i
        line += " " + "⛈".fg(226).b
        symbol_added = true
      elsif weather_text =~ /rain/i
        line += " " + "☂".fg(33)
        symbol_added = true
      elsif weather_text =~ /cloudy|overcast/i
        line += " " + "☁".fg(247)
        symbol_added = true
      elsif weather_text =~ /sunny|clear/i
        line += " " + "☀".fg(226)
        symbol_added = true
      elsif weather_text =~ /hot|warm/i
        line += " " + "☀".fg(214)
        symbol_added = true
      elsif weather_text =~ /cold|freezing/i
        line += " " + "❄".fg(51)
        symbol_added = true
      end
      
      line += ". "
      
      # Wind with gradient coloring based on strength
      wind_color = case d.wind_str
                   when 0 then 250       # Light gray for calm
                   when 1..7 then 159    # Light blue for light
                   when 8..15 then 75    # Medium blue for moderate
                   when 16..23 then 33   # Darker blue for strong
                   when 24..30 then 129  # Purple for very strong
                   else 201              # Magenta for extreme
                   end

      # Add wind strength with icon
      wind_icon = case d.wind_str
                  when 0 then "○"      # Circle for calm
                  when 1..7 then "◡"   # Light curve
                  when 8..15 then "∼"  # Wave
                  when 16..23 then "≈" # Double wave
                  else "≋"             # Triple wave for extreme
                  end

      wind_text = "#{wind_icon} #{$Wind_str[d.wind_str]}"
      line += ". " + wind_text.fg(wind_color)

      if d.wind_str != 0
        # Direction arrows
        dir_arrow = case d.wind_dir
                    when 0 then "↑"  # N
                    when 1 then "↗"  # NE
                    when 2 then "→"  # E
                    when 3 then "↘"  # SE
                    when 4 then "↓"  # S
                    when 5 then "↙"  # SW
                    when 6 then "←"  # W
                    when 7 then "↖"  # NW
                    end
        dir_text = " #{dir_arrow} #{$Wind_dir[d.wind_dir]}"
        line += dir_text.fg(wind_color)
      end
      
      # Calculate remaining space for special/moon (use pure for length calculation)
      current_length = line.pure.length
      
      # Add special days with magical colors
      if d.special && !d.special.empty?
        padding = [60 - current_length, 1].max
        line += " " * padding
        # Use different colors for different special days
        special_text = "★ #{d.special}"
        special_colored = case d.special
                         when /Anashina/i then special_text.fg(41)       # Anashina green
                         when /Gwendyll/i then special_text.fg(213)      # Gwendyll magenta
                         when /Fionella/i then special_text.fg(163)      # MacGillan color
                         when /Elaari/i then special_text.fg(204)        # Juba color
                         when /Ish Nakil/i then special_text.fg(204)     # Juba color
                         when /Fenimaal/i then special_text.fg(163)      # MacGillan color
                         when /Ikalio/i then special_text.fg(248)        # Taroc color
                         when /Alesia/i then special_text.fg(230)        # Elesi color
                         when /Juba/i then special_text.fg(204)          # Juba color
                         when /new year/i then special_text.fg(239)      # Mestronorpha color
                         when /festival/i then special_text.fg(172)      # Maleko color
                         when /harvest/i then special_text.fg(130)       # Man Peggon color
                         when /solstice/i then special_text.fg(248)      # Taroc color
                         when /equinox/i then special_text.fg(172)       # Maleko color
                         else special_text.fg(229)                       # Light yellow default
                         end
        line += special_colored
        current_length = line.pure.length
      end
      
      # Add moon phases with magical colors
      if month != 0 && moon_symbols.key?(i)
        moon_text = case i
                   when 0 then "#{moon_symbols[0]} New"
                   when 7 then "#{moon_symbols[7]} Waxing"
                   when 14 then "#{moon_symbols[14]} Full"
                   when 21 then "#{moon_symbols[21]} Waning"
                   end
        padding = [78 - current_length, 1].max
        line += " " * padding
        # Moon phase colors
        moon_colored = case i
                      when 0 then moon_text.fg(238)    # Dark gray for new moon
                      when 7 then moon_text.fg(252)    # Light gray for waxing
                      when 14 then moon_text.fg(229).b # Bold light yellow for full
                      when 21 then moon_text.fg(245)   # Medium gray for waning
                      end
        line += moon_colored
      end
      
      output += line + "\n"
      
      # Add subtle week separator
      if ((i+1) % 7) == 0 && i < 27
        output += "\n"
      end
    end
    
    show_content(output)
    
    # Navigation
    @footer.clear
    @footer.say(" [j/↓] Down | [k/↑] Up | [p] Generate PDF | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
    
    loop do
      key = getchr
      case key
      when "ESC", "q"
        # Restore menu selection
        @menu_index = saved_menu_index if defined?(saved_menu_index)
        return_to_menu
        break
      when "j", "DOWN"
        @content.linedown
      when "k", "UP"
        @content.lineup
      when " ", "PgDOWN"
        @content.pagedown
      when "PgUP"
        @content.pageup
      when "p", "P"
        # Generate PDF immediately from current weather data (like old CLI)
        begin
          # Generate LaTeX content using current weather month
          # Weather_month expects (month, weather, wind) where wind combines dir+str
          combined_wind = $wind_dir_n + ($wind_str_n * 8)
          w = Weather_month.new($mn, $weather_n, combined_wind)

          # Load weather2latex if not already loaded
          weather2latex_file = File.join($pgmdir, "includes", "weather2latex.rb")
          if File.exist?(weather2latex_file)
            load weather2latex_file
          end

          # Capture output to prevent terminal bypass
          original_stdout = $stdout
          captured_output = StringIO.new
          $stdout = captured_output

          latex_content = weather_out_latex(w, "tui")  # Use "tui" mode to prevent terminal output

          # Restore stdout
          $stdout = original_stdout

          # Generate PDF using pdflatex
          save_dir = File.join($pgmdir, "saved")
          Dir.mkdir(save_dir) unless Dir.exist?(save_dir)

          pdf_result = ""
          Dir.chdir(save_dir) do
            # Run pdflatex and capture output
            pdf_output_capture = `pdflatex -interaction=nonstopmode weather.tex 2>&1`
            if File.exist?("weather.pdf")
              pdf_result = "SUCCESS: PDF created"
            else
              pdf_result = "ERROR: PDF generation failed"
            end
          end

          # Show PDF generation status in TUI
          status_output = "\n" + "PDF GENERATION COMPLETE".fg(10).b + "\n\n"
          status_output += "Month: ".fg(14) + "#{$Month[$mn]}".fg(month_color).b + "\n"
          status_output += "Status: ".fg(14) + pdf_result.fg(pdf_result.include?("SUCCESS") ? 46 : 196) + "\n"
          status_output += "File: ".fg(14) + "saved/weather.pdf".fg(226) + "\n\n"
          if pdf_result.include?("SUCCESS")
            status_output += "PDF ready for printing and use at your gaming table!".fg(46) + "\n\n"
          else
            status_output += "Check that pdflatex is installed.".fg(196) + "\n\n"
          end
          status_output += "Press any key to return to weather view".fg(240)

          show_content(status_output)
          getchr  # Wait for keypress

          # Return to weather view
          show_content(output)
          @footer.say(" [j/↓] Down | [k/↑] Up | [p] Generate PDF | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
        rescue => e
          error_output = "PDF Generation Error".fg(196).b + "\n\n"
          error_output += "#{e.message}\n\n"
          error_output += "Press any key to continue".fg(240)
          show_content(error_output)
          getchr
          show_content(output)
          @footer.say(" [j/↓] Down | [k/↑] Up | [p] Generate PDF | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
        end
      when "y"
        copy_to_clipboard(output)
        @footer.clear
        @footer.say(" Copied to clipboard! ".ljust(@cols))
        sleep(1)
        @footer.clear
        @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
      when "e"
        # Edit in editor - strip ANSI codes first
        clean_text = output.respond_to?(:pure) ? output.pure : output.gsub(/\e\[\d+(?:;\d+)*m/, '')
        edit_in_external_editor(clean_text)
        show_content(output)
      when "p", "P"
        # Generate PDF from current weather
        generate_weather_pdf
        # Return to weather view after PDF generation
        show_content(output)
        @footer.say(" [j/↓] Down | [k/↑] Up | [p] Generate PDF | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
      when "r"
        # Re-roll with same parameters (don't ask for inputs again)
        begin
          # Use current weather settings
          w = Weather_month.new($mn, $weather_n, $wind_dir_n, $wind_str_n)

          # Generate new output with same parameters
          output = ""
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
                        else 226          # Default yellow
                        end
          output += "\n" + "☀ WEATHER FOR #{$Month[$mn].upcase} ☀".fg(month_color).b + "\n"
          output += ("─" * 60).fg(240) + "\n\n"  # Grey divider

          # Regenerate weather display with same settings
          # (This will create new random weather patterns but with same base conditions)
          # Add the weather display code here to regenerate the calendar

          show_content(output + "\n\nRe-rolling weather with same settings...\n\nWeather regenerated!")
          @footer.say(" [j/↓] Down | [k/↑] Up | [p] Generate PDF | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
        rescue => e
          show_content("Error re-rolling weather: #{e.message}")
        end
      when "s"
        save_to_file(output, :weather)
      end
    end

    # Return focus to menu when done
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
  rescue => e
    show_content("Error generating weather: #{e.message}")
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# WEATHER PDF GENERATION
def generate_weather_pdf
  debug "Starting generate_weather_pdf"

  # First generate weather for the month
  show_content("Generating weather for PDF...\n\nPlease select month and weather conditions...")

  # Initialize weather globals if needed (5 = Normal)
  $weather_n = 5 if $weather_n.nil?
  $wind_dir_n = 0 if $wind_dir_n.nil?
  $wind_str_n = 0 if $wind_str_n.nil?
  $mn = 0 if $mn.nil?
  if $mn != 0
    $mn = (($mn + 1) % 14)
    $mn = 1 if $mn == 0
  end

  # Get Month
  mstring = "WEATHER PDF GENERATOR".fg(14).b + "\n"
  mstring += "Select month for PDF:".fg(14).b + "\n"
  7.times do |i|
    mstring += i.to_s.rjust(2).fg(202) + ": "
    mstring += $Month[i].fg(7).ljust(30)
    mstring += (i+7).to_s.rjust(2).fg(202) + ": "
    mstring += $Month[i+7].fg(7) + "\n"
  end
  mstring += "\n" + "Month (0-13 or Enter=#{$mn}): ".fg(14)

  show_content(mstring)
  @focus = :content

  # Get month selection
  month_input = ""
  loop do
    key = getchr
    case key
    when "ESC", "q"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
      return_to_menu
      return
    when "ENTER", "\r"
      break
    when "0".."9"
      month_input += key
      if month_input.to_i > 13 || (month_input.length == 2 && month_input.to_i > 13)
        month_input = ""
        next
      end
      show_content(mstring + month_input)
      if month_input.length == 2 || month_input.to_i > 1
        break
      end
    when "BACK"
      month_input = month_input[0..-2] if month_input.length > 0
      show_content(mstring + month_input)
    end
  end

  $mn = month_input.to_i unless month_input.empty?

  # Get Weather condition
  wstring = "WEATHER PDF GENERATOR".fg(14).b + "\n"
  wstring += "Month: #{$Month[$mn]}".fg(45).b + "\n"
  wstring += "Select weather condition:".fg(14).b + "\n"
  ["1: Snow storm", "2: Heavy snow", "3: Light snow", "4: Hail",
   "5: Normal", "6: Sunny", "7: Hot", "8: Sweltering"].each do |w|
    wstring += w.fg(7) + "\n"
  end
  wstring += "\n" + "Weather (1-8 or Enter=#{$weather_n}): ".fg(14)

  show_content(wstring)

  weather_input = ""
  loop do
    key = getchr
    case key
    when "ESC", "q"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
      return_to_menu
      return
    when "ENTER", "\r"
      break
    when "1".."8"
      weather_input = key
      break
    end
  end

  $weather_n = weather_input.to_i unless weather_input.empty?

  # Generate the weather
  show_content("Generating weather month...\n\nPlease wait...")
  w = Month.new($mn, $weather_n, $wind_dir_n, $wind_str_n)

  # Load weather2latex if not already loaded
  weather2latex_file = File.join($pgmdir, "includes", "weather2latex.rb")
  if File.exist?(weather2latex_file)
    load weather2latex_file
  else
    show_content("Error: weather2latex.rb not found")
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Generate LaTeX and PDF
  show_content("Creating PDF...\n\nThis will generate a printable weather calendar PDF.")

  begin
    # Generate LaTeX content
    latex_content = weather_out_latex(w, "cli")

    # Write LaTeX file
    latex_file = "saved/weather.tex"
    File.write(latex_file, latex_content, perm: 0644)

    # Generate PDF using pdflatex
    Dir.chdir("saved") do
      # Run pdflatex twice for proper rendering
      system("pdflatex -interaction=nonstopmode weather.tex >/dev/null 2>&1")
      system("pdflatex -interaction=nonstopmode weather.tex >/dev/null 2>&1")
    end

    pdf_file = "saved/weather.pdf"
    if File.exist?(pdf_file)
      output = "WEATHER PDF GENERATED".fg(10).b + "\n\n"
      output += "Month: ".fg(14) + "#{$Month[$mn]}".fg(45).b + "\n"
      output += "Weather: ".fg(14) + ["", "Snow storm", "Heavy snow", "Light snow", "Hail",
                                       "Normal", "Sunny", "Hot", "Sweltering"][$weather_n].fg(45) + "\n\n"
      output += "PDF saved to: ".fg(14) + pdf_file.fg(10) + "\n\n"
      output += "The PDF contains a printable calendar with:\n".fg(7)
      output += "• Daily weather conditions\n"
      output += "• Temperature and wind information\n"
      output += "• Moon phases\n"
      output += "• Special divine days (if any)\n\n"
      output += "You can print this PDF for use at your gaming table.\n\n".fg(7)
      output += "Press [o] to open PDF, [ESC/q] to return".fg(14)

      show_content(output)

      # Wait for user input
      loop do
        key = getchr
        case key
        when "ESC", "q"
          break
        when "o", "O"
          # Try to open PDF with default viewer
          if system("which xdg-open >/dev/null 2>&1")
            system("xdg-open #{pdf_file} >/dev/null 2>&1 &")
          elsif system("which open >/dev/null 2>&1")
            system("open #{pdf_file} >/dev/null 2>&1 &")
          else
            show_content(output + "\n\nCannot open PDF automatically. Please open manually:\n#{File.expand_path(pdf_file)}".fg(11))
          end
        end
      end
    else
      show_content("Error: PDF generation failed.\n\nMake sure pdflatex is installed:\n  sudo apt-get install texlive-latex-base")
    end

    # Clean up temporary LaTeX files
    ["saved/weather.tex", "saved/weather.aux", "saved/weather.log"].each do |f|
      File.delete(f) if File.exist?(f)
    end

  rescue => e
    show_content("Error generating weather PDF: #{e.message}")
  end

  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# TOWN GENERATOR
def generate_town_ui
  debug "Starting generate_town_ui"
  
  # Get Town name
  header = colorize_output("TOWN/CITY GENERATOR", :header) + "\n"
  header += colorize_output("Enter Village/Town/City name", :label) + " (or ENTER for random): "
  show_content(header)
  town_name = get_text_input("")
  if town_name == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  town_name = "" if town_name.nil?
  
  # Get Town size
  prompt_text = "\n" + colorize_output("Enter number of houses", :label)
  prompt_text += " (1-1000, default=1): "
  show_content(prompt_text)
  size_input = get_text_input("")
  if size_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  town_size = size_input.to_i
  town_size = 1 if town_size < 1
  
  # Get Town variations
  var_text = colorize_output("Select race variation:", :header) + "\n"
  var_text += colorize_output("0", :dice) + ": " + colorize_output("Only humans", :value) + " (default)\n"
  var_text += colorize_output("1", :dice) + ": " + colorize_output("Few non-humans", :value) + "\n"
  var_text += colorize_output("2", :dice) + ": " + colorize_output("Several non-humans", :value) + "\n"
  var_text += colorize_output("3", :dice) + ": " + colorize_output("Crazy place", :value) + "\n"
  var_text += colorize_output("4", :dice) + ": " + colorize_output("Only Dwarves", :value) + "\n"
  var_text += colorize_output("5", :dice) + ": " + colorize_output("Only Elves", :value) + "\n"
  var_text += colorize_output("6", :dice) + ": " + colorize_output("Only Lizardfolk", :value) + "\n"
  show_content(var_text)
  var_input = get_text_input("")
  if var_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end
  town_var = var_input.to_i
  town_var = 0 if town_var < 0
  town_var = 6 if town_var > 6
  
  # Initialize town variable
  town = nil

  begin
    # Create pipes for IPC
    progress_read, progress_write = IO.pipe
    result_read, result_write = IO.pipe

    # Fork a process for generation
    pid = fork do
      # Child process - generate town
      progress_read.close
      result_read.close

      # Clear any TUI-related globals to prevent interference
      $tui_content = nil
      $tui_footer = nil
      $tui_menu = nil
      @content = nil
      @footer = nil
      @menu = nil

      # Set global progress pipe
      $progress_pipe = progress_write

      # Redirect stdout to capture output
      captured = StringIO.new
      original_stdout = $stdout
      original_stderr = $stderr
      $stdout = captured
      $stderr = captured

      # Generate the town
      begin
        town = Town.new(town_name, town_size, town_var)
      rescue => e
        # Log any errors to progress pipe
        $progress_pipe.puts "ERROR: #{e.message}" rescue nil
        raise
      end

      # Restore stdout
      $stdout = original_stdout
      $stderr = original_stderr

      # Close progress pipe
      progress_write.close

      # Send town data through result pipe
      Marshal.dump(town, result_write)
      result_write.close
      exit(0)
    end

    # Parent process - monitor progress
    progress_write.close
    result_write.close
    houses_created = 0
    start_time = Time.now

    # Show initial progress display
    output = colorize_output("GENERATING TOWN", :header) + "\n"
    output += colorize_output("─" * (@cols - 35), :header) + "\n\n"
    output += colorize_output("Total houses: ", :label) + colorize_output(town_size.to_s, :value) + "\n"
    output += colorize_output("Progress: ", :label) + colorize_output("0 / #{town_size}", :warning) + "\n\n"
    output += "[" + "-" * 30 + "] 0%\n\n"
    output += colorize_output("Starting generation...", :label) + "\n"
    @content.say(output)

    # Make progress pipe non-blocking
    progress_read.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)

    # Monitor child process
    while Process.waitpid(pid, Process::WNOHANG).nil?
      # Try to read progress updates (non-blocking)
      begin
        # Read available data without blocking
        data = progress_read.read_nonblock(1024)
        data.each_line do |line|
          line = line.strip
          if line.start_with?("ERROR:")
            # Error from child process
            @content.say("Error: #{line.sub('ERROR: ', '')}")
            Process.kill("TERM", pid) rescue nil
            break
          else
            num = line.to_i
            if num > 0 && num > houses_created
              houses_created = num
            end
          end
        end
      rescue IO::WaitReadable, Errno::EAGAIN
        # No data available, that's OK
      rescue EOFError
        # Pipe closed, child is done
        break
      end

      # Calculate elapsed time
      elapsed = Time.now - start_time

      # Update display
      output = colorize_output("GENERATING TOWN", :header) + "\n"
      output += colorize_output("─" * (@cols - 35), :header) + "\n\n"
      output += colorize_output("Total houses: ", :label) + colorize_output(town_size.to_s, :value) + "\n"
      output += colorize_output("Progress: ", :label) + colorize_output("#{houses_created} / #{town_size}", :success)

      # Add progress bar (ensure filled is never negative)
      progress_pct = town_size > 0 ? (houses_created.to_f / town_size * 100).to_i : 0
      bar_width = 30
      filled = town_size > 0 ? (bar_width * houses_created / town_size).to_i : 0
      filled = [filled, 0].max  # Ensure never negative
      filled = [filled, bar_width].min  # Ensure never exceeds bar width

      output += "\n\n["
      output += colorize_output("█" * filled, :success) if filled > 0
      output += "-" * (bar_width - filled)
      output += "] #{progress_pct}%\n\n"

      output += colorize_output("Time elapsed: ", :label) + "#{elapsed.to_i}s\n"

      @content.say(output)

      sleep 0.05
    end

    # Close progress pipe
    progress_read.close

    # Read the town from result pipe
    town = Marshal.load(result_read)
    result_read.close
  rescue => e
    # Make sure stdout is restored even on error
    $stdout = original_stdout if defined?(original_stdout)
    $stderr = original_stderr if defined?(original_stderr)
    @content.say("Error: #{e.message}\n\n#{e.backtrace.first(5).join("\n")}")
    return
  end

  # Check if town was generated
  if town.nil?
    show_content("Error: Failed to generate town. Please try again.\n\nPress any key to continue...")
    getchr
    return
  end

  # Suppress ALL file saving output
  begin
    save_capture = StringIO.new
    original_editor = $editor if defined?($editor)
    temp_stdout = $stdout
    temp_stderr = $stderr
    $stdout = save_capture
    $stderr = save_capture
    $editor = "/bin/true"  # Use /bin/true to avoid editor output

    # Ensure saved directory exists
    saved_dir = File.join($pgmdir || Dir.pwd, "saved")
    FileUtils.mkdir_p(saved_dir) unless Dir.exist?(saved_dir)

    # Call town_output to save files (ALL output suppressed)
    town_output(town, "tui")

    $stdout = temp_stdout
    $stderr = temp_stderr
    $editor = original_editor if original_editor
  rescue => e
    # Ensure streams are restored
    $stdout = temp_stdout if defined?(temp_stdout)
    $stderr = temp_stderr if defined?(temp_stderr)
    $editor = original_editor if defined?(original_editor)
  end

    # Build the output with colors
    output = ""
    town_type = case town.town_size
                when 1..4 then "Castle"
                when 5..25 then "Village"
                when 26..99 then "Town"
                else "City"
                end

    output += colorize_output(town_type.upcase, :header) + " OF " + colorize_output(town.town_name.upcase, :success) + "\n"
    output += colorize_output("=" * (@cols - 35), :header) + "\n"
    output += colorize_output("Houses: ", :label) + colorize_output(town.town.size.to_s, :value)
    output += "  " + colorize_output("Residents: ", :label) + colorize_output(town.town_residents.to_s, :value) + "\n\n"

    town.town.each_with_index do |house, idx|
      output += colorize_output("##{idx}: #{house[0]}", :subheader) + "\n"
      house[1..-1].each do |resident|
        if resident =~ /(.+?) \(([MF] \d+)\) (.+?) \[(\d+)\] (.+)/
          name = $1
          details = $2
          race = $3
          level = $4
          personality = $5
          output += "  " + colorize_output(name, :name)
          output += " (" + details + ")"
          output += " " + race
          output += " [" + colorize_output(level, :dice) + "]"
          output += " " + personality + "\n"
        else
          output += "   #{resident}\n"
        end
      end
      output += "\n"
    end

  # Set the text directly to the content pane
  @content.say(output)

  # Redraw the header and menu after fork process
  draw_header
  draw_menu

  # Refresh all panes to ensure UI is properly displayed
  @header.refresh
  @menu.refresh
  @content.refresh

  # Show navigation help
  @footer.clear
  @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))

  # Navigation
  loop do
    key = getchr
    case key
    when "ESC", "q", "ESC"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
      return_to_menu
      break
    when "j", "DOWN"
      @content.linedown
    when "k", "UP"
      @content.lineup
    when "PgDOWN"
      @content.pagedown
    when "PgUP"
      @content.pageup
    when "r"
      # Re-roll with same parameters
      begin
        @footer.clear
        @footer.say(" Re-generating town with #{town_size} houses...".ljust(@cols))

        # Capture output in a StringIO
        captured = StringIO.new

        # Start generation in background thread
        generation_thread = Thread.new do
          Thread.current[:stdout] = $stdout
          Thread.current[:stderr] = $stderr
          $stdout = captured
          $stderr = captured

          result = Town.new(town_name, town_size, town_var)

          $stdout = Thread.current[:stdout]
          $stderr = Thread.current[:stderr]
          result
        end

        # Update display while re-generating
        houses_created = 0
        start_time = Time.now

        while generation_thread.alive?
          # Check for new house numbers in captured output
          output_so_far = captured.string
          output_so_far.scan(/House (\d+)/).each do |match|
            num = match[0].to_i
            houses_created = num if num > houses_created
          end

          # Calculate elapsed time
          elapsed = Time.now - start_time

          # Update display
          output = colorize_output("RE-GENERATING TOWN", :header) + "\n"
          output += colorize_output("─" * (@cols - 35), :header) + "\n\n"
          output += colorize_output("Progress: ", :label) + colorize_output("#{houses_created} / #{town_size}", :success)

          # Add progress bar
          progress_pct = (houses_created.to_f / town_size * 100).to_i
          bar_width = 30
          filled = (bar_width * houses_created / town_size).to_i
          output += "\n\n["
          output += colorize_output("█" * filled, :success)
          output += "-" * (bar_width - filled)
          output += "] #{progress_pct}%\n"

          @content.say(output)

          sleep 0.1
        end

        # Get the generated town
        town = generation_thread.value

        # Build the output with colors
        output = ""
        town_type = case town.town_size
                    when 1..4 then "Castle"
                    when 5..25 then "Village"
                    when 26..99 then "Town"
                    else "City"
                    end

        output += colorize_output(town_type.upcase, :header) + " OF " + colorize_output(town.town_name.upcase, :success) + "\n"
        output += colorize_output("=" * (@cols - 35), :header) + "\n"
        output += colorize_output("Houses: ", :label) + colorize_output(town.town.size.to_s, :value)
        output += "  " + colorize_output("Residents: ", :label) + colorize_output(town.town_residents.to_s, :value) + "\n\n"

        town.town.each_with_index do |house, idx|
          output += colorize_output("##{idx}: #{house[0]}", :subheader) + "\n"
          house[1..-1].each do |resident|
            if resident =~ /(.+?) \(([MF] \d+)\) (.+?) \[(\d+)\] (.+)/
              name = $1
              details = $2
              race = $3
              level = $4
              personality = $5
              output += "  " + colorize_output(name, :name)
              output += " (" + details + ")"
              output += " " + race
              output += " [" + colorize_output(level, :dice) + "]"
              output += " " + personality + "\n"
            else
              output += "   #{resident}\n"
            end
          end
          output += "\n"
        end

        # Set the text directly to the content pane
        @content.say(output)

        # Refresh all panes to ensure UI is properly displayed
        @header.refresh
        @menu.refresh
        @content.refresh

        # Restore navigation help
        @footer.clear
        @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
      rescue => e
        show_content("Error re-rolling town: #{e.message}")
      end
      when "y"
        # Copy to clipboard
        copy_to_clipboard(@content.text)
        @footer.clear
        @footer.say(" Copied to clipboard! ".ljust(@cols))
        sleep(1)
        @footer.clear
        @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [s] Save | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
      when "e"
        # Edit in editor - strip ANSI codes first
        clean_text = @content.text.respond_to?(:pure) ? @content.text.pure : @content.text.gsub(/\e\[\d+(?:;\d+)*m/, '')
        edit_in_external_editor(clean_text)
        @content.say(@content.text)
      when "s"
        save_to_file(@content.text, :town)
    end
  end
rescue => e
  show_content("Error generating town: #{e.message}")
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# NAME GENERATOR
def generate_name_ui
  # Use the actual name types from the $Names table
  menu_text = colorize_output("SELECT NAME TYPE", :header) + "\n"

  $Names.each_with_index do |name_type, idx|
    menu_text += colorize_output(idx.to_s.rjust(2), :dice) + ": " + colorize_output(name_type[0], :value) + "\n"
  end
  menu_text += "\n"
  menu_text += colorize_output("Enter name type number", :label) + " (or ENTER for random): "

  show_content(menu_text)

  # Use text input like other generators
  name_input = get_text_input("")
  if name_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  idx = name_input.to_i
  idx = rand($Names.length) if idx < 0 || idx >= $Names.length
  
  begin
    # Generate multiple names with colors using the naming function
    content_width = @cols - 35
    output = colorize_output($Names[idx][0].upcase + " NAMES", :header) + "\n"
    output += colorize_output("─" * content_width, :header) + "\n\n"
    
    # Generate 20 names of the selected type
    20.times do
      name = naming($Names[idx][0])
      output += "  " + colorize_output(name, :name) + "\n"
    end
    
    show_content(output)

    # Show navigation footer
    @footer.clear
    @footer.say(" [j/↓] Down | [k/↑] Up | [r] Re-generate | [s] Save | [ESC/q] Back ".ljust(@cols))

    # Navigation
    loop do
      key = getchr
      case key
      when "ESC", "q"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
        return_to_menu
        break
      when "j", "DOWN"
        @content.linedown
      when "k", "UP"
        @content.lineup
      when " ", "PgDOWN"
        @content.pagedown
      when "PgUP"
        @content.pageup
      when "r"
        generate_name_ui
        break
      when "s"
        save_to_file(output, :names)
      end
    end

    # Return focus to menu when done
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
  rescue => e
    show_content("Error generating names: #{e.message}")
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

debug "All methods defined"

# MAIN LOOP
def main_loop
  debug "Starting main loop"

  begin
    debug "Loading config..."
    load_config
    debug "Config loaded"
  rescue => e
    debug "Error loading config: #{e.message}"
  end

  begin
    debug "Initializing screen..."
    init_screen
    debug "Screen initialized"
  rescue => e
    debug "Error in init_screen: #{e.message}"
    debug e.backtrace.join("\n")
    raise
  end

  # Set up signal handler for terminal resize
  Signal.trap('WINCH') do
    recreate_panes
  end
  
  running = true
  while running
    debug "Main loop iteration"
    begin
      running = handle_menu_navigation
    rescue => e
      debug "Error in handle_menu_navigation: #{e.message}"
      debug e.backtrace.join("\n")
      raise
    end
  end
  
  debug "Exiting main loop"
  save_config
rescue => e
  debug "Fatal error in main_loop: #{e.message}"
  debug e.backtrace.join("\n")
  File.write("amar_tui_error.log", "#{Time.now}: #{e.message}\n#{e.backtrace.join("\n")}")
ensure
  debug "Cleanup started"
  Rcurses.cleanup! if defined?(Rcurses)
  Cursor.show if defined?(Cursor) # Show cursor again
  $debug_log.close if $debug_log
  debug "Cleanup completed"
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# TOWN RELATIONS
def generate_town_relations
  debug "Starting generate_town_relations"

  # Check for saved town files
  saved_dir = File.join($pgmdir || Dir.pwd, "saved")
  default_file = File.join(saved_dir, "town.npc")

  content_width = @cols - 35
  header = colorize_output("TOWN RELATIONSHIP GENERATOR", :header) + "\n"
  header += colorize_output("─" * content_width, :header) + "\n\n"
  header += "Enter town file name (default: town.npc): "
  show_content(header)

  file_input = get_text_input("")
  if file_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Build full path
  if file_input.nil? || file_input.empty?
    town_file = default_file
  else
    # Add .npc extension if not present
    file_input += ".npc" unless file_input.end_with?(".npc")
    town_file = File.join(saved_dir, file_input)
  end

  unless File.exist?(town_file)
    error_msg = colorize_output("FILE NOT FOUND", :error) + "\n\n"
    error_msg += "File not found: " + town_file.fg(196) + "\n\n"
    error_msg += "Press any key to continue..."
    show_content(error_msg)
    getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  show_content(colorize_output("Generating relationship map...", :info) + "\n\n")

  begin
    # Run the town_relations function from includes (same as CLI)
    town_relations(town_file)
    town_dot2txt(town_file)

    # Check if PNG and TXT were generated
    png_file = town_file.sub(/\.npc$/, '.png')
    txt_file = town_file.sub(/\.npc$/, '.txt')

    output = colorize_output("TOWN RELATIONSHIPS", :header) + "\n"
    output += colorize_output("─" * content_width, :header) + "\n\n"

    if File.exist?(png_file)
      output += colorize_output("✓ Graphical map generated: ", :success) + File.basename(png_file).fg(39) + "\n"
    end

    if File.exist?(txt_file)
      output += colorize_output("✓ Text map generated: ", :success) + File.basename(txt_file).fg(39) + "\n\n"

      # Read and display the text relationship map with coloring
      txt_content = File.read(txt_file)
      output += colorize_output("RELATIONSHIP MAP", :subheader) + "\n"
      output += "─" * content_width + "\n\n"

      # Add coloring to the relationship text
      txt_content.lines.each do |line|
        if line.include?("===")
          # Strong alliance (double positive)
          output += line.fg(10).b  # Bright green bold
        elsif line.include?("---")
          # Strong hate (double negative)
          output += line.fg(196).b  # Bright red bold
        elsif line.include?("+++")
          # Complex relationship
          output += line.fg(226)  # Yellow
        elsif line.include?("--")
          # Negative relationship
          output += line.fg(160)  # Red
        elsif line.include?("++")
          # Positive relationship
          output += line.fg(82)  # Green
        else
          output += line.fg(7)  # Normal white
        end
      end
    else
      output += "No text map generated.\n"
    end

    output += "\n" + colorize_output("Files saved in: ", :info) + saved_dir.fg(39) + "\n"

    # Try to display the PNG inline if it exists, otherwise show text
    showing_image = false
    if File.exist?(png_file) && display_terminal_image(png_file)
      # Image displayed successfully, clear any text to prevent overlap
      @content.clear
      showing_image = true
    else
      # No image display available or failed, show the text output
      show_content(output)
    end

    # Show navigation options
    @footer.say(" [j/↓] Down | [k/↑] Up | [v] View image/text | [o] Open PNG | [s] Save | [ESC/q] Back ".ljust(@cols))

    loop do
      key = getchr
      case key
      when "ESC", "\e", "q", "LEFT"
        break
      when "j", "DOWN"
        @content.linedown unless showing_image
      when "k", "UP"
        @content.lineup unless showing_image
      when " ", "PgDOWN"
        @content.pagedown unless showing_image
      when "b", "PgUP"
        @content.pageup unless showing_image
      when "o", "O"
        # Open PNG in external viewer
        if File.exist?(png_file)
          if system("which xdg-open > /dev/null 2>&1")
            system("xdg-open \"#{png_file}\" 2>/dev/null &")
          elsif system("which open > /dev/null 2>&1")
            system("open \"#{png_file}\" 2>/dev/null &")
          else
            temp_msg = showing_image ? "" : @content.text
            show_content(temp_msg + "\n\nCannot open image - no viewer available.\nImage path: #{png_file}")
          end
        else
          temp_msg = showing_image ? "" : @content.text
          show_content(temp_msg + "\n\nNo PNG file generated.")
        end
      when "s", "S"
        save_to_file(showing_image ? output : @content.text, :relations)
      when "v", "V"
        # Toggle between image and text view
        if showing_image
          # Currently showing image, switch to text - clear image overlay first
          clear_terminal_image
          showing_image = false
          @content.clear
          show_content(output)
        else
          # Currently showing text, switch to image
          if File.exist?(png_file)
            # Clear the content pane text
            @content.text = ""
            @content.clear
            @content.refresh
            if display_terminal_image(png_file)
              showing_image = true
            end
          end
        end
      end
    end

  rescue => e
    debug "Error generating relations: #{e.message}"
    debug e.backtrace.join("\n") if e.backtrace
    error_msg = colorize_output("ERROR", :error) + "\n\n"
    error_msg += "Failed to generate relations: " + e.message.fg(196) + "\n\n"
    error_msg += "Press any key to continue..."
    show_content(error_msg)
    getchr
  end

  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# AI FEATURES
def setup_openai_config
  config_dir = File.expand_path("~/.amar-tools")
  config_file = File.join(config_dir, "conf")

  # Create config directory if it doesn't exist
  Dir.mkdir(config_dir) unless Dir.exist?(config_dir)

  # Load config or create default
  if File.exist?(config_file)
    load config_file
  else
    # Create default config
    default_config = <<~CONFIG
      # Amar-Tools Configuration
      # Add your OpenAI API key below:
      @ai = "your-openai-api-key-here"
      @aimodel = "gpt-4o-mini"  # You can change to gpt-4o or other models
    CONFIG
    File.write(config_file, default_config)
    load config_file
  end

  # Default model if not set
  @aimodel ||= "gpt-4o-mini"
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def openai_client
  require 'ruby/openai' unless defined?(OpenAI)
  @openai_client ||= OpenAI::Client.new(access_token: @ai)
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def generate_adventure_ai
  debug "Starting generate_adventure_ai"
  content_width = @cols - 35

  # Setup OpenAI config
  setup_openai_config

  # Check if API key is configured
  unless @ai && @ai != "your-openai-api-key-here" && !@ai.empty?
    output = colorize_output("OpenAI NOT CONFIGURED", :header) + "\n\n"
    output += "Please configure your OpenAI API key in: ~/.amar-tools/conf\n\n"
    output += "Add this line with your actual API key:\n"
    output += "@ai = \"your-actual-api-key\"\n\n"
    output += "If you already have a key in ~/.rtfm/conf, you can copy it.\n\n"
    output += "Press any key to continue..."
    show_content(output)
    key = getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Check if adventure prompt file exists
  adv_file = File.join($pgmdir, "adv.txt")
  unless File.exist?(adv_file)
    output = colorize_output("MISSING PROMPT FILE", :header) + "\n\n"
    output += "Adventure prompt file not found:\n"
    output += "#{adv_file}\n\n"
    output += "Press any key to continue..."
    show_content(output)
    key = getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  show_content(colorize_output("AI ADVENTURE GENERATION", :header) + "\n" +
              colorize_output("─" * content_width, :header) + "\n\n" +
              "Getting response from OpenAI...\n\n" +
              "This may take a moment...\n\n" +
              "(quality may vary, use at your own discretion)".fg(240))

  begin
    # Load the adventure prompt
    prompt_content = File.read(adv_file)

    # Send to OpenAI using ruby-openai gem
    show_content(colorize_output("Generating adventure...", :header) + "\n\n" +
                "Please wait, this may take a moment...".fg(240))

    begin
      require 'ruby/openai'
    rescue LoadError
      show_content("Error: ruby-openai gem not found. Please install with: gem install ruby-openai")
      getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
      return_to_menu
      return
    end

    client = openai_client
    api_response = client.chat(
      parameters: {
        model: @aimodel,
        messages: [{ role: 'user', content: prompt_content }],
        max_tokens: 1800
      }
    ) rescue nil

    response = api_response&.dig('choices', 0, 'message', 'content')

    if response && !response.empty?
      # Clean up any #### dividers and format as Markdown
      response = response.gsub(/####\s*/, '')

      # Apply Markdown-style colorization
      formatted_response = response
        .gsub(/^#\s+(.*)$/, colorize_output("\\1", :header))  # H1 headers
        .gsub(/^##\s+(.*)$/, colorize_output("\\1", :label))   # H2 headers
        .gsub(/^###\s+(.*)$/, colorize_output("\\1", :value))  # H3 headers
        .gsub(/\*\*(.*?)\*\*/, colorize_output("\\1", :highlight))  # Bold
        .gsub(/\*(.*?)\*/, "\\1".fg(244))  # Italic (grey)

      # Format and display response
      output = colorize_output("AI GENERATED ADVENTURE", :header) + "\n"
      output += colorize_output("─" * content_width, :header) + "\n\n"
      output += formatted_response

      # Save to file
      save_dir = File.join($pgmdir || Dir.pwd, "saved")
      Dir.mkdir(save_dir) unless Dir.exist?(save_dir)
      save_file = File.join(save_dir, "openai.txt")
      File.write(save_file, response)
      output += "\n\n" + colorize_output("Saved to: saved/openai.txt", :success)

      show_content(output)

      # Navigation with editor option
      @footer.say(" [j/↓] Down | [k/↑] Up | [e] Edit | [s] Save | [ESC/q] Back ".ljust(@cols))

      loop do
        key = getchr
        case key
        when "ESC", "q"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
          return_to_menu
          break
        when "j", "DOWN"
          @content.linedown
        when "k", "UP"
          @content.lineup
        when " ", "PgDOWN"
          @content.pagedown
        when "PgUP"
          @content.pageup
        when "e"
          # Edit in editor
          edit_in_external_editor(response)
          show_content(output)
        when "s"
          save_to_file(response, :adventure)
        end
      end
    else
      output = colorize_output("ERROR", :header) + "\n\n"
      output += "Failed to get response from OpenAI.\n\n"
      output += "Error: #{response}\n\n" if response && !response.empty?
      output += "Press any key to continue..."
      show_content(output)
      getchr
    end
  rescue => e
    show_content("Error: #{e.message}\n\nPress any key to continue...")
    getchr
  end

  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def describe_encounter_ai
  debug "Starting describe_encounter_ai"
  content_width = @cols - 35

  # Check if openai command exists
  unless system("which openai > /dev/null 2>&1")
    output = colorize_output("OpenAI NOT CONFIGURED", :header) + "\n\n"
    output += "The 'openai' command is not installed.\n\n"
    output += "Please install and configure OpenAI.\n\n"
    output += "Press any key to continue..."
    show_content(output)
    key = getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Get encounter file name
  prompt_text = colorize_output("DESCRIBE ENCOUNTER WITH AI", :header) + "\n\n"
  prompt_text += colorize_output("Enter encounter file name", :label)
  prompt_text += " (default: encounter_new.npc): "

  show_content(prompt_text)
  file_input = get_text_input("")
  if file_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  filename = file_input.nil? || file_input.empty? ? "encounter_new.npc" : file_input
  filepath = File.join($pgmdir, "saved", filename)

  unless File.exist?(filepath)
    output = colorize_output("FILE NOT FOUND", :header) + "\n\n"
    output += "Encounter file not found:\n"
    output += "#{filepath}\n\n"
    output += "Press any key to continue..."
    show_content(output)
    getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Check for prompt file
  enc_prompt = File.join($pgmdir, "enc.txt")
  unless File.exist?(enc_prompt)
    output = colorize_output("MISSING PROMPT FILE", :header) + "\n\n"
    output += "Encounter prompt file not found:\n"
    output += "#{enc_prompt}\n\n"
    output += "Press any key to continue..."
    show_content(output)
    getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  show_content(colorize_output("AI ENCOUNTER DESCRIPTION", :header) + "\n" +
              colorize_output("─" * content_width, :header) + "\n\n" +
              "Getting response from OpenAI...\n\n" +
              "This may take a moment...")

  begin
    # Read prompt and run OpenAI
    prompt_text = File.read(enc_prompt)
    enc_content = File.read(filepath)
    combined = "#{prompt_text}\n\n#{enc_content}"

    # Send to OpenAI using ruby-openai gem
    show_content(colorize_output("Generating encounter description...", :header) + "\n\n" +
                "Please wait, this may take a moment...".fg(240))

    client = openai_client
    api_response = client.chat(
      parameters: {
        model: @aimodel,
        messages: [{ role: 'user', content: combined }],
        max_tokens: 2000
      }
    ) rescue nil

    response = api_response&.dig('choices', 0, 'message', 'content')

    if response && !response.empty?
      # Format and display response
      output = colorize_output("AI ENCOUNTER DESCRIPTION", :header) + "\n"
      output += colorize_output("─" * content_width, :header) + "\n\n"
      output += response

      # Save to file
      save_dir = File.join($pgmdir || Dir.pwd, "saved")
      Dir.mkdir(save_dir) unless Dir.exist?(save_dir)
      save_file = File.join(save_dir, "openai.txt")
      File.write(save_file, response)
      output += "\n\n" + colorize_output("Saved to: saved/openai.txt", :success)

      show_content(output)

      # Navigation with ESC/q support
      @footer.say(" [j/↓] Down | [k/↑] Up | [s] Save | [ESC/q] Back ".ljust(@cols))

      loop do
        key = getchr
        case key
        when "ESC", "q"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
          return_to_menu
          break
        when "j", "DOWN"
          @content.linedown
        when "k", "UP"
          @content.lineup
        when " ", "PgDOWN"
          @content.pagedown
        when "PgUP"
          @content.pageup
        when "e", "E"
          # Edit the description
          edited_response = edit_in_external_editor(response)
          if edited_response != response
            response = edited_response
            # Save the edited version
            File.write(File.join(save_dir, "openai.txt"), response)
            # Update display
            output = colorize_output("AI ENCOUNTER DESCRIPTION (EDITED)", :header) + "\n"
            output += colorize_output("─" * content_width, :header) + "\n\n"
            output += response
            output += "\n\n" + colorize_output("Edited and saved", :success)
            show_content(output)
          end
          @footer.say(" [j/↓] Down | [k/↑] Up | [e] Edit | [s] Save | [ESC/q] Back ".ljust(@cols))
        when "s"
          save_to_file(response, :encounter_desc)
        end
      end
    else
      output = colorize_output("ERROR", :header) + "\n\n"
      output += "Failed to get response from OpenAI.\n\n"
      output += "Error: #{response}\n\n" if response && !response.empty?
      output += "Press any key to continue..."
      show_content(output)
      getchr
    end
  rescue => e
    show_content("Error: #{e.message}\n\nPress any key to continue...")
    getchr
  end

  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def describe_npc_ai
  debug "Starting describe_npc_ai"
  content_width = @cols - 35

  # Setup OpenAI config
  setup_openai_config

  # Check if API key is configured
  unless @ai && @ai != "your-openai-api-key-here" && !@ai.empty?
    output = colorize_output("OpenAI NOT CONFIGURED", :header) + "\n\n"
    output += "Please configure your OpenAI API key in: ~/.amar-tools/conf\n\n"
    output += "Add this line with your actual API key:\n"
    output += "@ai = \"your-actual-api-key\"\n\n"
    output += "If you already have a key in ~/.rtfm/conf, you can copy it.\n\n"
    output += "Press any key to continue..."
    show_content(output)
    key = getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Get NPC file name
  prompt_text = colorize_output("DESCRIBE NPC WITH AI", :header) + "\n\n"
  prompt_text += colorize_output("Enter NPC file name", :label)
  prompt_text += " (default: temp_new.npc): "

  show_content(prompt_text)
  file_input = get_text_input("")
  if file_input == :cancelled
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  filename = file_input.nil? || file_input.empty? ? "temp_new.npc" : file_input
  filepath = File.join($pgmdir, "saved", filename)

  unless File.exist?(filepath)
    output = colorize_output("FILE NOT FOUND", :header) + "\n\n"
    output += "NPC file not found:\n"
    output += "#{filepath}\n\n"
    output += "Press any key to continue..."
    show_content(output)
    getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Check for prompt file
  npc_prompt = File.join($pgmdir, "npc.txt")
  unless File.exist?(npc_prompt)
    output = colorize_output("MISSING PROMPT FILE", :header) + "\n\n"
    output += "NPC prompt file not found:\n"
    output += "#{npc_prompt}\n\n"
    output += "Press any key to continue..."
    show_content(output)
    getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  show_content(colorize_output("AI NPC DESCRIPTION", :header) + "\n" +
              colorize_output("─" * content_width, :header) + "\n\n" +
              "Getting response from OpenAI...\n\n" +
              "This may take a moment...")

  begin
    # Read prompt and NPC file
    prompt_text = File.read(npc_prompt)
    npc_content = File.read(filepath)
    combined = "#{prompt_text}\n\n#{npc_content}"

    # Send to OpenAI using ruby-openai gem
    show_content(colorize_output("Generating NPC description...", :header) + "\n\n" +
                "Please wait, this may take a moment...".fg(240))

    client = openai_client
    api_response = client.chat(
      parameters: {
        model: @aimodel,
        messages: [{ role: 'user', content: combined }],
        max_tokens: 2000
      }
    ) rescue nil

    response = api_response&.dig('choices', 0, 'message', 'content')

    if response && !response.empty?
      # Format and display response
      output = colorize_output("AI NPC DESCRIPTION", :header) + "\n"
      output += colorize_output("─" * content_width, :header) + "\n\n"
      output += response

      # Save to file
      save_dir = File.join($pgmdir || Dir.pwd, "saved")
      Dir.mkdir(save_dir) unless Dir.exist?(save_dir)
      save_file = File.join(save_dir, "openai.txt")
      File.write(save_file, response)

      # Try to extract character name from the NPC file or use last known name
      character_name = nil
      if filename && filename.match?(/\.npc$/)
        # Try to read the NPC file and extract the name
        begin
          npc_content = File.read(filepath)
          if match = npc_content.match(/^([A-Za-z\s]+)\s+\([MF]\s+\d+\)/)
            character_name = match[1].strip.gsub(/[^A-Za-z0-9]/, '')
          end
        rescue
          # Ignore errors
        end
      end

      # Use last known name if no name extracted
      character_name ||= @last_npc_name

      # Save with character name if available
      if character_name && !character_name.empty?
        name_desc_file = File.join(save_dir, "#{character_name}.txt")
        File.write(name_desc_file, response)
        output += "\n\n" + colorize_output("Saved to: saved/#{character_name}.txt", :success)
        @last_npc_name = character_name  # Update last known name
      else
        output += "\n\n" + colorize_output("Saved to: saved/openai.txt", :success)
      end

      show_content(output)

      # Store description for potential image generation
      @last_npc_description = response

      # Navigation with ESC/q support, edit, and image generation
      @footer.say(" [j/↓] Down | [k/↑] Up | [e] Edit | [i] Generate Image | [s] Save | [ESC/q] Back ".ljust(@cols))

      loop do
        key = getchr
        case key
        when "ESC", "q"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
          return_to_menu
          break
        when "j", "DOWN"
          @content.linedown
        when "k", "UP"
          @content.lineup
        when " ", "PgDOWN"
          @content.pagedown
        when "PgUP"
          @content.pageup
        when "e", "E"
          # Edit the description
          edited_response = edit_in_external_editor(response)
          if edited_response != response
            response = edited_response
            # Save the edited version
            if character_name && !character_name.empty?
              File.write(File.join(save_dir, "#{character_name}.txt"), response)
            end
            File.write(File.join(save_dir, "openai.txt"), response)
            # Update display
            output = colorize_output("AI NPC DESCRIPTION (EDITED)", :header) + "\n"
            output += colorize_output("─" * content_width, :header) + "\n\n"
            output += response
            output += "\n\n" + colorize_output("Edited and saved", :success)
            show_content(output)
            @last_npc_description = response
          end
          @footer.say(" [j/↓] Down | [k/↑] Up | [e] Edit | [i] Generate Image | [s] Save | [ESC/q] Back ".ljust(@cols))
        when "s"
          save_to_file(response, :npc_desc)
        when "i", "I"
          # Generate DALL-E image from description
          generate_npc_image(response)
          # Return to description view
          show_content(output)
          @footer.say(" [j/↓] Down | [k/↑] Up | [e] Edit | [i] Generate Image | [s] Save | [ESC/q] Back ".ljust(@cols))
        end
      end
    else
      output = colorize_output("ERROR", :header) + "\n\n"
      output += "Failed to get response from OpenAI.\n\n"
      output += "Error: #{response}\n\n" if response && !response.empty?
      output += "Press any key to continue..."
      show_content(output)
      getchr
    end
  rescue => e
    show_content("Error: #{e.message}\n\nPress any key to continue...")
    getchr
  end

  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

# Display image in terminal using w3mimgdisplay (like RTFM/IMDB)
def clear_terminal_image
  w3m = "/usr/lib/w3m/w3mimgdisplay"
  return false unless File.executable?(w3m)

  begin
    require 'timeout'
    Timeout.timeout(1) do
      # Get terminal window info
      info = `xwininfo -id $(xdotool getactivewindow) 2>/dev/null`
      return false unless info =~ /Width:\s*(\d+).*Height:\s*(\d+)/m

      term_width = $1.to_i
      term_height = $2.to_i

      # Calculate area to clear (only INSIDE the content pane)
      # Content pane starts at column 34, row 3, with 1 char border
      char_w = term_width.to_f / @cols
      char_h = term_height.to_f / @rows

      # Start position: account for pane position and border
      px = ((34 + 1) * char_w).to_i  # Column 35 (34 + 1 for border)
      py = ((3 + 1) * char_h).to_i   # Row 4 (3 + 1 for border)

      # Size: content pane width/height minus borders
      max_w = ((@cols - 35 - 2) * char_w).to_i  # -2 for left and right borders
      max_h = ((@rows - 4 - 3) * char_h).to_i   # -3 to stay away from bottom border

      # Clear only the inside of the content pane
      `echo "6;#{px};#{py};#{max_w};#{max_h};\n4;\n3;" | #{w3m} 2>/dev/null`
      return true
    end
  rescue Timeout::Error
    return false
  rescue => e
    debug "Error clearing image: #{e.message}"
    return false
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def display_terminal_image(image_path)
  debug "display_terminal_image called with: #{image_path.inspect}"
  w3m = "/usr/lib/w3m/w3mimgdisplay"

  unless File.executable?(w3m)
    debug "w3mimgdisplay not executable at #{w3m}"
    return false
  end

  unless File.exist?(image_path)
    debug "Image path doesn't exist: #{image_path}"
    return false
  end

  begin
    # Use timeout to prevent hanging
    require 'timeout'
    Timeout.timeout(2) do
      # Get terminal window info
      info = `xwininfo -id $(xdotool getactivewindow) 2>/dev/null`
      return false unless info =~ /Width:\s*(\d+).*Height:\s*(\d+)/m

      term_width = $1.to_i
      term_height = $2.to_i

      # Calculate position and size for image display
      # Content pane starts at column 34, row 3, with borders
      char_w = term_width.to_f / @cols
      char_h = term_height.to_f / @rows

      # Position image inside the content pane (account for border)
      px = ((34 + 1) * char_w).to_i  # Column 35 (34 + 1 for left border)
      py = ((3 + 1) * char_h).to_i   # Row 4 (3 + 1 for top border)

      # Max dimensions for the image (leave some padding inside the pane)
      max_w = ((@cols - 35 - 3) * char_w).to_i  # -3 for borders and padding
      max_h = ((@rows - 4 - 3) * char_h).to_i   # -3 for borders and padding

      # Clear the area first (same as clear_terminal_image but inline)
      clear_w = ((@cols - 35 - 2) * char_w).to_i
      clear_h = ((@rows - 4 - 3) * char_h).to_i
      `echo "6;#{px};#{py};#{clear_w};#{clear_h};\n4;\n3;" | #{w3m} 2>/dev/null`

      # Get image dimensions
      dimensions = `identify -format "%wx%h" "#{image_path}" 2>/dev/null`.strip
      return false if dimensions.empty?

      iw, ih = dimensions.split('x').map(&:to_i)

      # Scale image to fit
      if iw > max_w
        ih = (ih * max_w / iw).to_i
        iw = max_w
      end
      if ih > max_h
        iw = (iw * max_h / ih).to_i
        ih = max_h
      end

      # Display the image
      debug "Displaying image at: px=#{px}, py=#{py}, iw=#{iw}, ih=#{ih}"
      `echo "0;1;#{px};#{py};#{iw};#{ih};;;;;\"#{image_path}\"\n4;\n3;" | #{w3m} 2>/dev/null`
      debug "Image display command sent successfully"

      return true
    end
  rescue Timeout::Error
    debug "Timeout error in display_terminal_image"
    return false
  rescue => e
    debug "Error displaying image: #{e.message}"
    debug "Backtrace: #{e.backtrace[0..3].join("\n")}"
    return false
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def generate_npc_image(description = nil)
  debug "Starting generate_npc_image"
  content_width = @cols - 35

  # Setup OpenAI config
  setup_openai_config

  # Check if API key is configured
  unless @ai && @ai != "your-openai-api-key-here" && !@ai.empty?
    output = colorize_output("OpenAI NOT CONFIGURED", :header) + "\n\n"
    output += "Please configure your OpenAI API key in: ~/.amar-tools/conf\n\n"
    output += "Press any key to continue..."
    show_content(output)
    getchr
    return
  end

  # Get or use provided description
  if description.nil? || description.empty?
    # Ask user: use last NPC or specify file
    prompt_text = colorize_output("GENERATE NPC IMAGE", :header) + "\n\n"
    prompt_text += "Enter NPC filename (default: last generated NPC)\n"
    prompt_text += "or press Enter to use the last NPC: "
    show_content(prompt_text)

    file_input = get_text_input("")
    return if file_input == :cancelled

    save_dir = File.join($pgmdir || Dir.pwd, "saved")
    npc_file = nil

    if file_input.nil? || file_input.empty?
      # Use last generated NPC
      npc_file = File.join(save_dir, "temp_new.npc")
      unless File.exist?(npc_file)
        show_content("No recent NPC found. Please generate an NPC first.\n\nPress any key to continue...")
        getchr
        return
      end
    else
      # Use specified file
      if !file_input.match?(/\.npc$/)
        file_input += ".npc"
      end
      npc_file = File.join(save_dir, file_input)
      unless File.exist?(npc_file)
        show_content("NPC file not found: #{npc_file}\n\nPress any key to continue...")
        getchr
        return
      end
    end

    # Extract character details from NPC file
    npc_content = File.read(npc_file)
    character_name = nil
    character_gender = nil
    character_race = nil
    character_class = nil
    character_height = nil
    character_weight = nil
    character_desc_line = nil

    # Parse first line for name, gender, height, weight
    lines = npc_content.lines
    if lines[0]
      # Extract name and gender (e.g., "Sera Brightblade (F 75)")
      if match = lines[0].match(/^([A-Za-z\s]+)\s+\(([MF])\s+\d+\)/)
        character_name = match[1].strip
        character_gender = match[2] == "F" ? "female" : "male"
        safe_name = character_name.gsub(/[^A-Za-z0-9]/, '')
        @last_npc_name = safe_name
      end

      # Extract height and weight
      if match = lines[0].match(/H\/W:\s+(\d+cm)\/(\d+kg)/)
        character_height = match[1]
        character_weight = match[2]
      end

      # Extract race and class (e.g., "Elf: Warrior (7)" or just race)
      # Look for pattern like "Elf: Warrior (7)" or "Human (0)"
      if match = lines[0].match(/([A-Za-z-]+):\s+([A-Za-z\s]+)\s*\(\d+\)/)
        character_race = match[1]
        character_class = match[2].strip
      elsif match = lines[0].match(/\s+([A-Za-z-]+)\s*\(\d+\)\s*$/)
        # Just race without class (e.g., "Human (0)")
        character_race = match[1]
      end
    end

    # Extract description line
    if lines[2] && match = lines[2].match(/Description:\s+(.+)$/)
      character_desc_line = match[1].strip
    end

    # Check if we already have a description for this NPC
    desc_file = nil
    if @last_npc_name && !@last_npc_name.empty?
      desc_file = File.join(save_dir, "#{@last_npc_name}.txt")
    end

    if desc_file && File.exist?(desc_file)
      # Use existing description
      show_content(colorize_output("Using existing description for #{character_name || 'NPC'}...", :info) + "\n\n")
      description = File.read(desc_file)
    else
      # Generate description for this NPC
      show_content(colorize_output("Generating AI description for #{character_name || 'NPC'}...", :header) + "\n\n" +
                  "Please wait, this may take a moment...\n\n")

      # Build character info for the AI prompt
      character_info = "Generate a detailed physical and personality description for:\n"
      character_info += "Name: #{character_name}\n" if character_name
      character_info += "Gender: #{character_gender}\n" if character_gender
      character_info += "Race: #{character_race}\n" if character_race
      character_info += "Class/Profession: #{character_class}\n" if character_class
      character_info += "Height: #{character_height}\n" if character_height
      character_info += "Weight: #{character_weight}\n" if character_weight
      character_info += "Basic appearance: #{character_desc_line}\n" if character_desc_line
      character_info += "\nProvide a rich, detailed description suitable for generating a character portrait."

      # Load NPC prompt
      npc_prompt = File.join($pgmdir, "npc.txt")
      unless File.exist?(npc_prompt)
        show_content("NPC prompt file not found.\n\nPress any key to continue...")
        getchr
        return
      end

      prompt_text = File.read(npc_prompt)
      combined = "#{character_info}\n\n#{prompt_text}\n\n#{npc_content}"

      # Generate description
      client = openai_client
      api_response = client.chat(
        parameters: {
          model: @aimodel,
          messages: [{ role: 'user', content: combined }],
          max_tokens: 2000
        }
      ) rescue nil

      description = api_response&.dig('choices', 0, 'message', 'content')

      if description.nil? || description.empty?
        show_content("Failed to generate description.\n\nPress any key to continue...")
        getchr
        return
      end

      # Save the generated description
      if @last_npc_name && !@last_npc_name.empty?
        File.write(File.join(save_dir, "#{@last_npc_name}.txt"), description)
      end
      File.write(File.join(save_dir, "openai.txt"), description)
    end
  end

  # Allow editing the description
  edit_text = colorize_output("CHARACTER DESCRIPTION FOR IMAGE", :header) + "\n\n"
  edit_text += description + "\n\n"
  edit_text += colorize_output("Press [e] to edit, [Enter] to generate, [ESC] to cancel", :info)
  show_content(edit_text)

  loop do
    key = getchr
    case key
    when "ESC", "q"
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
      return_to_menu
      return
    when "e", "E"
      description = edit_in_external_editor(description)
      edit_text = colorize_output("CHARACTER DESCRIPTION FOR IMAGE", :header) + "\n\n"
      edit_text += description + "\n\n"
      edit_text += colorize_output("Press [e] to edit, [Enter] to generate, [ESC] to cancel", :info)
      show_content(edit_text)
    when "ENTER", "\r"
      break
    end
  end

  # Load Amar background for context
  amar_background = ""
  gen_file = File.join($pgmdir, "gen.txt")
  if File.exist?(gen_file)
    amar_background = File.read(gen_file)
  end

  # Create enhanced prompt for DALL-E with explicit character details
  dalle_prompt = "Create a photorealistic fantasy character portrait.\n\n"

  # Add explicit character details if we have them
  if character_name || character_gender
    dalle_prompt += "CHARACTER DETAILS:\n"
    dalle_prompt += "- Name: #{character_name}\n" if character_name

    if character_gender
      dalle_prompt += "- Gender: #{character_gender.upcase} (CRITICAL: This MUST be a #{character_gender} character)\n"
    end

    # Default to Human if no race specified
    if character_race && !character_race.empty?
      dalle_prompt += "- Race: #{character_race}\n"
    else
      dalle_prompt += "- Race: Human (assumed)\n"
    end

    if character_class && !character_class.empty?
      dalle_prompt += "- Class: #{character_class}\n"
    else
      dalle_prompt += "- Class: Commoner/Civilian\n"
    end

    dalle_prompt += "- Height: #{character_height}\n" if character_height
    dalle_prompt += "- Weight: #{character_weight}\n" if character_weight
    dalle_prompt += "\n"
  end

  # Make sure description is not nil
  if description && !description.empty?
    dalle_prompt += "DESCRIPTION:\n#{description}\n\n"
  else
    dalle_prompt += "DESCRIPTION:\nGenerate based on the character details above.\n\n"
  end

  dalle_prompt += "STYLE:\n"
  dalle_prompt += "Photorealistic medieval fantasy portrait, cinematic lighting, highly detailed.\n"
  dalle_prompt += "Show character from mid-torso up with appropriate clothing and equipment.\n"

  dalle_prompt += "\nIMPORTANT REQUIREMENTS:\n"
  dalle_prompt += "- NO TEXT, LABELS, WATERMARKS, OR WRITING OF ANY KIND IN THE IMAGE\n"
  dalle_prompt += "- This must be a PURE PORTRAIT IMAGE with absolutely no text elements\n"
  dalle_prompt += "- Do not add names, titles, captions, or any written information\n"
  dalle_prompt += "- Focus solely on the visual representation of the character\n"

  if character_gender
    dalle_prompt += "\n- The character is #{character_gender.upcase}. "
    dalle_prompt += "Ensure all physical features clearly match a #{character_gender} character.\n"
  end

  show_content(colorize_output("GENERATING IMAGE", :header) + "\n" +
              colorize_output("─" * content_width, :header) + "\n\n" +
              "Creating DALL-E 3 image...\n\n" +
              "This may take up to 30 seconds...\n\n" +
              "(Photorealistic fantasy portrait)".fg(240))

  begin
    require 'ruby/openai'
    require 'net/http'
    require 'fileutils'

    client = openai_client

    # Generate image with DALL-E 3
    debug "Attempting to generate image with DALL-E"
    debug "DALL-E Prompt length: #{dalle_prompt.length} characters"
    debug "DALL-E Prompt (first 500 chars): #{dalle_prompt[0..500]}"

    # Ensure prompt doesn't exceed DALL-E 3's 4000 character limit
    if dalle_prompt.length > 4000
      dalle_prompt = dalle_prompt[0..3990] + "..."
      debug "Prompt truncated to 4000 characters"
    end

    api_response = client.images.generate(
      parameters: {
        model: "dall-e-3",
        prompt: dalle_prompt,
        size: "1792x1024",  # 16:9 aspect ratio
        quality: "standard",
        n: 1
      }
    )

    debug "API Response: #{api_response.inspect}"

    # Check different response formats
    image_url = api_response&.dig("data", 0, "url") ||
                api_response&.dig("data")&.first&.dig("url") ||
                api_response&.dig("images")&.first&.dig("url")

    if image_url
      # URL already extracted above

      # Download image
      save_dir = File.join($pgmdir, "saved", "images")
      FileUtils.mkdir_p(save_dir)

      # Try to extract character name from description if not already set
      if !@last_npc_name || @last_npc_name.empty?
        # Try to extract name from description (e.g., "John Smith, a tall warrior...")
        if match = description.match(/^([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)/)
          @last_npc_name = match[1].gsub(/[^A-Za-z0-9]/, '')
        end
      end

      # Use character name if available, otherwise timestamp
      if @last_npc_name && !@last_npc_name.empty?
        image_file = File.join(save_dir, "#{@last_npc_name}.png")
        # If file exists, add timestamp to avoid overwriting
        if File.exist?(image_file)
          timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
          image_file = File.join(save_dir, "#{@last_npc_name}_#{timestamp}.png")
        end
      else
        timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
        image_file = File.join(save_dir, "npc_#{timestamp}.png")
      end

      # Download the image
      uri = URI(image_url)
      response = Net::HTTP.get_response(uri)

      if response.code == "200"
        File.open(image_file, "wb") do |file|
          file.write(response.body)
        end

        output = colorize_output("IMAGE GENERATED SUCCESSFULLY", :header) + "\n"
        output += colorize_output("─" * content_width, :header) + "\n\n"
        output += "Image saved to: #{image_file}\n\n"

        # Display the output first
        show_content(output)

        # Try to display image inline using w3mimgdisplay (like RTFM/IMDB)
        image_displayed = false
        if display_terminal_image(image_file)
          image_displayed = true
          debug "Image displayed using w3mimgdisplay"
        elsif system("which imgcat > /dev/null 2>&1")
          # Fallback to imgcat if available
          system("imgcat \"#{image_file}\"")
          image_displayed = true
          debug "Image displayed using imgcat"
        elsif system("which kitty > /dev/null 2>&1")
          # Fallback to kitty if available
          system("kitty +kitten icat \"#{image_file}\"")
          image_displayed = true
          debug "Image displayed using kitty"
        end

        if !image_displayed
          output += "To view the image, open: #{image_file}\n\n"
          output += "(Install w3m-img, imgcat, or use kitty terminal for inline viewing)\n\n"
          show_content(output)
        end

        # Don't show any text after displaying image - just wait for key
        getchr
      else
        show_content("Error downloading image: #{response.code}\n\nPress any key to continue...")
        getchr
      end
    else
      error_msg = "Failed to generate image.\n\n"
      if api_response
        error_msg += "Response: #{api_response.inspect[0..500]}\n\n"
      end
      error_msg += "Press any key to continue..."
      show_content(error_msg)
      debug "Image generation failed. Response: #{api_response.inspect}"
      getchr
    end
  rescue => e
    debug "Image generation error: #{e.class} - #{e.message}"
    debug "Backtrace: #{e.backtrace.first(5).join("\n")}" if e.backtrace

    error_msg = "Error generating image:\n\n"

    # Check for specific error types
    if e.message.include?("400")
      error_msg += "Bad Request (400): The prompt may be invalid or too long.\n"
      error_msg += "Check the debug log at /tmp/amar_tui_debug.log for details.\n\n"
    elsif e.message.include?("401")
      error_msg += "Authentication Error (401): Check your OpenAI API key.\n\n"
    elsif e.message.include?("429")
      error_msg += "Rate Limit (429): Too many requests. Please wait and try again.\n\n"
    elsif e.message.include?("500") || e.message.include?("502") || e.message.include?("503")
      error_msg += "OpenAI Server Error: The service may be temporarily unavailable.\n\n"
    else
      error_msg += "#{e.message}\n\n"
    end

    error_msg += "Press any key to continue..."
    show_content(error_msg)
    getchr
  ensure
    # Always return focus to menu after image generation
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
  end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def show_latest_npc_image
  debug "Starting show_latest_npc_image"
  content_width = @cols - 35

  # Check saved images directory
  save_dir = File.join($pgmdir, "saved", "images")

  unless Dir.exist?(save_dir)
    output = colorize_output("NO IMAGES FOUND", :header) + "\n\n"
    output += "No NPC images have been generated yet.\n\n"
    output += "Use 'I. Generate NPC Image' to create an image first.\n\n"
    output += "Press any key to continue..."
    show_content(output)
    getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Find the most recent PNG file in the images directory
  image_files = Dir.glob(File.join(save_dir, "*.png")).sort_by { |f| File.mtime(f) }.reverse

  if image_files.empty?
    output = colorize_output("NO IMAGES FOUND", :header) + "\n\n"
    output += "No NPC images have been generated yet.\n\n"
    output += "Use 'I. Generate NPC Image' to create an image first.\n\n"
    output += "Press any key to continue..."
    show_content(output)
    getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Get the latest image
  latest_image = image_files.first
  image_name = File.basename(latest_image)

  # Display image info
  output = colorize_output("LATEST NPC IMAGE", :header) + "\n"
  output += colorize_output("─" * content_width, :header) + "\n\n"
  # Clear content for clean image display like RTFM
  @content.clear

  # Try to display the image inline
  image_displayed = false
  if display_terminal_image(latest_image)
    image_displayed = true
    debug "Image displayed using w3mimgdisplay"
  elsif system("which imgcat > /dev/null 2>&1")
    # Fallback to imgcat if available
    system("imgcat \"#{latest_image}\"")
    image_displayed = true
    debug "Image displayed using imgcat"
  elsif system("which kitty > /dev/null 2>&1")
    # Fallback to kitty if available
    system("kitty +kitten icat \"#{latest_image}\"")
    image_displayed = true
    debug "Image displayed using kitty"
  end

  if !image_displayed
    output += "Image file: " + latest_image.fg(39) + "\n\n"
    output += "(Install w3m-img, imgcat, or use kitty terminal for inline viewing)\n\n"
    show_content(output)
  else
    # Clear content pane when image is displayed to avoid text overlap
    @content.clear
  end

  # Show navigation options
  @footer.say(" [n] Next | [p] Previous | [d] Delete | [o] Open externally | [ESC/q] Back ".ljust(@cols))

  # Handle navigation through images
  current_index = 0
  loop do
    key = getchr
    case key
    when "ESC", "\e", "q", "LEFT"
      break
    when "n", "j", "DOWN"
      # Show next image (older)
      if current_index < image_files.length - 1
        current_index += 1
        latest_image = image_files[current_index]
        image_name = File.basename(latest_image)

        output = colorize_output("NPC IMAGE", :header) + " (#{current_index + 1}/#{image_files.length})\n"
        output += colorize_output("─" * content_width, :header) + "\n\n"
  # Clear content for clean image display like RTFM
  @content.clear

        display_terminal_image(latest_image) ||
          (system("which imgcat > /dev/null 2>&1") && system("imgcat \"#{latest_image}\"")) ||
          (system("which kitty > /dev/null 2>&1") && system("kitty +kitten icat \"#{latest_image}\""))
      end

    when "p", "k", "UP"
      # Show previous image (newer)
      if current_index > 0
        current_index -= 1
        latest_image = image_files[current_index]
        image_name = File.basename(latest_image)

        output = colorize_output("NPC IMAGE", :header) + " (#{current_index + 1}/#{image_files.length})\n"
        output += colorize_output("─" * content_width, :header) + "\n\n"
  # Clear content for clean image display like RTFM
  @content.clear

        display_terminal_image(latest_image) ||
          (system("which imgcat > /dev/null 2>&1") && system("imgcat \"#{latest_image}\"")) ||
          (system("which kitty > /dev/null 2>&1") && system("kitty +kitten icat \"#{latest_image}\""))
      end

    when "d", "D"
      # Delete current image
      confirm_text = colorize_output("DELETE IMAGE?", :error) + "\n\n"
      confirm_text += "Delete " + image_name.fg(196) + "?\n\n"
      confirm_text += "Press 'y' to confirm, any other key to cancel."
      show_content(confirm_text)

      if getchr.downcase == "y"
        File.delete(latest_image)
        image_files.delete_at(current_index)

        if image_files.empty?
          output = colorize_output("IMAGE DELETED", :success) + "\n\n"
          output += "No more images available.\n\n"
          output += "Press any key to continue..."
          show_content(output)
          getchr
          break
        else
          # Adjust index if needed
          current_index = [current_index, image_files.length - 1].min
          latest_image = image_files[current_index]
          image_name = File.basename(latest_image)

          output = colorize_output("IMAGE DELETED", :success) + "\n\n"
          output += colorize_output("NPC IMAGE", :header) + " (#{current_index + 1}/#{image_files.length})\n"
          output += colorize_output("─" * content_width, :header) + "\n\n"
  # Clear content for clean image display like RTFM
  @content.clear

          display_terminal_image(latest_image) ||
            (system("which imgcat > /dev/null 2>&1") && system("imgcat \"#{latest_image}\"")) ||
            (system("which kitty > /dev/null 2>&1") && system("kitty +kitten icat \"#{latest_image}\""))

          @footer.say(" [n] Next | [p] Previous | [d] Delete | [o] Open externally | [ESC/q] Back ".ljust(@cols))
        end
      else
        # Cancelled - redisplay current image
        output = colorize_output("NPC IMAGE", :header) + " (#{current_index + 1}/#{image_files.length})\n"
        output += colorize_output("─" * content_width, :header) + "\n\n"
  # Clear content for clean image display like RTFM
  @content.clear

        display_terminal_image(latest_image) ||
          (system("which imgcat > /dev/null 2>&1") && system("imgcat \"#{latest_image}\"")) ||
          (system("which kitty > /dev/null 2>&1") && system("kitty +kitten icat \"#{latest_image}\""))

        @footer.say(" [n] Next | [p] Previous | [d] Delete | [o] Open externally | [ESC/q] Back ".ljust(@cols))
      end

    when "o", "O"
      # Open in external viewer
      if system("which xdg-open > /dev/null 2>&1")
        system("xdg-open \"#{latest_image}\" 2>/dev/null &")
      elsif system("which open > /dev/null 2>&1")
        system("open \"#{latest_image}\" 2>/dev/null &")
      else
        output = "Cannot open image - no viewer available.\n"
        output += "Image path: #{latest_image}\n\n"
        output += "Press any key to continue..."
        show_content(output)
        getchr

        # Redisplay current image
        output = colorize_output("NPC IMAGE", :header) + " (#{current_index + 1}/#{image_files.length})\n"
        output += colorize_output("─" * content_width, :header) + "\n\n"
  # Clear content for clean image display like RTFM
  @content.clear

        display_terminal_image(latest_image) ||
          (system("which imgcat > /dev/null 2>&1") && system("imgcat \"#{latest_image}\"")) ||
          (system("which kitty > /dev/null 2>&1") && system("kitty +kitten icat \"#{latest_image}\""))
      end
    end
  end

  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

def show_latest_town_map
  debug "Starting show_latest_town_map"
  content_width = @cols - 35

  # Check saved directory
  save_dir = File.join($pgmdir || Dir.pwd, "saved")

  # Find all PNG files that match town relationship patterns
  png_files = Dir.glob(File.join(save_dir, "*.png")).select do |f|
    # Town relation PNGs are typically named after the town file (e.g., town.png, village1.png)
    # Exclude NPC images which typically have character names
    basename = File.basename(f, ".png")
    !basename.match?(/^[A-Z][a-z]+[A-Z]/) # Exclude CamelCase names (likely NPC images)
  end.sort_by { |f| File.mtime(f) }.reverse

  if png_files.empty?
    output = colorize_output("NO TOWN MAPS FOUND", :header) + "\n\n"
    output += "No town relationship maps have been generated yet.\n\n"
    output += "Use '7. Town Relations' to create a relationship map first.\n\n"
    output += "Press any key to continue..."
    show_content(output)
    getchr
  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
    return_to_menu
    return
  end

  # Get the latest map
  current_index = 0
  current_png = png_files[current_index]
  png_name = File.basename(current_png)

  # Check for corresponding text file (uses _relations.txt suffix)
  txt_file = current_png.sub(/\.png$/, '_relations.txt')

  # Start in image mode by default
  showing_image = true

  # Try to display the PNG inline first
  if display_terminal_image(current_png)
    @content.clear  # Clear any existing content
    debug "Town map displayed using w3mimgdisplay"
  elsif system("which imgcat > /dev/null 2>&1")
    @content.clear
    system("imgcat \"#{current_png}\"")
    debug "Town map displayed using imgcat"
  elsif system("which kitty > /dev/null 2>&1")
    @content.clear
    system("kitty +kitten icat \"#{current_png}\"")
    debug "Town map displayed using kitty"
  else
    # If no image display is available, show text instead
    showing_image = false
    output = colorize_output("TOWN RELATIONSHIP MAP", :header) + "\n"
    output += colorize_output("─" * content_width, :header) + "\n\n"
    output += "Map: " + colorize_output(png_name, :value) + "\n"
    output += "Generated: " + File.mtime(current_png).strftime("%Y-%m-%d %H:%M:%S").fg(240) + "\n"

    # Show text map if available
    if File.exist?(txt_file)
      output += "\n" + colorize_output("TEXT RELATIONSHIPS", :subheader) + "\n"
      output += "─" * content_width + "\n\n"

      txt_content = File.read(txt_file)
      txt_content.lines.each do |line|
        if line.include?("===")
          output += line.fg(10).b  # Bright green bold for strong alliance
        elsif line.include?("---")
          output += line.fg(196).b  # Bright red bold for deep hate
        elsif line.include?("+++")
          output += line.fg(226)  # Yellow for complex
        elsif line.include?("--")
          output += line.fg(160)  # Red for negative
        elsif line.include?("++")
          output += line.fg(82)  # Green for positive
        else
          output += line.fg(7)  # Normal white
        end
      end
    end
    show_content(output)
  end

  # Show navigation options
  @footer.say(" [n] Next | [p] Previous | [v] Toggle view | [o] Open externally | [d] Delete | [ESC/q] Back ".ljust(@cols))
  loop do
    key = getchr
    case key
    when "ESC", "\e", "q", "LEFT"
      break
    when "n", "j", "DOWN"
      # Show next map (older)
      if current_index < png_files.length - 1
        current_index += 1
        current_png = png_files[current_index]
        png_name = File.basename(current_png)
        txt_file = current_png.sub(/\.png$/, '_relations.txt')

        if showing_image
          # Display image only, no text
          if display_terminal_image(current_png)
            @content.clear
          elsif system("which imgcat > /dev/null 2>&1")
            @content.clear
            system("imgcat \"#{current_png}\"")
          elsif system("which kitty > /dev/null 2>&1")
            @content.clear
            system("kitty +kitten icat \"#{current_png}\"")
          end
        else
          # Display text info
          output = colorize_output("TOWN RELATIONSHIP MAP", :header) + " (#{current_index + 1}/#{png_files.length})\n"
          output += colorize_output("─" * content_width, :header) + "\n\n"
          output += "Map: " + colorize_output(png_name, :value) + "\n"
          output += "Generated: " + File.mtime(current_png).strftime("%Y-%m-%d %H:%M:%S").fg(240) + "\n"

          if File.exist?(txt_file)
            output += "\n" + colorize_output("TEXT RELATIONSHIPS", :subheader) + "\n"
            output += "─" * content_width + "\n\n"
            txt_content = File.read(txt_file)
            txt_content.lines.each do |line|
              if line.include?("===")
                output += line.fg(10).b
              elsif line.include?("---")
                output += line.fg(196).b
              elsif line.include?("+++")
                output += line.fg(226)
              elsif line.include?("--")
                output += line.fg(160)
              elsif line.include?("++")
                output += line.fg(82)
              else
                output += line.fg(7)
              end
            end
          end
          show_content(output)
        end
      end

    when "p", "k", "UP"
      # Show previous map (newer)
      if current_index > 0
        current_index -= 1
        current_png = png_files[current_index]
        png_name = File.basename(current_png)
        txt_file = current_png.sub(/\.png$/, '_relations.txt')

        if showing_image
          # Display image only, no text
          if display_terminal_image(current_png)
            @content.clear
          elsif system("which imgcat > /dev/null 2>&1")
            @content.clear
            system("imgcat \"#{current_png}\"")
          elsif system("which kitty > /dev/null 2>&1")
            @content.clear
            system("kitty +kitten icat \"#{current_png}\"")
          end
        else
          # Display text info
          output = colorize_output("TOWN RELATIONSHIP MAP", :header) + " (#{current_index + 1}/#{png_files.length})\n"
          output += colorize_output("─" * content_width, :header) + "\n\n"
          output += "Map: " + colorize_output(png_name, :value) + "\n"
          output += "Generated: " + File.mtime(current_png).strftime("%Y-%m-%d %H:%M:%S").fg(240) + "\n"

          if File.exist?(txt_file)
            output += "\n" + colorize_output("TEXT RELATIONSHIPS", :subheader) + "\n"
            output += "─" * content_width + "\n\n"
            txt_content = File.read(txt_file)
            txt_content.lines.each do |line|
              if line.include?("===")
                output += line.fg(10).b
              elsif line.include?("---")
                output += line.fg(196).b
              elsif line.include?("+++")
                output += line.fg(226)
              elsif line.include?("--")
                output += line.fg(160)
              elsif line.include?("++")
                output += line.fg(82)
              else
                output += line.fg(7)
              end
            end
          end
          show_content(output)
        end
      end

    when "v", "V"
      # Toggle between image and text view
      debug "Toggle pressed. showing_image=#{showing_image}"
      debug "current_png=#{current_png.inspect}"
      debug "current_index=#{current_index}"
      debug "png_name=#{png_name.inspect}"
      debug "txt_file=#{txt_file.inspect}"

      if showing_image
        debug "Switching from image to text view"
        # Switch to text view - must clear image overlay first
        clear_terminal_image  # Clear the image overlay like RTFM does
        showing_image = false
        debug "Image cleared, showing_image now=#{showing_image}"

        # Build the text output
        begin
          output = colorize_output("TOWN RELATIONSHIP MAP", :header) + " (#{current_index + 1}/#{png_files.length})\n"
          output += colorize_output("─" * content_width, :header) + "\n\n"
          output += "Map: " + colorize_output(png_name, :value) + "\n"
          output += "Generated: " + File.mtime(current_png).strftime("%Y-%m-%d %H:%M:%S").fg(240) + "\n"

          if File.exist?(txt_file)
            debug "Reading txt_file: #{txt_file}"
            output += "\n" + colorize_output("TEXT RELATIONSHIPS", :subheader) + "\n"
            output += "─" * content_width + "\n\n"
            txt_content = File.read(txt_file)
            txt_content.lines.each do |line|
              if line.include?("===")
                output += line.fg(10).b
              elsif line.include?("---")
                output += line.fg(196).b
              elsif line.include?("+++")
                output += line.fg(226)
              elsif line.include?("--")
                output += line.fg(160)
              elsif line.include?("++")
                output += line.fg(82)
              else
                output += line.fg(7)
              end
            end
          else
            debug "txt_file does not exist: #{txt_file}"
            output += "\n(No text file available for this map)\n"
          end

          @content.clear
          show_content(output)
          debug "Text content shown successfully"
        rescue => e
          debug "Error building text output: #{e.message}"
          debug "Backtrace: #{e.backtrace[0..5].join("\n")}"
        end
      else
        debug "Switching from text to image view"
        debug "Checking current_png: exists=#{File.exist?(current_png) rescue false}"
        # Switch to image view
        if current_png && File.exist?(current_png)
          debug "current_png exists, preparing to display"
          # Clear the content pane text first
          @content.text = ""
          @content.clear
          @content.refresh
          debug "Content pane cleared"

          if display_terminal_image(current_png)
            showing_image = true
            debug "Image displayed successfully with w3mimgdisplay"
          elsif system("which imgcat > /dev/null 2>&1")
            @content.clear
            system("imgcat \"#{current_png}\"")
            showing_image = true
            debug "Image displayed with imgcat"
          elsif system("which kitty > /dev/null 2>&1")
            @content.clear
            system("kitty +kitten icat \"#{current_png}\"")
            showing_image = true
            debug "Image displayed with kitty"
          else
            debug "No image display method available"
          end
          debug "showing_image now=#{showing_image}"
        else
          debug "Error: current_png is nil or doesn't exist: #{current_png}"
        end
      end
      debug "Toggle complete. Final showing_image=#{showing_image}"

    when "d", "D"
      # Delete current map
      confirm_text = colorize_output("DELETE MAP?", :error) + "\n\n"
      confirm_text += "Delete " + png_name.fg(196) + "?\n"
      confirm_text += "This will also delete the .txt file if it exists.\n\n"
      confirm_text += "Press 'y' to confirm, any other key to cancel."
      show_content(confirm_text)

      if getchr.downcase == "y"
        File.delete(current_png)
        File.delete(txt_file) if File.exist?(txt_file)
        png_files.delete_at(current_index)

        if png_files.empty?
          output = colorize_output("MAP DELETED", :success) + "\n\n"
          output += "No more maps available.\n\n"
          output += "Press any key to continue..."
          show_content(output)
          getchr
          break
        else
          # Adjust index if needed
          current_index = [current_index, png_files.length - 1].min
          current_png = png_files[current_index]
          png_name = File.basename(current_png)
          txt_file = current_png.sub(/\.png$/, '.txt')

          output = colorize_output("MAP DELETED", :success) + "\n\n"
          output += colorize_output("TOWN RELATIONSHIP MAP", :header) + " (#{current_index + 1}/#{png_files.length})\n"
          output += colorize_output("─" * content_width, :header) + "\n\n"
          output += "Map: " + colorize_output(png_name, :value) + "\n"
          output += "Generated: " + File.mtime(current_png).strftime("%Y-%m-%d %H:%M:%S").fg(240) + "\n\n"
          show_content(output)

          if showing_image
            if display_terminal_image(current_png)
              @content.clear
            elsif system("which imgcat > /dev/null 2>&1")
              system("imgcat \"#{current_png}\"")
            elsif system("which kitty > /dev/null 2>&1")
              system("kitty +kitten icat \"#{current_png}\"")
            end
          end
        end
      end

    when "o", "O"
      # Open in external viewer
      if system("which xdg-open > /dev/null 2>&1")
        system("xdg-open \"#{current_png}\" 2>/dev/null &")
      elsif system("which open > /dev/null 2>&1")
        system("open \"#{current_png}\" 2>/dev/null &")
      else
        show_content(@content.text + "\n\nCannot open image - no viewer available.\nImage path: #{current_png}")
      end
    end
  end

  # Restore menu selection
  @menu_index = saved_menu_index if defined?(saved_menu_index)
  return_to_menu
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end

debug "About to check if running as main"
debug "__FILE__ = #{__FILE__}"
debug "$0 = #{$0}"
debug "File.expand_path($0) = #{File.expand_path($0)}"

# START APPLICATION
# Check if we're being run directly (not loaded/required)
# Compare without extensions to handle both ./amar-tui and ./amar-tui.rb
file_without_ext = __FILE__.sub(/\.rb$/, '')
script_without_ext = File.expand_path($0).sub(/\.rb$/, '')
debug "Comparing: #{file_without_ext} == #{script_without_ext}"

if file_without_ext == script_without_ext
  debug "Starting application (called directly)"
  
  begin
    # Check if we have a proper terminal
    debug "Checking terminal status..."
    debug "stdin.tty? = #{$stdin.tty?}"
    debug "stdout.tty? = #{$stdout.tty?}"
    
    unless $stdin.tty? && $stdout.tty?
      debug "Not in interactive terminal, exiting"
      puts "Error: This application requires an interactive terminal"
      puts "Please run directly in a terminal, not piped or redirected"
      exit 1
    end
    
    debug "Terminal check passed, calling main_loop"
    main_loop
    debug "Application ended normally"
  rescue => e
    debug "Fatal error at top level: #{e.message}"
    debug e.backtrace.join("\n")
    puts "Fatal error: #{e.message}"
    raise
  end
else
  debug "Not running as main script, skipping startup"
  debug "This happens when __FILE__ != File.expand_path($0)"
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end
end

def reapply_colors(text)
  # Re-apply colors using rcurses string extensions
  lines = text.split("\n")
  colored_lines = lines.map do |line|
    case line
    when /^(\w+.*\([MF] \d+\).*H\/W:.*$)/
      # Character name line - bright cyan
      line.fg(14).b
    when /^(Description:.*$)/
      # Description line - light yellow
      line.fg(229)
    when /^(BODY|MIND|SPIRIT)\s*\(/
      # Characteristic headers - bright yellow
      line.gsub(/^(BODY|MIND|SPIRIT)/) { |match| match.fg(15).b }
    when /^\s+([A-Z][a-z]+)\s*\(/
      # Attribute names - bright magenta
      line.gsub(/^(\s+)([A-Z][a-z]+)/) { $1 + $2.fg(13) }
    when /^\s+[\w\s]+:\s*\d+$/
      # Skill lines - white
      line.fg(7)
    when /^(SIZE:.*BP:.*DB:.*MD:.*)/
      # Stats line - bright green
      line.fg(10).b
    when /^(ARMOR:|WEAPON|WEAPONS:|EQUIPMENT:)/
      # Weapons/armor/equipment - red
      line.fg(202).b
    else
      line
    end
  end

  colored_lines.join("\n")
end



def view_saved_file(filepath)
  content = File.read(filepath)
  filename = File.basename(filepath)
  
  show_content(content)
  @focus = :content
  @footer.say(" [j/↓] [k/↑] [PgUp/PgDn] Navigate | [ESC/q] Back ".ljust(@cols))
  
  loop do
    key = getchr
    case key
    when "ESC", "\e", "q", "LEFT"
      break
    when "j", "DOWN"
      @content.linedown
    when "k", "UP"
      @content.lineup
    when " ", "PgDOWN"
      @content.pagedown
    when "b", "PgUP"
      @content.pageup
    end
  end
rescue => e
  File.open("/tmp/rcurses_debug_amar.log", "a") { |f| f.puts "#{Time.now}: ERROR in view_saved_file: #{e.message}" }
  show_content("Error reading file: #{e.message}")
end

def browse_saved_files
  save_dir = "saved"

  # Get list of files (like RTFM's ls)
  files = Dir.glob("#{save_dir}/*").select { |f| File.file?(f) }

  if files.empty?
    show_content("No saved files found.\n\nGenerate some content first.")
    getchr
    return_to_menu
    return
  end

  @file_index = 0  # Current selection

  loop do
    # Display file list (like RTFM)
    output = ""
    files.each_with_index do |file, i|
      filename = File.basename(file)
      if i == @file_index
        output += "→ #{filename}\n"  # Selected file
      else
        output += "  #{filename}\n"
      end
    end

    show_content(output)
    @footer.say(" [↑↓] Navigate | [Enter] View | [ESC/q] Back ".ljust(@cols))

    key = getchr
    case key
    when "ESC", "\e", "q", "LEFT"
      break
    when "j", "DOWN"
      @file_index = (@file_index + 1) % files.length  # Wrap around
    when "k", "UP"
      @file_index = (@file_index - 1) % files.length  # Wrap around
    when "ENTER", "\r"
      # Show selected file content
      selected_file = files[@file_index]
      content = File.read(selected_file)
      @content.clear  # Clear right pane properly like RTFM
      show_content(content)
      @footer.say(" [j/↓] Down | [k/↑] Up | [ESC/q] Back ".ljust(@cols))

      # Simple file viewer
      loop do
        view_key = getchr
        case view_key
        when "ESC", "\e", "q", "LEFT"
          break  # Return to file list
        when "j", "DOWN"
          @content.linedown
        when "k", "UP"
          @content.lineup
        when " ", "PgDOWN"
          @content.pagedown
        when "b", "PgUP"
          @content.pageup
        end
      end
    end
  end

  return_to_menu
end
