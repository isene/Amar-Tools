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

Simply pick the tool you want and follow the instructions.

When using the html version, amar.html is the starting page.

By running npcg on the command line with the -h option, this help file will be displayed:

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

Thanks to Alan Skorkin
(https://www.skorks.com/2009/07/how-to-write-a-name-generator-in-ruby/)
for providing a basis for the random name generator.

Thank you for trying out NPC Generation. Feel free to visit my website at http://isene.com
