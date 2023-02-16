#! /usr/bin/ruby
#encoding: utf-8

# Welcome to Amar Tools (https://github.com/isene/Amar-Tools)
# 
# This file is the umbrella for Amar Tools to work as CLI/terminal program.

@help = <<HELP
  
  Notes on the usage of NPC Generation for the Amar RPG 
  
  This program will only make sense to you if you know what role-playing games (RPGs) are. It is a useful asset to the Amar RPG.  
  
  The program is used for creating villages/towns/cities, random or specific encounters (basic details) or detailed NPC generation as well
  as random weather for a month. It can also generate relationship maps for inhabitants of a town or for a list of NPCs (with a graphical
  map showing the various positive and negative relations between them.
  
  There is also an Open Ended Dice roller for the Amar RPG (see the rules for what that is and how it is used in the game). That program is
  written in the nim programming language and compiled as a stand-alone executable called "O6". Simply put this in your path and you can
  throw an Open Ended Dice roll simply by running O6 on the command line..

  You may select or enter values in any of the NPC's characteristics.  Those you don't will be randomly generated. When you have selected/
  entered the values you want, press "submit", and the NPC will be generated.  

  When generating a town relationship map, you can upload a file with the same format as the one generated when creating a random town. The
  map will then have the name, basic info and the house number in an ellipse for each person that has a special relationship with others in
  the town.  Or you can simply upload a list of characters, one per line and every line with a special relationship will be paired with
  other lines in the file. A black line indicates a special positive relation, while a red line signifies a special negative relation. A
  double black line shows a strong alliance, while a double red shows deep hate. A black and a red line indicates a complex relationship. A
  graphical map is created as a .png file in the npcg directory.

  Press "v" when a town, encounters or an NPC is presented to edit the values in your default editor. The files for a detailed NPC
  (temp.npc), random encounter (encounter.npc), random town (town.npc) or random weather (weather.npc) is generated in the "npcs" directory
  under "npcg".
  
  Happy generation :) 
  
  Several abbreviations are used. They are easily deciphered if you read the Amar RPG rules.  
  
  The more obscure ones are: Spell Heading: A?=Active/Passive? Here a "+" means both Active and passive. R?=Resist? AoE="Area Of Effect",
  and we have A=Animal, C=Creature, D=Demon, E=Elemental, O=Object, S=Spell, U=Undead, W=Weapon. 
  
  The asterisk indicates that it will increase with the spell level. 1mr = 1 meter radius.  
  
  This program is licensed under the Gnu General Public License, Copyright 2002-2015, Geir Isene.
  
HELP

# Require the various modules needed
require 'date'
begin
  require 'optparse'
rescue
  puts "Ruby module 'optparse' is required. Please install: gem install optparse"
  exit
end
begin
  require 'tty-prompt'
rescue
  puts "Ruby module 'tty-prompt' is required. Please install: gem install tty-prompt"
  exit
end

$dark = true

# Handle options
options = {}
optparse = OptionParser.new do |opts|
  # Set a banner, displayed at the top of the help screen.
  opts.banner = "Usage: amar.rb [options]"

  # Define the options, and what they do
  opts.on('-e',     'Set Editor to use (default = less')             { |e| $editor = e }
  opts.on('-l',     'Use theme for terminals with light background') { $dark = false }
  opts.on('-h',     'Display SHORT help text')                       { puts opts; exit }
  opts.on('--help', 'Display LONG help text')                        { puts @help; exit }
  opts.on('-v',     '--version', 'Amar Tools version number')        { puts "Version = 1.2\n"; exit }
end
optparse.parse!

$editor = "less" if $editor == "" or $editor == nil

# Extend String Class to use colors
class String
  # colorization
  def c(code)
    "\e[38;5;#{code}m#{self}\e[0m"
  end
  def cb(code)
    "\e[38;5;#{code};1m#{self}\e[0m"
  end
  def ci(code)
    "\e[38;5;#{code};3m#{self}\e[0m"
  end
  def cu(code)
    "\e[38;5;#{code};4m#{self}\e[0m"
  end
end

# Define colors
$dark ? @A = 194 : @A = 29
$dark ? @e = 231 : @e = 65
$dark ? @E = 230 : @E = 64
$dark ? @n = 229 : @n = 29
$dark ? @N = 228 : @N = 28
$dark ? @t = 223 : @t = 59
$dark ? @r = 222 : @r = 58
$dark ? @m = 228 : @m = 94
$dark ? @w = 225 : @w = 57
@red  = 160
@gray = 240

prompt = TTY::Prompt.new

# Define a function to get OpenAI response
def openai(type)
  p = TTY::Prompt.new
  if type == "adv"
    cmd  = "openai -f " + __dir__ + "/adv.txt -x 2500"
  elsif type == "npc"
    fl = "temp.npc"
    f  = p.ask("\nEnter npc file name (default is the latest generated [temp.npc]):").to_s
    fl = f unless f == ""
    fl =  __dir__ + "/saved/" + fl
    text = File.read(__dir__ + "/npc.txt")
    cmd = "openai -t \"#{text}\" -f " + fl + " -x 2500"
  elsif type == "enc"
    fl = "encounter.npc"
    f  = p.ask("\nEnter encounter file name (default is the latest generated [encounter.npc]):").to_s
    fl = f unless f == ""
    fl =  __dir__ + "/saved/" + fl
    text = File.read(__dir__ + "/enc.txt")
    cmd = "openai -t \"#{text}\" -f " + fl + " -x 2500"
  end
  puts "\nGetting response from OpenAI... (quality may vary, use at your own discretion)\n".c(@gray)
  begin
    resp   = %x[#{cmd}]
    twidth = `tput cols`.to_i
    puts resp.gsub(/(.{1,#{twidth}})( +|$\n?)|(.{1,#{twidth}})/, "\\1\\3\n")
  rescue => error
    p error
    puts "\nYou need to install openai-term to use this feature (see https://github.com/isene/openai)"
  end
  p.keypress("\nPress any key...".c(@gray))
end

# Deal with the directory from which NPCg is run then the arguments
if File::symlink?($0)
    $pgmdir = File::dirname(File::expand_path(File::readlink($0), \
    File::dirname(File::expand_path($0))))
else
    $pgmdir = File::dirname(File::expand_path($0))
end

Dir.chdir($pgmdir)

# Include all core files via includes.rb
load "includes/includes.rb"

# Include all CLI modules
load "cli_npc_input.rb"
load "cli_npc_output.rb"
load "cli_enc_input.rb"
load "cli_enc_output.rb"
load "cli_town_input.rb"
load "cli_town_output.rb"
load "cli_name_gen.rb"
load "cli_weather_input.rb"
load "cli_weather_output.rb"

# Set initial global encounter default values
$Day = 1
$Terrain = 0
$Terraintype = 8
$Level = 0

# Data enters via an input module, is initialized and rendered by an output module.

loop do
  system "clear"
  puts "\nTools for the Amar RPG. Press a key to access the desired tool:\n\n"
  puts "A".cb(@A) + " = Generate an adventure from OpenAI".c(@A)
  puts "e".cb(@e) + " = Random encounter".c(@e)
  puts "E".cb(@E) + " = Generate a description for a random encounter".c(@E)
  puts "n".cb(@n) + " = Generate a detailed human NPC".c(@n)
  puts "N".cb(@N) + " = Generate a description for an NPC (via OpenAI)".c(@N)
  puts "t".cb(@t) + " = Create a village/town/city".c(@t)
  puts "r".cb(@r) + " = Make town relations".c(@r)
  puts "m".cb(@m) + " = Generate names".c(@m)
  puts "w".cb(@w) + " = Generate a month of weather".c(@w)
  puts "q".cb(@gray) + " = Quit npcg\n".c(@gray)
  c = prompt.keypress()
  # q = Quit
  if c == "q"
    puts ""
    break
  # A = Generate an adventure
  elsif c == "A"
    openai("adv")
  # e = Random Encounter
  elsif c == "e"
    ia = enc_input
    anENC = Enc.new(ia[0], ia[1])
    enc_output(anENC, "cli")
  # E = Generate Encounter description
  elsif c == "E"
    openai("enc")
  # n = Random NPC
  elsif c == "n"
    # Reload chartypes as it gets reworked every time
    load "includes/tables/chartype.rb"
    ia = npc_input
    aNPC = Npc.new(ia[0], ia[1], ia[2], ia[3], ia[4], ia[5], ia[6], ia[7], ia[8])
    npc_output(aNPC, "cli")
  # N = Generate NPC description
  elsif c == "N"
    openai("npc")
  # t = Random Town (castle/village/town/city)
  elsif c == "t"
    ia = town_input
    aTOWN = Town.new(ia[0], ia[1], ia[2])
    town_output(aTOWN, "cli")
  # r = Random relationship map
  elsif c == "r"
    town_file = __dir__ + "saved/town.npc"
    #Get town file name
    fl = prompt.ask("\nEnter town file name (default is the latest town generated [town.npc]):".c(@r))
    town_file = __dir__ + "/saved/" + fl unless fl == ""
    town_relations(town_file)
    town_dot2txt(town_file)
    prompt.keypress("\nPress any key...".c(@gray))
  # m = Random names
  elsif c == "m"
    name_gen
    prompt.keypress("\nPress any key...".c(@gray))
  # w = Random weather
  elsif c == "w"
    $weather_n = 1 if $weather_n == nil
    $wind_dir_n = 0 if $wind_dir_n == nil
    $wind_str_n = 0 if $wind_str_n == nil
    $mn = 0 if $mn == nil
    if $mn != 0
      $mn = (($mn + 1) % 14)
      $mn = 1 if $mn == 0
    end
    ia = weather_input
    $mn = ia[0]
    w = Weather_month.new(ia[0], ia[1], ia[2])
    $weather_n  = w.day[27].weather
    $wind_dir_n = w.day[27].wind_dir
    $wind_str_n = w.day[27].wind_str
    weather_output(w)
    weather_out_latex(w,"cli")
  end
end

# And that's all folks. G'day.
