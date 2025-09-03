# Terrain randomizer - what type of encounter is most likely in each terrain
#
# Tarraintype#=Night#(0)/Day#(1),Terrain#: Terrain, Night/Day
# 0: City   1: Rural   2: Road   3: Plains   4: Hills   5: Mountain   6: Woods   7: Wilderness
# $Terraintype = $Terrain + (8 * $Day)

$Enc_type = {#      ○Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi●Ci,Ru,Ro,Pl,Hi,Mo,Wo,Wi
  "NO ENCOUNTER" => [ 8, 9,11,13,13,15,17,15, 5, 7, 9,11,11,13,15,13],
  "smallanimal" =>  [ 3, 4, 4,10,10, 8,15,10, 3, 4, 5,10,10, 8,15,10],
  "largeanimal" =>  [ 2, 5, 5, 8, 7, 6,12, 7, 4, 5, 5, 8, 7, 6,12, 7],
  "human" =>				[10, 9, 8, 7, 6, 5, 8, 4,15,14,13,10, 9, 7,10, 6],
  "dwarf" =>				[ 2, 2, 2, 3, 4, 6, 1, 3, 3, 3, 3, 3, 6, 8, 1, 3],
  "elf" =>					[ 1, 1, 1, 2, 1, 1, 5, 3, 3, 3, 3, 3, 2, 1, 8, 3],
  "arax" =>					[ 1, 1, 2, 3, 3, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 3],
  "monster" =>	    [ 1, 1, 1, 3, 3, 4, 3, 4, 1, 1, 1, 1, 2, 3, 2, 4],
  "event" =>				[ 4, 4, 3, 3, 3, 3, 4, 4, 5, 4, 3, 3, 3, 3, 4, 5]
}
