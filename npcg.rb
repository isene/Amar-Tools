#! /usr/bin/ruby

# Welcome to the NPC generation version 0.5.
# 
# This file is the umbrella for NPC to work as CLI/terminal program.

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

system "touch npcs/temp.npc"
system "touch npcs/town.npc"
system "touch npcs/encounter.npc"

# Help output
if ARGV.include?("-h")
  
puts <<HELP
  
  Notes on the usage of NPC Generation for the Amar RPG 
  
  This program will only make sense to you if you know what roleplaying 
  games (RPGs) are. It is a usefull asset to the Amar RPG.  
  
	The program is used for random or specific encounters (basic details) or
	detailed NPC generation.

  You may select or enter values in any of the NPC's characteristics. 
  Those you don't will be randomly generated. When you have selected/
  entered the values you want, press "submit", and the NPC will be generated.  
	
	Press "v" when encounters or an NPC is presented to edit the values in
	your default editor.
  
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
  
    require "date"

    load "includes/includes.rb"

    load "cli_npc_input.rb"
    load "cli_npc_output.rb"
    load "cli_enc_input.rb"
    load "cli_enc_output.rb"
    load "cli_town_input.rb"
    load "cli_town_output.rb"
    load "cli_name_gen.rb"

    # Set initial global encounter default values
    $Day = 1
    $Terrain = 0
    $Terraintype = 8
    $Level = 0

    # The Npc enters via the inputform, is initialized and rendered by the outputform.
    
    loop do
		system "clear"
		puts "\nNPC Generation 0.5 - Rendom encounters and character generation for Amar RPG."
		puts "\nENTER = Random encounter\nt = Create a village/town/city\nn = Generate a detailed human NPC\nN = Generate names\nq = Quit npcg\n\n"
		c = get_char
		if c == "q"
			break
		elsif c == "\r"
			ia = enc_input
			anENC = Enc.new(ia[0], ia[1])
			enc_output(anENC)
		elsif c == "t"
			ia = town_input
			aTOWN = Town.new(ia[0], ia[1])
			town_output(aTOWN)
		elsif c == "n"
			load "includes/tables/chartype.rb"
			ia = npc_input
			aNPC = Npc.new(ia[0], ia[1], ia[2], ia[3], ia[4], ia[5], ia[6], ia[7], ia[8])
			npc_output(aNPC)
		elsif c == "N"
			name_gen
			puts "\nPress any key"
			c = get_char
		end
    end
end

# And that's all folks. G'day.
