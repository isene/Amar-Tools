# The main data for encountering each specific type in various terrains
#
# Terrain randomizer: Terraintype#=Night#(0)/Day#(1),Terrain#: Terrain, Night/Day -- $Terraintype = $Terrain + (8 * $Day)
# [ 0: City   1: Rural   2: Road   3: Plains   4: Hills   5: Mountain   6: Woods   7: Wilderness ]

$Enc_specific = {
	"smallanimal" => {#						○Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi●Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi
		"Small animal: Prey" =>			[ 7, 7, 6, 6, 6, 6, 6, 5, 8, 7, 6, 6, 6, 6, 6, 5],
		"Small animal: Predator" => [ 3, 3, 4, 4, 4, 4, 4, 5, 2, 3, 4, 4, 4, 4, 4, 5]
	 },
	"largeanimal" => {#						○Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi●Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi
		"Large animal: Prey" =>			[ 8, 8, 7, 6, 6, 6, 6, 5, 9, 8, 7, 6, 6, 6, 6, 5],
		"Large animal: Predator" => [ 2, 2, 3, 4, 4, 4, 4, 5, 1, 2, 3, 4, 4, 4, 4, 5]
	 },
	"human" => {#									○Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi●Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi
		"Human: Animal trainer" =>	[ 2, 5, 4, 5, 5, 5, 6, 6, 2, 5, 4, 5, 5, 5, 6, 6],
		"Human: Archer" =>					[ 3, 4, 4, 5, 5, 5, 5, 5, 3, 4, 4, 5, 5, 5, 5, 5],
		"Human: Armour smith" =>		[ 4, 2, 2, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 2, 2],
		"Human: Army officer" =>		[ 5, 5, 4, 3, 3, 3, 3, 3, 5, 5, 4, 3, 3, 3, 3, 3],
		"Human: Assassin" =>				[ 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Baker/Cook" =>			[ 4, 4, 3, 3, 3, 3, 3, 3, 4, 4, 3, 3, 3, 3, 3, 3],
		"Human: Bard" =>						[ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
		"Human: Boatbuilder" =>			[ 4, 4, 3, 3, 2, 1, 3, 3, 4, 4, 3, 3, 2, 1, 3, 3],
		"Human: Body guard" =>			[ 4, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 3, 3, 3],
		"Human: Builder" =>					[ 5, 5, 3, 4, 4, 4, 4, 4, 5, 5, 3, 4, 4, 4, 4, 4],
		"Human: Bureaucrat" =>			[ 3, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2],
		"Human: Carpenter" =>				[ 4, 4, 3, 4, 4, 4, 6, 4, 4, 4, 3, 4, 4, 4, 6, 4],
		"Human: Clergyman" =>				[ 4, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 3, 3, 3],
		"Human: Crafts (fine)" =>		[ 4, 3, 2, 3, 3, 3, 3, 3, 4, 3, 2, 3, 3, 3, 3, 3],
		"Human: Crafts (heavy)" =>	[ 4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 4, 4],
		"Human: Entertainer" =>			[ 5, 4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 4],
		"Human: Executioner" =>			[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Farmer" =>					[ 4,10, 8, 7, 6, 5, 6, 5, 4,10, 8, 7, 6, 5, 6, 5],
		"Human: Fine artist" =>			[ 3, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2],
		"Human: Fine smith" =>			[ 4, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 3, 3, 3],
		"Human: Fisherman" =>				[ 6, 8, 5, 4, 4, 4, 4, 4, 6, 8, 5, 4, 4, 4, 4, 4],
		"Human: Gladiator" =>				[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
		"Human: Noble" =>						[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Highwayman" =>			[ 2, 3, 6, 6, 6, 6, 6, 6, 1, 3, 6, 6, 6, 6, 6, 6],
		"Human: House wife" =>			[ 8, 8, 5, 5, 5, 4, 5, 3, 8, 8, 5, 5, 5, 4, 5, 3],
		"Human: Hunter" =>					[ 4, 8, 8, 9, 9, 9,10, 9, 4, 8, 8, 9, 9, 9,10, 9],
		"Human: Jeweller" =>				[ 3, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1],
		"Human: High class" =>			[ 3, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2],
		"Human: Mapmaker" =>				[ 3, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2],
		"Human: Mason" =>						[ 6, 6, 5, 5, 5, 4, 4, 4, 6, 6, 5, 5, 5, 4, 4, 4],
		"Human: Merchant" =>				[ 7, 6, 6, 6, 5, 5, 5, 5, 7, 6, 6, 6, 5, 5, 5, 5],
		"Human: Messenger" =>				[ 3, 2, 3, 2, 2, 2, 2, 2, 3, 2, 3, 2, 2, 2, 2, 2],
		"Human: Monk" =>						[ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
		"Human: Nanny" =>						[ 5, 4, 3, 4, 4, 4, 4, 4, 5, 4, 3, 4, 4, 4, 4, 4],
		"Human: Navigator" =>				[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
		"Human: Prostitute" =>			[ 6, 2, 2, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 2, 2],
		"Human: Ranger" =>					[ 3, 6, 6, 7, 7, 7, 9, 8, 3, 6, 6, 7, 7, 7, 9, 8],
		"Human: Sage" =>						[ 3, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2],
		"Human: Sailor" =>					[ 7, 8, 3, 3, 3, 3, 3, 3, 7, 8, 3, 3, 3, 3, 3, 3],
		"Human: Scribe" =>					[ 3, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2],
		"Human: Seer" =>						[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
		"Human: Smith" =>						[ 7, 6, 4, 4, 4, 4, 4, 4, 7, 6, 4, 4, 4, 4, 4, 4],
		"Human: Soldier" =>					[10, 8, 8, 8, 8, 8, 8, 8, 0, 8, 8, 8, 8, 8, 8, 8],
		"Human: Sorcerer" =>				[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Sports contender" =>[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
		"Human: Summoner" =>				[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Tailor" =>					[ 6, 6, 4, 4, 4, 4, 4, 4, 6, 6, 4, 4, 4, 4, 4, 4],
		"Human: Tanner" =>					[ 5, 5, 4, 4, 4, 4, 6, 5, 5, 5, 4, 4, 4, 4, 6, 5],
		"Human: Thief" =>						[ 5, 4, 5, 3, 3, 3, 3, 3, 3, 3, 5, 3, 3, 3, 3, 3],
		"Human: Tracker" =>					[ 3, 6, 7, 7, 7, 7, 8, 9, 3, 6, 7, 7, 7, 7, 8, 9],
		"Human: Warrior" =>					[ 7, 6, 7, 7, 7, 7, 7, 7, 7, 6, 7, 7, 7, 7, 7, 7],
		"Human: Witch (black)" =>		[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Witch (white)" =>		[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Wizard (air)" =>		[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Wizard (earth)" =>	[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Wizard (fire)" =>		[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Wizard (water)" =>	[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Human: Wizard (prot.)" =>	[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	},
	"dwarf" => {#									○Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi●Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi
		"Dwarf: Worker" =>					[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
		"Dwarf: Warrior" =>					[ 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 3, 4, 2, 2],
		"Dwarf: Guard" =>						[ 4, 3, 3, 3, 3, 3, 2, 2, 3, 3, 4, 3, 3, 4, 2, 2],
		"Dwarf: Smith" =>						[ 4, 3, 2, 2, 2, 2, 2, 2, 6, 5, 4, 2, 2, 2, 2, 2]
	 },
	"elf" => {#										○Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi●Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi
		"Elf: Worker" =>						[ 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
		"Elf: Warrior" =>						[ 2, 2, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 2, 2, 3, 3],
		"Elf: Archer" =>						[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
		"Elf: Wizard" =>						[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	 },
	"arax" => {#									○Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi●Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi
		"Arax: Worker" =>						[ 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2],
		"Arax: Warrior" =>					[ 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 3, 3, 3, 4],
		"Arax: Hunter" =>						[ 3, 3, 3, 4, 4, 4, 4, 4, 3, 3, 3, 4, 4, 4, 4, 4]
	},
	"monster" => {#								○Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi●Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi
		"Monster: Troll (small)" => [ 3, 3, 4, 5, 6, 6, 7, 7, 2, 2, 3, 4, 5, 5, 6, 6],
		"Monster: Troll (large)" => [ 1, 1, 1, 2, 3, 3, 4, 4, 1, 1, 1, 2, 2, 2, 3, 3],
		"Monster: Faerie" =>				[ 4, 4, 4, 5, 4, 2,10, 9, 4, 4, 4, 6, 4, 2,10, 9],
		"Monster: Lizardman" =>			[ 5, 5, 5, 5, 4, 3, 5, 6, 5, 5, 5, 5, 5, 3, 5, 6],
		"Monster: Giant" =>					[ 2, 2, 2, 2, 3, 4, 2, 2, 2, 2, 2, 2, 3, 4, 2, 2],
		"Monster: Wyvern" =>				[ 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 4, 5, 4, 5],
		"Monster: Werewolf" =>			[ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
		"Monster: Zombie" =>				[ 4, 4, 4, 4, 4, 4, 4, 4, 1, 1, 1, 1, 2, 3, 1, 4],
		"Monster: Skeleton" =>			[ 4, 4, 4, 4, 4, 4, 4, 4, 1, 1, 1, 1, 2, 3, 1, 4],
		"Monster: Vampire" =>				[ 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0],
		"Monster: Dragon" =>				[ 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 2, 2, 2],
		"Monster: Special" =>				[ 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 6]
	},
	"event" => {
		# ○Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi●Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi
		"Event: Robbed victim lies on the ground, crying" =>  
			[ 3, 2, 1, 0, 0, 0, 0, 0, 3, 2, 1, 0, 0, 0, 0, 0],
		"Event: Shop is getting robbed" =>  
			[ 3, 1, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0],
		"Event: Law enforcement is about to catch a robber/thief" =>  
			[ 2, 1, 0, 0, 0, 0, 0, 0, 3, 2, 1, 0, 0, 0, 0, 0],
		"Event: Law enforcement with a newly caught robber/thief" =>  
			[ 2, 1, 1, 0, 0, 0, 0, 0, 3, 2, 2, 0, 0, 0, 0, 0],
		"Event: Mob bullying an innocent" =>  
			[ 3, 1, 1, 0, 0, 0, 0, 0, 5, 3, 1, 0, 0, 0, 0, 0],
		"Event: Assassination attempt" =>  
			[ 3, 2, 1, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0],
		"Event: Crowd demonstrating" =>  
			[ 0, 0, 0, 0, 0, 0, 0, 0, 4, 2, 0, 0, 0, 0, 0, 0],
		"Event: Religious procession" =>  
			[ 2, 1, 0, 0, 0, 0, 0, 0, 6, 4, 4, 3, 3, 1, 3, 1],
		"Event: Roll again. The encounter is wounded" =>  
			[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
		"Event: Roll again. The encounter is rich (2d6 GP)" =>  
			[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
		"Event: Roll again. If human or dwarf, the encounter is drunk" =>  
			[ 5, 3, 3, 2, 2, 1, 2, 1, 4, 2, 2, 1, 1, 1, 1, 1],
		"Event: Roll again. The encounter carries a magic item" =>  
			[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Event: Combination encounter. Roll two times" =>  
			[ 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
		"Event: Combination encounter. Roll three times" =>  
			[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Event: Ambush. Roll again" =>  
			[ 2, 2, 3, 1, 1, 1, 1, 2, 2, 2, 3, 1, 1, 1, 1, 2],
		"Event: Roll again. Encounter is seeking treasure (if applicable)" =>  
			[ 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5],
		"Event: Music event/consert" =>  
			[ 2, 1, 0, 0, 0, 0, 0, 0, 5, 4, 2, 1, 1, 1, 1, 1],
		"Event: Hero. Roll again with +4 level until \na humanoid is rolled (use only the first one)" =>  
			[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
		"Event: Demi-God. Roll again with +8 level until \na humanoid is rolled (use only the first one)" =>  
			[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Event: Quarrel/fight between two encounters. Roll two times" =>  
			[ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
		"Event: Bad weather" =>  
			[ 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
		"Event: Abandoned camp/equipment" =>  
			[ 4, 4, 4, 4, 4, 2, 4, 2, 4, 4, 4, 4, 4, 2, 4, 2],
		"Event: Equipment worth 1d6 GP if Awareness roll of 12 is made" =>  
			[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Event: Fire or explosion" =>  
			[ 2, 2, 1, 1, 1, 1, 1, 1, 3, 2, 1, 1, 1, 1, 1, 1],
		"Event: Temporary magic field, restore 1 MA" =>  
			[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Event: Temporary magic field, drain 1 MA" =>  
			[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		"Event: Encounter is terrified. Roll again" =>  
			[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
		"Event: Encounter is seeking help. Roll again" =>  
			[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
		"Event: Cave/cavern/dungeon/building discovered with\n Awareness roll of 9 (12 at night)" =>  
			[ 1, 1, 1, 2, 3, 3, 3, 4, 1, 1, 1, 3, 3, 3, 3, 4]
	}
}

