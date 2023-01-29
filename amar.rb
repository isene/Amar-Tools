#! /usr/bin/ruby
#encoding: utf-8

# Welcome to Amar Tools (https://github.com/isene/Amar-Tools)
# 
# This file is the umbrella for Amar Tools to work as CLI/terminal program.

# First define a function to get single character input
def get_char
    # save previous state of stty
    old_state = `stty -g`
    # disable echoing and enable raw (not having to press enter)
    system "stty raw -echo"
    c = STDIN.getc.chr
    # restore previous state of stty
    system "stty #{old_state}"
    return c
end

# Deal with the directory from which NPCg is run then the arguments
if File::symlink?($0)
    $pgmdir = File::dirname(File::expand_path(File::readlink($0), \
    File::dirname(File::expand_path($0))))
else
    $pgmdir = File::dirname(File::expand_path($0))
end

Dir.chdir($pgmdir)

# Help output
if ARGV.include?("-h")
  
puts <<HELP
  
  Notes on the usage of NPC Generation for the Amar RPG 
  
  This program will only make sense to you if you know what role-playing 
  games (RPGs) are. It is a useful asset to the Amar RPG.  
  
  The program is used for creating villages/towns/cities, random or
  specific encounters (basic details) or detailed NPC generation as well
  as random weather for a month. It can also generate relationship maps
  for inhabitants of a town or for a list of NPCs (with a graphical map
  showing the various positive and negative relations between them.
  
  There is also an Open Ended Dice roller for the Amar RPG (see the rules
  for what that is and how it is used in the game). That program is
  written in the nim programming language and compiled as a stand-alone
  executable called "O6". Simply put this in your path and you can throw
  an Open Ended Dice roll simply by running O6 on the command line..

  You may select or enter values in any of the NPC's characteristics. 
  Those you don't will be randomly generated. When you have selected/
  entered the values you want, press "submit", and the NPC will be generated.  

  When generating a town relationship map, you can upload a file with the
  same format as the one generated when creating a random town. The map
  will then have the name, basic info and the house number in an ellipse
  for each person that has a special relationship with others in the town.
  Or you can simply upload a list of characters, one per line and every
  line with a special relationship will be paired with other lines in the
  file. A black line indicates a special positive relation, while a red
  line signifies a special negative relation. A double black line shows a
  strong alliance, while a double red shows deep hate. A black and a red
  line indicates a complex relationship. A graphical map is created as a
  .png file in the npcg directory.

  Press "v" when a town, encounters or an NPC is presented to edit the
  values in your default editor. The files for a detailed NPC (temp.npc),
  random encounter (encounter.npc), random town (town.npc) or random
  weather (weather.npc) is generated in the "npcs" directory under "npcg".
  
  Happy generation :) 
  
  Several abbreviations are used. They are easily deciphered if you read 
  the Amar RPG rules.  
  
  The more obscure ones are: 
  Spell Heading: A?=Active/Passive? Here a "+" means both Active and passive.  
  R?=Resist? AoE="Area Of Effect", and we have A=Animal, C=Creature, D=Demon, 
  E=Elemental, O=Object, S=Spell, U=Undead, W=Weapon. 
  
  The asterisk indicates that it will increase with the spell level. 
  1mr = 1 meter radius.  
  
  The CLI-version of NPCg has the following options:
  -h  Displays this helpfile
  -e  Will display results in your editor of choice. Write the name of the
      editor directly following the "-e", such as npcg -e vim. If no editor
      is given, the program outputs the NPC to "less".""

  This program is licensed under the Gnu General Public License, 
  Copyright 2002-2015, Geir Isene.
  
HELP

else
  
  if ARGV.include?("-e")
		$editor = ARGV[ARGV.index("-e") + 1].to_s
		ARGV.clear
  end
    
	$editor = "less" if $editor == "" or $editor == nil

	require 'date'
  require 'readline'

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
    puts "a = Generate an adventure from OpenAI"
		puts "e = Random encounter"
		puts "t = Create a village/town/city"
		puts "r = Make town relations"
		puts "n = Generate a detailed human NPC"
		puts "N = Generate names"
		puts "w = Generate a month of weather"
		puts "q = Quit npcg\n\n"
    print "> "
		c = get_char
    if c == "a"
      puts "Getting adventure from OpenAI... (quality may vary, use at your own discretion)\n\n"
    else
      puts c
    end
		# q = Quit
		if c == "q"
      puts ""
			break
    # a = Generate an adventure
    elsif c == "a"
      cmd    = "openai -f " + __dir__ + "/amar.txt -x 2000"
      begin
        adv    = %x[#{cmd}]
        twidth = `tput cols`.to_i
        puts adv.gsub(/(.{1,#{twidth}})( +|$\n?)|(.{1,#{twidth}})/, "\\1\\3\n")
      rescue => error
        p error
        puts "\nYou need to install openai-term to use this feature (see https://github.com/isene/openai)"
      end
      begin
        system("echo '#{adv}' | xclip")
        puts "\n\n(Adventure copied to clipboard)"
      rescue
        puts "\n\nInstall xclip to have the adventure copied to the clipboard."
      end
      puts "Press any key..."
      get_char
		# e = Random Encounter
		elsif c == "e"
			ia = enc_input
			anENC = Enc.new(ia[0], ia[1])
			enc_output(anENC, "cli")
		# t = Random Town (castle/village/town/city)
		elsif c == "t"
			ia = town_input
			aTOWN = Town.new(ia[0], ia[1], ia[2])
			town_output(aTOWN, "cli")
		# r = Random relationship map
		elsif c == "r"
			town_file = "saved/town.npc"
			#Get town file name
			puts "\nEnter town file name (default=saved/town.npc):"
			print "> "
			fl = gets.chomp.to_s
			town_file = fl unless fl == ""
			town_relations(town_file)
			town_dot2txt(town_file)
			puts "\nPress any key..."
			c = get_char
		# n = Random NPC
		elsif c == "n"
			# Reload chartypes as it gets reworked every time
			load "includes/tables/chartype.rb"
			ia = npc_input
			aNPC = Npc.new(ia[0], ia[1], ia[2], ia[3], ia[4], ia[5], ia[6], ia[7], ia[8])
			npc_output(aNPC, "cli")
		# N = Random names
		elsif c == "N"
			name_gen
			puts "\nPress any key"
			c = get_char
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
end

# And that's all folks. G'day.
