# Tools for the Amar Role-Playing Game

---------------------------------------------------------------------------

Welcome to the swiss army knife for the Amar Role-Playing Game (http://d6gaming.org).

This program suite runs on any GNU/Linux system where the scripting
language Ruby is installed. Ruby is available as tar.gz, rpm packages or
deb-packages as needed for your specific Linux distribution. For more info
on Ruby, see http://www.ruby-lang.org.

This tool box for the Amar RPG is designed for generating random
or specific encounters and Non-Player Characters for the Amar RPG, random
settlements and relationship maps for inhabitants of villages/towns/cities
as well as random names for various races and for making Open Ended Dice Rolls. 

In order to make real use of this program, you should be running an Amar
game as the Game Master.

For more info on the Amar RPG, game rules, adventures and more, see
http://www.d6gaming.org/.

For an online version of this program, go to http://isene.org

To set up the program, extract npcg.tar.gz:

    tar -xzvf npcg.tar.gz

This creates a directory named "npcg". Go to this directory:

    cd npcg

Then, as root, run the setup program:

    ./setup.rb

This makes it possible for you to run the program by just entering
"npcg" on the command line.

Running npcg on the command line will give you a set of options:

	e = Random encounter
	t = Create a village/town/city
	r = Make town relations
	n = Generate a detailed human NPC
	N = Generate names
	q = Quit npcg

Simply pick the tools you want and follow the instructions.

When using the html version, amar.html is the starting page.

By running npcg on the command line with the -h option, this helpfile will be displayed:

  Notes on the usage of NPC Generation for the Amar RPG 
  
  This program will only make sense to you if you know what roleplaying 
  games (RPGs) are. It is a usefull asset to the Amar RPG.  
  
  The program is used for creating villages/towns/cities, random or
  specific encounters (basic details) or detailed NPC generation.

  You may select or enter values in any of the NPC's characteristics. 
  Those you don't will be randomly generated. When you have selected/
  entered the values you want, press "submit", and the NPC will be generated.  
	
  Press "v" when a town, encounters or an NPC is presented to edit the
  values in your default editor.
  
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

Thanks to Alan Skorkin
(https://www.skorks.com/2009/07/how-to-write-a-name-generator-in-ruby/)
for providing a basis for the random name generator.

Thank you for trying out NPC Generation. Feel free to visit my website at http://isene.com
