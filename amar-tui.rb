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

def debug(msg)
  return unless $debug_log
  begin
    $debug_log.puts "[#{Time.now}] #{msg}"
    $debug_log.flush
  rescue => e
    # Silent fail if debug log fails
  end
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

debug "After includes load block"

# Test point after includes
debug "About to define configuration"

# CONFIGURATION
@config = {
  show_borders: true,
  color_mode: true,
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
debug "Help text defined"

# HELPER METHODS
debug "Defining helper methods"
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
  debug "Initializing screen..."
  
  begin
    debug "Calling Rcurses.init!"
    Rcurses.init!
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
    @header = Pane.new(   1,  1,  @cols,       1,          255,            234)  # Dark grey background
    debug "Creating menu pane"
    @menu   = Pane.new(   2,  3,  30,          @rows - 4,  255,            232)  # Black background
    debug "Creating content pane"
    @content= Pane.new(   34, 3,  @cols - 35,  @rows - 4,  255,            @colors[:content])
    debug "Creating footer pane"
    @footer = Pane.new(   1,  @rows, @cols,    1,          255,            234)  # Dark grey background
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
    "1. Generate NPC",
    "2. Generate Encounter", 
    "3. Generate Monster",
    "",
    "── LEGACY SYSTEM ──",
    "4. Old NPC Generator",
    "5. Old Encounter",
    "",
    "── WORLD BUILDING ──",
    "6. Town/City Generator",
    "7. Town Relations",
    "8. Weather Generator",
    "9. Name Generator",
    "",
    "── AI TOOLS ──",
    "A. Generate Adventure",
    "D. Describe Encounter",
    "N. Describe NPC",
    "",
    "── UTILITIES ──",
    "O. Roll Open Ended d6",
    "C. Color Mode",
    "H. Help",
    "Q. Quit"
  ]
  @menu_index = 1  # Start at first selectable item
  @focus = :menu   # Track which pane has focus (:menu or :content)

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

def recreate_panes
  # Store current content
  old_content = @content.text if @content

  # Get new dimensions
  @rows, @cols = IO.console.winsize

  # Clear screen
  print "\e[2J\e[H"  # Clear screen and move cursor home

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

def draw_header
  # Left justify the title text with padding
  title = " AMAR RPG TOOLS - The Ultimate Amar RPG Toolkit | [?] Help"
  @header.say(title)
end

def draw_menu
  menu_text = ""

  @menu_items.each_with_index do |item, idx|
    if item.empty? || item.start_with?("──")
      # Section header or blank
      if item.start_with?("──") && @config[:color_mode]
        # Different colors for different sections
        color = case item
                when /NEW 3-TIER/ then 42   # Green
                when /LEGACY/ then 23        # Dark cyan
                when /WORLD BUILDING/ then 131  # Brown/orange
                when /AI TOOLS/ then 103     # Light purple
                when /UTILITIES/ then 133    # Light magenta
                else 36  # Default cyan
                end
        menu_text += "\e[1;38;5;#{color}m#{item}\e[0m\n"
      else
        menu_text += item + "\n"
      end
    elsif idx == @menu_index
      # Highlighted item - RTFM style (bold arrow, underlined item)
      if @config[:color_mode]
        menu_text += "\e[1m→ \e[0m\e[4m#{item}\e[0m\n"  # Bold arrow, underlined item
      else
        menu_text += "→ \e[4m#{item}\e[0m\n"  # Underlined item
      end
    else
      menu_text += "  #{item}\n"
    end
  end

  @menu.say(menu_text)
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

def return_to_menu
  # Clear content first (without changing focus)
  @content.say("")
  @content.ix = 0

  # Then return focus to menu
  if @focus != :menu
    @focus = :menu
    update_border_colors if @config[:show_borders]
  end

  draw_footer
end

def draw_footer
  # Build footer with left-aligned help and right-aligned version
  help = " [↑↓] Navigate | [Enter] Select | [TAB] Switch Focus | [r] Refresh | [q] Quit"
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

def show_footer_message(message, duration = 0)
  # Show a temporary footer message without it being immediately overwritten
  @footer.clear
  @footer.say(" #{message}".ljust(@cols))
  sleep(duration) if duration > 0
end

def show_content(text)
  debug "show_content called with #{text.to_s.length} chars"
  debug "Color mode enabled: #{@config[:color_mode]}"

  # Switch focus to content pane when showing content
  if @focus != :content
    @focus = :content
    update_border_colors if @config[:show_borders]
  end

  # Check if text contains ANSI codes
  if text =~ /\e\[[0-9;]*m/
    debug "Text contains ANSI color codes"
    # Convert ANSI codes to rcurses color extensions if in color mode
    if @config[:color_mode]
      text = convert_ansi_to_rcurses(text)
      debug "After conversion: text has #{text.length} chars"
    else
      # Strip all ANSI codes if not in color mode
      text = text.gsub(/\e\[[0-9;]*m/, '')
    end
  else
    debug "No ANSI codes in input"
    # Text is already in the right format (plain or rcurses styled)
  end

  @content.say(text)
  @content.ix = 0
rescue => e
  debug "Error in show_content: #{e.message}"
  debug e.backtrace.join("\n") if e.backtrace
  raise
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

def show_help
  content_width = @cols - 35
  help_text = "AMAR RPG TOOLS - HELP\n"
  help_text += "─" * content_width + "\n\n"
  help_text += @help
  help_text += "\n\n" + "─" * content_width + "\n"
  help_text += "SCROLLING:\n"
  help_text += "  j / DOWN    - Scroll down\n"
  help_text += "  k / UP      - Scroll up\n"
  help_text += "  SPACE/PgDn  - Page down\n"
  help_text += "  b / PgUp    - Page up\n"
  help_text += "  g / HOME    - Go to top\n"
  help_text += "  G / END     - Go to bottom\n"
  help_text += "  ESC/q       - Return to menu\n"
  
  show_content(help_text)
  
  # Handle scrolling in content pane
  loop do
    key = getchr
    break if key == "ESC" || key == "q" || key == "\e"
    
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
  
  # Clear content when done
  show_content("")
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
    
  # Shortcuts
  when "1"
    generate_npc_new
  when "2"
    generate_encounter_new
  when "3"
    generate_monster_new
  when "4"
    generate_npc_old
  when "5"
    generate_encounter_old
  when "6"
    generate_town_ui
  when "7"
    generate_town_relations
  when "8"
    generate_weather_ui
  when "9"
    generate_name_ui
  when "a", "A"
    generate_adventure_ai
  when "d", "D"
    describe_encounter_ai
  when "n", "N"
    describe_npc_ai
  when "o", "O"
    roll_o6
  when "c", "C"
    toggle_colors
  when "h", "H"
    show_help
  when "r", "R"
    recreate_panes
  when "\t"  # Tab to switch focus
    @focus = (@focus == :menu) ? :content : :menu
    update_border_colors if @config[:show_borders]
  end
  
  true
end

def execute_menu_item
  item = @menu_items[@menu_index]
  debug "Executing menu item: #{item}"
  
  case item
  when /1\. Generate NPC/
    generate_npc_new
  when /2\. Generate Encounter/
    generate_encounter_new
  when /3\. Generate Monster/
    generate_monster_new
  when /4\. Old NPC/
    generate_npc_old
  when /5\. Old Encounter/
    generate_encounter_old
  when /6\. Town\/City/
    generate_town_ui
  when /7\. Town Relations/
    generate_town_relations
  when /8\. Weather/
    generate_weather_ui
  when /9\. Name/
    generate_name_ui
  when /A\. Generate Adventure/
    generate_adventure_ai
  when /D\. Describe Encounter/
    describe_encounter_ai
  when /N\. Describe NPC/
    describe_npc_ai
  when /O\. Roll Open Ended/
    roll_o6
  when /C\. Color Mode/
    toggle_colors
  when /H\. Help/
    show_help
  when /Q\. Quit/
    return false
  end
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

    roll_str = "\e[38;5;#{roll_color}m#{roll.to_s.rjust(3)}\e[0m"

    if roll >= 10
      results << "#{roll_str} " + "\e[38;5;46;1m(Critical!)\e[0m"
    elsif roll <= -3
      results << "#{roll_str} " + "\e[38;5;196;1m(Fumble!)\e[0m"
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
  getchr
  show_content("")
end

def toggle_colors
  @config[:color_mode] = !@config[:color_mode]
  refresh_all
  show_content("Color mode #{@config[:color_mode] ? 'enabled' : 'disabled'}")
end

# NPC GENERATION (NEW SYSTEM)
def generate_npc_new
  debug "Starting generate_npc_new"
  
  # Get inputs using the exact same logic as CLI
  ia = npc_input_new_tui
  if ia.nil?
    debug "User cancelled NPC generation"
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
    show_content(output)
    
    # Handle view with clipboard support
    handle_npc_view(npc, output)
  rescue => e
    debug "Error generating NPC: #{e.message}"
    debug e.backtrace.join("\n") if e.backtrace
    show_content("Error generating NPC: #{e.message}\n\n#{e.backtrace.join("\n")}")
  end
end

def npc_input_new_tui
  debug "Starting npc_input_new_tui"
  inputs = []
  
  # Name input
  debug "Getting name input"
  header = colorize_output("NEW SYSTEM NPC GENERATION (3-Tier)", :header) + "\n"
  header += colorize_output("=" * 60, :header) + "\n\n"
  header += colorize_output("Enter NPC name", :label) + " (or ENTER for random):\n\n"
  header += colorize_output("Press ESC to cancel", :info) + "\n\n"
  show_content(header)
  name = get_text_input(colorize_output("Name: ", :prompt))
  return nil if name == :cancelled
  inputs << (name || "")
  debug "Name input: #{name.inspect}"
  
  # Race selection
  races = [
    "Human", "Elf", "Half-elf", "Dwarf", "Goblin", "Lizard Man",
    "Centaur", "Ogre", "Troll", "Araxi", "Faerie"
  ]
  
  race_text = colorize_output("Select Race:", :header) + "\n\n"
  race_text += colorize_output("0", :dice) + ": " + colorize_output("Human", :value) + " (default)\n"
  races.each_with_index do |race, index|
    race_text += colorize_output((index + 1).to_s, :dice) + ": " + colorize_output(race, :value) + "\n"
  end
  race_text += "\n" + colorize_output("Press number key or ENTER for Human:", :prompt)
  
  show_content(race_text)
  key = getchr
  return nil if key == "ESC" || key == "\e"
  
  race = "Human"
  if key =~ /[1-9]/ || key == "0"
    race_idx = key.to_i
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
  
  type_text = "Character Types (#{types.length} available):\n\n0: Random\n"
  types.each_with_index do |type_name, index|
    type_text += "#{(index + 1).to_s.rjust(2)}: #{type_name}\n"
  end
  type_text += "\nEnter type number:"
  
  show_content(type_text)
  type_input = get_text_input("Type number: ")
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
  level_text = "Select character level:\n\n"
  level_text += "0: Random\n"
  level_text += "1: Novice\n"
  level_text += "2: Apprentice\n"
  level_text += "3: Journeyman\n"
  level_text += "4: Expert\n"
  level_text += "5: Master\n"
  level_text += "6: Grandmaster\n"
  level_text += "\nPress number key:"
  
  show_content(level_text)
  key = getchr
  return nil if key == "ESC" || key == "\e"
  
  level = key =~ /[0-6]/ ? key.to_i : 0
  inputs << level
  
  # Area selection
  area_text = "Select area of origin:\n\n"
  area_text += "0: Random\n"
  area_text += "1: Amaronir\n"
  area_text += "2: Merisir\n"
  area_text += "3: Calaronir\n"
  area_text += "4: Feronir\n"
  area_text += "5: Aleresir\n"
  area_text += "6: Rauinir\n"
  area_text += "7: Outskirts\n"
  area_text += "8: Other\n"
  area_text += "\nPress number key:"
  
  show_content(area_text)
  key = getchr
  return nil if key == "ESC" || key == "\e"
  
  areas = ["", "Amaronir", "Merisir", "Calaronir", "Feronir", "Aleresir", "Rauinir", "Outskirts", "Other"]
  area = key =~ /[0-8]/ ? areas[key.to_i] : ""
  inputs << area
  
  # Sex selection
  show_content("Select sex:\n\n0: Random\n1: Male\n2: Female\n\nPress number key:")
  key = getchr
  return nil if key == "ESC" || key == "\e"
  
  sex = case key
        when "1" then "M"
        when "2" then "F"
        else ""
        end
  inputs << sex
  
  # Age input
  show_content("Enter age (or ENTER/0 for random):")
  age_input = get_text_input("Age: ")
  return nil if age_input == :cancelled
  age = age_input.to_i
  inputs << age
  
  # Physical attributes
  show_content("Enter height in cm (or ENTER/0 for random):")
  height_input = get_text_input("Height: ")
  return nil if height_input == :cancelled
  height = height_input.to_i
  inputs << height
  
  show_content("Enter weight in kg (or ENTER/0 for random):")
  weight_input = get_text_input("Weight: ")
  return nil if weight_input == :cancelled
  weight = weight_input.to_i
  inputs << weight
  
  # Description
  show_content("Enter description (optional, ENTER to skip):")
  description = get_text_input("Description: ")
  return nil if description == :cancelled
  inputs << (description || "")
  
  inputs
end

def get_text_input(prompt)
  debug "get_text_input called with prompt: #{prompt}"
  footer_text = colorize_output(" Type input", :label) + " | "
  footer_text += colorize_output("[ENTER]", :success) + " Confirm | "
  footer_text += colorize_output("[ESC]", :error) + " Cancel"
  @footer.say(footer_text.ljust(@cols))

  input = ""
  cursor_pos = 0

  # Show prompt and input field
  @content.say(@content.text + "\n" + prompt)
  
  loop do
    key = getchr
    
    case key
    when "ESC", "\e"
      draw_footer
      return :cancelled
    when "ENTER", "\r"
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
    
    # Update display
    lines = @content.text.lines
    lines[-1] = prompt + input + "_"
    @content.say(lines.join)
  end
end

def handle_npc_view(npc, output)
  # Show instructions including clipboard copy
  @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))

  loop do
    key = getchr

    case key
    when "ESC", "\e", "q"
      break
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
      @footer.bg = 234  # Reset to dark grey
      sleep(1)
      @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
    when "e"
      # Edit in editor - strip ANSI codes first
      clean_text = output.respond_to?(:pure) ? output.pure : output.gsub(/\e\[\d+(?:;\d+)*m/, '')
      edit_in_editor(clean_text)
      show_content(output)
    when "r"
      # Re-roll with same parameters
      generate_npc_new
      break
    end
  end

  # Return focus to menu when done viewing
  return_to_menu
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

def edit_in_editor(text)
  debug "Opening output in editor"
  
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
    # Clean up terminal for editor
    Rcurses.end!  # Properly end rcurses
    system('clear')
    
    # Launch editor
    editor = ENV.fetch('EDITOR', 'vi')
    system("#{editor} #{tmpfile.path}")
    
    # Reinitialize rcurses
    Rcurses.init!
    Rcurses.clear
    
    # Refresh all panes
    init_screen
    refresh_all
    show_content(@content.text)  # Restore the content
    
    # Return the edited content if needed
    edited_text = File.read(tmpfile.path)
    return edited_text
  ensure
    tmpfile.unlink if tmpfile
  end
rescue => e
  debug "Error opening editor: #{e.message}"
  # Make sure to reinitialize rcurses even on error
  Rcurses.init!
  init_screen
  refresh_all
  nil
end

# ENCOUNTER GENERATION (NEW SYSTEM) 
def generate_encounter_new
  debug "Starting generate_encounter_new"
  
  # Get inputs using same logic as CLI
  ia = enc_input_new_tui
  if ia.nil?
    debug "User cancelled encounter generation"
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

def enc_input_new_tui
  debug "Starting enc_input_new_tui"
  
  # Initialize defaults
  $Day = 1 if $Day.nil?
  $Terrain = 1 if $Terrain.nil?
  $Level = 0 if $Level.nil?
  
  # Get night/day
  show_content("NEW SYSTEM ENCOUNTER GENERATION\n" + "=" * 60 + "\n\nSelect time:\n\n0: Night\n1: Day (default)\n\nPress number key:")
  key = getchr
  return nil if key == "ESC" || key == "\e"
  
  $Day = key == "0" ? 0 : 1
  debug "Day/Night: #{$Day}"
  
  # Get terrain
  terrain_text = "Select terrain type:\n\n"
  terrain_text += "0: City\n1: Rural\n2: Road\n3: Plains\n4: Hills\n"
  terrain_text += "5: Mountains\n6: Woods\n7: Wilderness\n\nPress number key:"
  
  show_content(terrain_text)
  key = getchr
  return nil if key == "ESC" || key == "\e"
  
  $Terrain = key =~ /[0-7]/ ? key.to_i : 1
  $Terraintype = $Terrain + (8 * $Day)
  debug "Terrain: #{$Terrain}, Terraintype: #{$Terraintype}"
  
  # Get level modifier
  show_content("Enter level modifier (+/-):\n\nPress number key (0-9) for positive\nOr '-' then number for negative\nOr ENTER for 0:")
  level_input = get_text_input("Level modifier: ")
  return nil if level_input == :cancelled
  
  $Level = level_input.to_i if level_input
  debug "Level modifier: #{$Level}"
  
  # Race selection for humanoid encounters
  races = [
    "Human", "Elf", "Half-elf", "Dwarf", "Goblin", "Lizard Man",
    "Centaur", "Ogre", "Troll", "Araxi", "Faerie"
  ]
  
  race_text = "Select race (for humanoid encounters):\n\n0: Random (default)\n"
  races.each_with_index do |race, index|
    race_text += "#{index + 1}: #{race}\n"
  end
  race_text += "\nPress number key:"
  
  show_content(race_text)
  key = getchr
  return nil if key == "ESC" || key == "\e"
  
  race = ""
  if key =~ /[1-9]/
    race_idx = key.to_i
    race = races[race_idx - 1] if race_idx <= races.length
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
  
  # For simplicity in TUI, we'll just use random for now
  # Full implementation would show encounter list like CLI
  
  show_content("Generate random encounter?\n\nPress ENTER for yes, ESC to cancel")
  key = getchr
  return nil if key == "ESC" || key == "\e"
  
  [encounter, enc_number, $Terraintype, $Level]
end

def handle_encounter_view(enc, output)
  # Show instructions including clipboard copy
  @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
  
  loop do
    key = getchr
    
    case key
    when "ESC", "\e", "q"
      break
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
      @footer.bg = 234  # Reset to dark grey
      sleep(1)
      @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
    when "e"
      # Edit in editor - strip ANSI codes first
      clean_text = output.respond_to?(:pure) ? output.pure : output.gsub(/\e\[\d+(?:;\d+)*m/, '')
      edit_in_editor(clean_text)
      show_content(output)
    when "r"
      # Re-roll with same parameters
      generate_encounter_new
      break
    end
  end

  # Return focus to menu when done viewing
  return_to_menu
end

def format_npc_new(npc)
  content_width = @cols - 35
  output = "NPC: #{npc.name} (#{npc.sex}, #{npc.age})\n"
  output += "Type: #{npc.type} | Level: #{npc.level}\n"
  output += "─" * content_width + "\n\n"
  
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

def handle_content_view(object, type)
  # Show scrolling instructions in footer
  @footer.say(" [j/↓] Down | [k/↑] Up | [SPACE] PgDn | [b] PgUp | [g] Top | [G] Bottom | [ESC/q] Back ".ljust(@cols))
  
  loop do
    key = getchr
    
    case key
    when "ESC", "\e", "q"  # ESC or q to go back
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
      edit_in_editor(@content.text)
    end
  end
  
  # Restore normal footer
  draw_footer
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

# COLOR FORMATTING HELPERS
def colorize_output(text, type = :default)
  return text unless @config[:color_mode]
  
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
    text.fg(10).b  # Bright green bold
  when :dice
    text.fg(202)   # Orange
  when :name
    text.fg(15).b  # Bright white bold
  else
    text
  end
end

# DICE ROLLER
def roll_dice_ui
  show_popup("DICE ROLLER", "Enter dice notation (e.g., 3d6+2):\n\nOr press ESC to cancel")
  
  # Simple dice roller implementation
  dice_input = ""
  loop do
    key = getchr
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
  debug "Starting generate_monster_new"
  
  # Load monster stats if not loaded
  unless defined?($MonsterStats)
    debug "Loading monster_stats_new.rb"
    load File.join($pgmdir, "includes/tables/monster_stats_new.rb")
  end
  
  # Get monster type selection
  monster_list = $MonsterStats.keys.reject { |k| k == "default" }.sort
  
  monster_text = "NEW SYSTEM MONSTER GENERATION\n" + "=" * 60 + "\n\n"
  monster_text += "Select monster type:\n\n0: Random\n"
  
  # Display in columns for better readability
  monster_list.each_with_index do |monster, index|
    monster_text += "#{(index + 1).to_s.rjust(2)}: #{monster.capitalize.ljust(20)}"
    monster_text += "\n" if (index + 1) % 3 == 0
  end
  monster_text += "\n" if monster_list.length % 3 != 0
  monster_text += "\nPress number or ENTER for random:"
  
  show_content(monster_text)
  monster_input = get_text_input("Monster number: ")
  return if monster_input == :cancelled
  
  # Select monster
  monster_type = ""
  if monster_input && monster_input.to_i > 0 && monster_input.to_i <= monster_list.length
    monster_type = monster_list[monster_input.to_i - 1]
  else
    monster_type = monster_list.sample
  end
  
  debug "Selected monster: #{monster_type}"
  
  # Get level
  show_content("Select monster level:\n\n0: Random\n1-6: Specific level\n\nPress number key:")
  key = getchr
  return if key == "ESC" || key == "\e"
  
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

def handle_monster_view(monster, output)
  @footer.say(" [j/↓] Down | [k/↑] Up | [SPACE] PgDn | [y] Copy to clipboard | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
  
  loop do
    key = getchr
    
    case key
    when "ESC", "\e", "q"
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
      @footer.bg = 234  # Reset to dark grey
      sleep(1)
      @footer.say(" [j/↓] Down | [k/↑] Up | [SPACE] PgDn | [y] Copy to clipboard | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
    when "r"
      generate_monster_new
      break
    end
  end

  # Return focus to menu when done viewing
  return_to_menu
end

def format_monster_new(monster)
  output = ""
  content_width = @cols - 35  # Same as content pane width

  if @config[:color_mode]
    output += colorize_output("#{monster.name}", :success) + colorize_output(" (#{monster.type}, Level #{monster.level})", :value) + "\n"
    output += colorize_output("─" * content_width, :header) + "\n\n"

    # Physical stats - ensure integers
    size_val = monster.SIZE.is_a?(Float) ? monster.SIZE.round : monster.SIZE
    bp_val = monster.BP.is_a?(Float) ? monster.BP.round : monster.BP
    db_val = monster.DB.is_a?(Float) ? monster.DB.round : monster.DB
    md_val = monster.MD.is_a?(Float) ? monster.MD.round : monster.MD

    output += colorize_output("SIZE: ", :label) + colorize_output(size_val.to_s, :value)
    output += "  " + colorize_output("BP: ", :label) + colorize_output(bp_val.to_s, :dice)
    output += "  " + colorize_output("DB: ", :label) + colorize_output(db_val.to_s, :dice)
    output += "  " + colorize_output("MD: ", :label) + colorize_output(md_val.to_s, :dice) + "\n"
    output += colorize_output("Weight: ", :label) + colorize_output("#{monster.weight.round} kg", :value) + "\n\n"
    
    # Special abilities
    if monster.special_abilities && !monster.special_abilities.empty?
      output += colorize_output("SPECIAL ABILITIES:", :subheader) + "\n"
      output += "  " + colorize_output(monster.special_abilities, :success) + "\n\n"
    end
    
    # Weapons/Attacks
    output += colorize_output("WEAPONS/ATTACKS:", :subheader) + "\n"
    output += colorize_output("Attack".ljust(18), :label) + colorize_output("Skill  Init  Off  Def  Damage", :label) + "\n"
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
        attack_name = skill.capitalize.ljust(15)
      else
        # Other weapons
        init = 4
        off = total + 1
        def_val = total + 1
        damage = db + 2
        attack_name = skill.capitalize.ljust(15)
      end

      output += colorize_output(attack_name, :value)
      output += colorize_output("#{total.to_s.rjust(5)}  #{init.to_s.rjust(4)}  #{off.to_s.rjust(3)}  #{def_val.to_s.rjust(3)}  #{damage.to_s.rjust(6)}", :value) + "\n"
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
    size_val = monster.SIZE.is_a?(Float) ? monster.SIZE.round : monster.SIZE
    bp_val = monster.BP.is_a?(Float) ? monster.BP.round : monster.BP
    db_val = monster.DB.is_a?(Float) ? monster.DB.round : monster.DB
    md_val = monster.MD.is_a?(Float) ? monster.MD.round : monster.MD

    output += "SIZE: #{size_val}  BP: #{bp_val}  DB: #{db_val}  MD: #{md_val}\n"
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
        attack_name = skill.capitalize.ljust(15)
      else
        init = 4
        off = total + 1
        def_val = total + 1
        damage = db + 2
        attack_name = skill.capitalize.ljust(15)
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

# NPC GENERATION (OLD SYSTEM)
def generate_npc_old
  show_content("Generating NPC (Old System)...\n\nPress any key to continue\nOr ESC to cancel")
  
  key = getchr
  return if key == "\e"
  
  begin
    # Use the old system - with proper error handling
    npc_string = ""
    begin
      # Try to run the external command with proper escaping
      cmd = "ruby '#{File.join($pgmdir, "randomizer.rb")}' npc 2>/dev/null"
      npc_string = `#{cmd}`
      if npc_string.empty? || $?.exitstatus != 0
        # Fallback if external command fails
        npc_string = "Old NPC Generator\n" + "=" * 40 + "\n\n"
        npc_string += "Error: Could not run external randomizer.\n"
        npc_string += "Please ensure randomizer.rb exists in:\n"
        npc_string += "#{$pgmdir}\n"
      end
    rescue => e
      debug "Error running randomizer: #{e.message}"
      npc_string = "Error generating NPC: #{e.message}"
    end
    show_content(npc_string)
    
    # Simple navigation for old system output
    loop do
      key = getchr
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
  
  key = getchr
  return if key == "\e"
  
  begin
    # Use the old system - with proper error handling
    enc_string = ""
    begin
      # Try to run the external command with proper escaping
      cmd = "ruby '#{File.join($pgmdir, "randomizer.rb")}' enc 2>/dev/null"
      enc_string = `#{cmd}`
      if enc_string.empty? || $?.exitstatus != 0
        # Fallback if external command fails
        enc_string = "Old Encounter Generator\n" + "=" * 40 + "\n\n"
        enc_string += "Error: Could not run external randomizer.\n"
        enc_string += "Please ensure randomizer.rb exists in:\n"
        enc_string += "#{$pgmdir}\n"
      end
    rescue => e
      debug "Error running randomizer: #{e.message}"
      enc_string = "Error generating encounter: #{e.message}"
    end
    show_content(enc_string)
    
    # Simple navigation
    loop do
      key = getchr
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
  debug "Starting generate_weather_ui"
  
  # Initialize weather globals if needed
  $weather_n = 1 if $weather_n.nil?
  $wind_dir_n = 0 if $wind_dir_n.nil?
  $wind_str_n = 0 if $wind_str_n.nil?
  $mn = 0 if $mn.nil?
  
  if $mn != 0
    $mn = (($mn + 1) % 14)
    $mn = 1 if $mn == 0
  end
  
  # Get Month
  mstring = "\nSelect month:\n\n"
  7.times do |i|
    mstring += "#{i.to_s.rjust(2)}: #{$Month[i]}".ljust(20)
    mstring += "#{(i+7).to_s.rjust(2)}: #{$Month[i+7]}\n"
  end
  mstring += "\nEnter month (default=#{$mn}):"
  
  show_content(mstring)
  month_input = get_text_input("Month: ")
  return if month_input == :cancelled
  
  month = month_input.to_i
  month = $mn if month_input.nil? || month_input.empty?
  month = 0 if month < 0
  month = 13 if month > 13
  $mn = month
  
  # Get weather conditions
  weather_text = "\n" + colorize_output("Select weather conditions:", :header) + "\n\n"
  weather_text += colorize_output(" 1", :dice) + ": " + colorize_output("Arctic", :value) + "\n"
  weather_text += colorize_output(" 2", :dice) + ": " + colorize_output("Winter", :value) + "\n"
  weather_text += colorize_output(" 3", :dice) + ": " + colorize_output("Cold", :value) + "\n"
  weather_text += colorize_output(" 4", :dice) + ": " + colorize_output("Cool", :value) + "\n"
  weather_text += colorize_output(" 5", :dice) + ": " + colorize_output("Normal", :value) + " (default)\n"
  weather_text += colorize_output(" 6", :dice) + ": " + colorize_output("Warm", :value) + "\n"
  weather_text += colorize_output(" 7", :dice) + ": " + colorize_output("Hot", :value) + "\n"
  weather_text += colorize_output(" 8", :dice) + ": " + colorize_output("Very hot", :value) + "\n"
  weather_text += colorize_output(" 9", :dice) + ": " + colorize_output("Extreme heat", :value) + "\n"
  weather_text += "\n" + colorize_output("Enter weather condition", :label) + " (default=#{$weather_n}):\n\n"

  show_content(@content.text + weather_text)
  weather_input = get_text_input(colorize_output("Weather: ", :prompt))
  return if weather_input == :cancelled
  
  weather = weather_input.to_i
  weather = $weather_n if weather_input.nil? || weather_input.empty?
  weather = 1 if weather < 1
  weather = 9 if weather > 9
  
  # Get wind
  wind_text = "\n" + colorize_output("Select wind conditions:", :header) + "\n\n"
  wind_text += colorize_output("Wind Direction:", :subheader) + "\n"
  wind_text += colorize_output(" 0", :dice) + ": N   " + colorize_output("1", :dice) + ": NE   "
  wind_text += colorize_output("2", :dice) + ": E   " + colorize_output("3", :dice) + ": SE\n"
  wind_text += colorize_output(" 4", :dice) + ": S   " + colorize_output("5", :dice) + ": SW   "
  wind_text += colorize_output("6", :dice) + ": W   " + colorize_output("7", :dice) + ": NW\n\n"
  wind_text += colorize_output("Wind Strength:", :subheader) + "\n"
  wind_text += colorize_output(" 0", :dice) + ": Calm   " + colorize_output("8", :dice) + ": Light   "
  wind_text += colorize_output("16", :dice) + ": Medium   " + colorize_output("24", :dice) + ": Strong\n\n"
  wind_text += colorize_output("Enter combined value", :label) + " (0-31, default=#{$wind_dir_n + $wind_str_n * 8}):\n\n"

  show_content(@content.text + wind_text)
  wind_input = get_text_input(colorize_output("Wind: ", :prompt))
  return if wind_input == :cancelled
  
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
    output += "\n" + colorize_output("WEATHER FOR #{$Month[month].upcase}", :header) + "\n\n"
    
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
      
      # Day number
      line += colorize_output((i+1).to_s.rjust(2), :label)
      line += ": "
      
      # Weather description with enhanced gradient coloring
      weather_text = $Weather[d.weather]
      weather_ansi = case weather_text
                     when /blizzard/i then "\e[38;5;231;1m"      # Bold white for blizzard
                     when /snow/i then "\e[38;5;255m"             # White for snow
                     when /hail/i then "\e[38;5;253m"             # Light gray for hail
                     when /thunder|lightning/i then "\e[38;5;226;1m" # Bold yellow for thunder
                     when /storm/i then "\e[38;5;202;1m"          # Bold orange for storm
                     when /heavy rain/i then "\e[38;5;21m"        # Deep blue for heavy rain
                     when /rain/i then "\e[38;5;33m"              # Blue for rain
                     when /drizzle/i then "\e[38;5;111m"          # Light blue for drizzle
                     when /fog/i then "\e[38;5;248m"              # Gray for fog
                     when /mist/i then "\e[38;5;251m"             # Light gray for mist
                     when /overcast/i then "\e[38;5;243m"         # Dark gray for overcast
                     when /cloudy/i then "\e[38;5;247m"           # Medium gray for cloudy
                     when /partly cloudy/i then "\e[38;5;250m"    # Light gray for partly cloudy
                     when /sunny|clear/i then "\e[38;5;226m"      # Yellow for sunny
                     when /warm/i then "\e[38;5;214m"             # Orange for warm
                     when /hot/i then "\e[38;5;196m"              # Red for hot
                     when /cold/i then "\e[38;5;51m"              # Cyan for cold
                     when /cool/i then "\e[38;5;117m"             # Light cyan for cool
                     else "\e[38;5;255m"                          # Default white
                     end
      line += weather_ansi + weather_text + "\e[0m"
      
      # Add weather symbol
      weather_symbols.each do |key, sym|
        if weather_text.include?(key)
          line += colorize_output(" #{sym}", :dice)
          break
        end
      end
      
      line += ". "
      
      # Wind with shades of blue based on strength
      wind_color = case d.wind_str
                   when 0..7 then 117    # Light blue
                   when 8..15 then 75    # Medium blue
                   when 16..23 then 33   # Darker blue
                   else 21               # Deep blue
                   end
      line += "\e[38;5;#{wind_color}m#{$Wind_str[d.wind_str]}\e[0m"

      if d.wind_str != 0
        line += " "
        line += "\e[38;5;#{wind_color}m(#{$Wind_dir[d.wind_dir]})\e[0m"
      end
      
      # Calculate remaining space for special/moon (use pure for length calculation)
      current_length = line.pure.length
      
      # Add special days
      if d.special && !d.special.empty?
        padding = [60 - current_length, 1].max
        line += " " * padding
        line += colorize_output("★ #{d.special}", :success)
        current_length = line.pure.length
      end
      
      # Add moon phases with symbols
      if month != 0 && moon_symbols.key?(i)
        moon_text = case i
                   when 0 then "#{moon_symbols[0]} New"
                   when 7 then "#{moon_symbols[7]} Waxing"
                   when 14 then "#{moon_symbols[14]} Full"
                   when 21 then "#{moon_symbols[21]} Waning"
                   end
        padding = [78 - current_length, 1].max
        line += " " * padding
        line += colorize_output(moon_text, :header)
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
    @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [ESC/q] Back ".ljust(@cols))
    
    loop do
      key = getchr
      case key
      when "\e", "q"
        break
      when "j", "DOWN"
        @content.linedown
      when "k", "UP"
        @content.lineup
      when " ", "PgDOWN"
        @content.pagedown
      when "PgUP"
        @content.pageup
      when "y"
        copy_to_clipboard(output)
        @footer.clear
        @footer.say(" Copied to clipboard! ".ljust(@cols))
        sleep(1)
        @footer.clear
        @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [ESC/q] Back ".ljust(@cols))
      when "e"
        # Edit in editor - strip ANSI codes first
        clean_text = output.respond_to?(:pure) ? output.pure : output.gsub(/\e\[\d+(?:;\d+)*m/, '')
        edit_in_editor(clean_text)
        show_content(output)
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
  debug "Starting generate_town_ui"
  
  # Get Town name
  header = colorize_output("TOWN/CITY GENERATOR", :header) + "\n"
  header += colorize_output("═" * 60, :header) + "\n\n"
  header += colorize_output("Enter Village/Town/City name", :label) + " (or ENTER for random):\n\n"
  show_content(header)
  town_name = get_text_input(colorize_output("Name: ", :prompt))
  return if town_name == :cancelled
  town_name = "" if town_name.nil?
  
  # Get Town size
  prompt_text = "\n" + colorize_output("Enter number of houses", :label)
  prompt_text += " (1-1000, default=1):\n\n"
  show_content(@content.text + prompt_text)
  size_input = get_text_input(colorize_output("Houses: ", :prompt))
  return if size_input == :cancelled
  town_size = size_input.to_i
  town_size = 1 if town_size < 1
  
  # Get Town variations
  var_text = "\n" + colorize_output("Select race variation:", :header) + "\n\n"
  var_text += colorize_output("0", :dice) + ": " + colorize_output("Only humans", :value) + " (default)\n"
  var_text += colorize_output("1", :dice) + ": " + colorize_output("Few non-humans", :value) + "\n"
  var_text += colorize_output("2", :dice) + ": " + colorize_output("Several non-humans", :value) + "\n"
  var_text += colorize_output("3", :dice) + ": " + colorize_output("Crazy place", :value) + "\n"
  var_text += colorize_output("4", :dice) + ": " + colorize_output("Only Dwarves", :value) + "\n"
  var_text += colorize_output("5", :dice) + ": " + colorize_output("Only Elves", :value) + "\n"
  var_text += colorize_output("6", :dice) + ": " + colorize_output("Only Lizardfolk", :value) + "\n\n"
  show_content(@content.text + var_text)
  var_input = get_text_input(colorize_output("Variation: ", :prompt))
  return if var_input == :cancelled
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
    saved_dir = File.join($pgmdir, "saved")
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

  # Refresh all panes to ensure UI is properly displayed
  @menu.refresh
  @content.refresh

  # Show navigation help
  @footer.clear
  @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))

  # Navigation
  loop do
    key = getchr
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

        # Restore navigation help
        @footer.clear
        @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
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
        @footer.say(" [j/↓] Down | [k/↑] Up | [y] Copy | [e] Edit | [r] Re-roll | [ESC/q] Back ".ljust(@cols))
      when "e"
        # Edit in editor - strip ANSI codes first
        clean_text = @content.text.respond_to?(:pure) ? @content.text.pure : @content.text.gsub(/\e\[\d+(?:;\d+)*m/, '')
        edit_in_editor(clean_text)
        @content.say(@content.text)
      when "s"
        save_to_file(@content.text, :town)
    end
  end
rescue => e
  show_content("Error generating town: #{e.message}")
end

# NAME GENERATOR
def generate_name_ui
  # Use the actual name types from the $Names table
  menu_text = colorize_output("SELECT NAME TYPE:", :header) + "\n"
  content_width = @cols - 35
  menu_text += colorize_output("─" * content_width, :header) + "\n\n"
  
  $Names.each_with_index do |name_type, idx|
    menu_text += colorize_output("#{idx.to_s.rjust(2)}: ", :label) + colorize_output(name_type[0], :value) + "\n"
  end
  menu_text += "\nPress number to select or ESC to cancel"
  
  show_content(menu_text)
  
  key = getchr
  return if key == "\e"
  
  # Handle two-digit input
  input = key
  if key =~ /\d/
    # Wait for possible second digit
    second = getchr
    if second =~ /\d/
      input = key + second
    elsif second != "\r" && second != "\n"
      # Not a digit or enter, treat as single digit
      # Put the second key back somehow or just ignore
    end
  end
  
  idx = input.to_i
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
    
    # Navigation
    loop do
      key = getchr
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

# TOWN RELATIONS
def generate_town_relations
  debug "Starting generate_town_relations"
  
  # Check for saved town files
  saved_dir = File.join($pgmdir, "saved")
  default_file = File.join(saved_dir, "town.npc")
  
  content_width = @cols - 35
  show_content("\nTown Relations Generator\n\n" + "─" * content_width + "\n\n")
  
  # Ask for town file
  show_content("Enter town file name (default is the latest town generated [town.npc]):")
  file_input = get_text_input("File name: ")
  return if file_input == :cancelled
  
  if file_input.nil? || file_input.empty?
    town_file = default_file
  else
    town_file = File.join(saved_dir, file_input)
  end
  
  begin
    unless File.exist?(town_file)
      show_content("\nError: File '#{town_file}' not found.\n\nPress any key to continue...")
      getchr
      return
    end
    
    show_content("\nGenerating relationship map...\n")
    
    # Capture output
    output_io = StringIO.new
    original_stdout = $stdout
    $stdout = output_io
    
    # Generate relations
    town_relations(town_file)
    town_dot2txt(town_file)
    
    $stdout = original_stdout
    output = output_io.string
    
    # Show the text output with coloring
    txt_file = town_file.sub(/\.npc$/, '.txt')
    if File.exist?(txt_file)
      raw_output = File.read(txt_file)
      # Add coloring to relationship map
      colored_output = colorize_output("RELATIONSHIP MAP", :header) + "\n"
      colored_output += colorize_output("─" * content_width, :header) + "\n\n"
      colored_output += raw_output
      show_content(colored_output)
    else
      show_content("\nRelationship map generated.\n")
    end

    # Navigation
    @footer.clear
    @footer.say(" [j/↓] Down | [k/↑] Up | [e] Edit | [ESC/q] Back ".ljust(@cols))
    
    loop do
      key = getchr
      case key
      when "\e", "q"
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
        # Edit in editor - strip ANSI codes first
        clean_text = @content.text.respond_to?(:pure) ? @content.text.pure : @content.text.gsub(/\e\[\d+(?:;\d+)*m/, '')
        edit_in_editor(clean_text)
        show_content(@content.text)
      end
    end
    
  rescue => e
    show_content("\nError generating relations: #{e.message}\n\nPress any key to continue...")
    getchr
  end
  
  draw_footer
end

# AI FEATURES
def generate_adventure_ai
  content_width = @cols - 35
  show_content("AI Adventure Generator\n\n" + "─" * content_width + "\n\n")
  show_content("This feature would use OpenAI to generate adventures.\n\nRequires OpenAI API key configuration.\n\nNot yet implemented in TUI version.\n\nPress any key to continue...")
  getchr
  show_content("")
end

def describe_encounter_ai
  content_width = @cols - 35
  show_content("AI Encounter Description\n\n" + "─" * content_width + "\n\n")
  show_content("This feature would use OpenAI to describe encounters.\n\nRequires OpenAI API key configuration.\n\nNot yet implemented in TUI version.\n\nPress any key to continue...")
  getchr
  show_content("")
end

def describe_npc_ai
  content_width = @cols - 35
  show_content("AI NPC Description\n\n" + "─" * content_width + "\n\n")
  show_content("This feature would use OpenAI to describe NPCs.\n\nRequires OpenAI API key configuration.\n\nNot yet implemented in TUI version.\n\nPress any key to continue...")
  getchr
  show_content("")
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
end