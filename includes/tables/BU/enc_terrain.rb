# Terrain randomizer
# Tarraintype#=Night#(0)/Day#(1),Terrain#: Terrain, Night/Day
# 0: City   1: Rural   2: Road   3:Plains   4: Hills   5: Mountain   6:Woods   7: Wilderness
# $Terraintype = $Terrain + (8 * $Day)

$Enc_terrain = Array.new

# 0=0,0: City, Night
$Enc_terrain[0] = {
  "smallanimal" => 3,
  "largeanimal" => 3,
  "human" => 10,
  "dwarf" => 2,
  "elf" => 2,
  "arax" => 1,
  "monster" => 1
}

# 8=1,0: City, Day
$Enc_terrain[8] = {
  "smallanimal" => 3,
  "largeanimal" => 4,
  "human" => 15,
  "dwarf" => 3,
  "elf" => 3,
  "arax" => 1,
  "monster" => 1
}

# 1=0,1: Rural, Night
$Enc_terrain[1] = {
  "smallanimal" => 4,
  "largeanimal" => 5,
  "human" => 9,
  "dwarf" => 2,
  "elf" => 2,
  "arax" => 1,
  "monster" => 1
}

# 9=1,1: Rural, Day
$Enc_terrain[9] = {
  "smallanimal" => 4,
  "largeanimal" => 5,
  "human" => 14,
  "dwarf" => 3,
  "elf" => 3,
  "arax" => 1,
  "monster" => 1
}

# 2=0,2: Road, Night
$Enc_terrain[2] = {
  "smallanimal" => 4,
  "largeanimal" => 5,
  "human" => 8,
  "dwarf" => 2,
  "elf" => 2,
  "arax" => 2,
  "monster" => 1
}

# 10=1,3: Road, Day
$Enc_terrain[10] = {
  "smallanimal" => 5,
  "largeanimal" => 5,
  "human" => 13,
  "dwarf" => 3,
  "elf" => 3,
  "arax" => 1,
  "monster" => 1
}

# 3=0,3: Plains, Night
$Enc_terrain[3] = {
  "smallanimal" => 10,
  "largeanimal" => 8,
  "human" => 7,
  "dwarf" => 3,
  "elf" => 3,
  "arax" => 3,
  "monster" => 3
}

# 11=1,3: Plains, Day
$Enc_terrain[11] = {
  "smallanimal" => 10,
  "largeanimal" => 8,
  "human" => 10,
  "dwarf" => 3,
  "elf" => 3,
  "arax" => 1,
  "monster" => 1
}

# 4=0,4: Hills, Night
$Enc_terrain[4] = {
  "smallanimal" => 10,
  "largeanimal" => 7,
  "human" => 6,
  "dwarf" => 4,
  "elf" => 2,
  "arax" => 3,
  "monster" => 3
}

# 12=1,4: Hills, Day
$Enc_terrain[12] = {
  "smallanimal" => 10,
  "largeanimal" => 7,
  "human" => 9,
  "dwarf" => 6,
  "elf" => 2,
  "arax" => 2,
  "monster" => 2
}

# 5=0,5: Mountains, Night
$Enc_terrain[5] = {
  "smallanimal" => 8,
  "largeanimal" => 6,
  "human" => 5,
  "dwarf" => 6,
  "elf" => 1,
  "arax" => 3,
  "monster" => 4
}

# 13=1,5: Mountains, Day
$Enc_terrain[13] = {
  "smallanimal" => 8,
  "largeanimal" => 6,
  "human" => 7,
  "dwarf" => 8,
  "elf" => 1,
  "arax" => 2,
  "monster" => 3
}

# 6=0,6: Woods, Night
$Enc_terrain[6] = {
  "smallanimal" => 15,
  "largeanimal" => 12,
  "human" => 8,
  "dwarf" => 1,
  "elf" => 6,
  "arax" => 3,
  "monster" => 3
}

# 14=1,6: Woods, Day
$Enc_terrain[14] = {
  "smallanimal" => 15,
  "largeanimal" => 12,
  "human" => 10,
  "dwarf" => 1,
  "elf" => 8,
  "arax" => 2,
  "monster" => 2
}

# 7=0,7: Wilderness, Night
$Enc_terrain[7] = {
  "smallanimal" => 10,
  "largeanimal" => 7,
  "human" => 4,
  "dwarf" => 3,
  "elf" => 3,
  "arax" => 3,
  "monster" => 4
}

# 15=1,7: Wilderness, Day
$Enc_terrain[15] = {
  "smallanimal" => 10,
  "largeanimal" => 7,
  "human" => 6,
  "dwarf" => 3,
  "elf" => 3,
  "arax" => 3,
  "monster" => 4
}

