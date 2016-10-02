# Magick tables
# [ "Level", "Spell", "+", "Resist", "CT", "DR", "Dur", "Rng", "Wt", "AoE" ]
# referencegoes like $Magick["air"][9][5], which would be DR for "Fog" ( =9 )
# The NPC's level in the spell is entered into $Magick["air"][9][0]

$Magick = {
  "air" => [
    [ 0, "Push", "-", "N", "1r", "7", "I", "5m", "", "1O*/1C*" ],
    [ 0, "Animal Sense", "+", "Y", "5r", "9", "5m", "100m", "", "1A*" ],
    [ 0, "Ctrl Elemental", "A", "Y", "1r", "9", "2m", "10m", "", "1E*" ],
    [ 0, "Enh. COORD", "P", "Y", "10m", "9", "10m", "T", "100kg", "1C*" ],
    [ 0, "Extinguish", "-", "N", "1r", "9", "I", "5m", "", "1mr" ],
    [ 0, "Fog", "P", "N", "1m", "9", "5m", "10m", "", "10mr" ],
    [ 0, "Freeze Air", "P", "N", "1r", "9", "2r", "5m", "", "1mr" ],
    [ 0, "Telekin. Light", "A", "Y", "1r", "9", "1r", "5m", "100g", "1O*/1C*" ],
    [ 0, "Breathe in Water", "P", "Y", "1r", "11", "10m", "T", "", "1C*" ],
    [ 0, "Ctrl Wind", "A", "N", "1m", "11", "5m", "10m", "", "2mr" ],
    [ 0, "Levitation", "A", "Y", "1r", "11", "2r", "5m", "50kg", "1C*" ],
    [ 0, "Lightningbolt", "-", "N", "1r", "11", "I", "10m", "", "1T*" ],
    [ 0, "Make Familiar", "-", "Y", "12h", "11", "P", "T", "50kg", "1A*" ],
    [ 0, "Seek", "P", "N", "1r", "11", "1r", "T", "1kg", "1M*" ],
    [ 0, "Silence", "P", "Y", "1r", "11", "5r", "T", "100kg", "1O*/1C*" ],
    [ 0, "Summ. Elemental", "-", "N", "5m", "11", "2m", "1m", "", "1E*" ],
    [ 0, "Telekinesis", "A", "Y", "1r", "13", "1r", "5m", "5kg", "1O*/1C*" ],
    [ 0, "Banish", "-", "Y", "1r", "13", "I", "10m", "", "1D*" ],
    [ 0, "Invisibility", "P", "Y", "1r", "13", "5r", "T", "100kg", "1O*/1C*" ],
    [ 0, "Wall of Force", "P", "N", "1r", "13", "1r", "5m", "", "1/2mr" ],
    [ 0, "Waterwalking", "A", "Y", "5r", "13", "2m", "10m", "100kg", "1C*" ],
    [ 0, "Fly", "P", "Y", "1r", "15", "5r", "T", "50kg", "1C*" ],
    [ 0, "Prep. Teleport", "-", "Y", "1r", "17", "I", "T/100 km", "50kg", "1C*/1O*" ],
    [ 0, "Teleport", "-", "Y", "1r", "17", "I", "T/50m", "50kg", "1C*/1O*" ] ],
  "black" => [
    [ 0, "Agony", "A", "Y", "1r", "9", "1r", "2m", "100kg", "1C*" ],
    [ 0, "Possession", "A", "Y", "1m", "10", "10m", "S", "", "1C*" ],
    [ 0, "Prot. f Demons", "+", "N", "1r", "11", "1m", "T", "", "1C*" ],
    [ 0, "Prot. f Undeads", "+", "N", "1r", "11", "1m", "T", "", "1U*" ],
    [ 0, "Sleep", "P", "Y", "1m", "11", "2r", "10m", "", "1C" ],
    [ 0, "Summoning", "-", "N", "5m", "11", "2m", "1m", "", "1D*" ],
    [ 0, "Blindness", "P", "Y", "1r", "11", "1r", "5m", "", "1C*" ],
    [ 0, "Call", "-", "Y", "5m", "11", "2m", "1m", "", "1D*" ],
    [ 0, "Command", "A", "Y", "1r", "11", "1r", "1m", "", "1C*" ],
    [ 0, "Command Demon", "P", "Y", "1r", "11", "Spc", "5m", "", "1D*" ],
    [ 0, "Darkness", "+", "Y", "1r", "11", "1r", "5m", "", "1mr" ],
    [ 0, "Death T", "-", "Y", "1r", "11", "I", "T", "", "1C*" ],
    [ 0, "Make Familiar", "-", "Y", "12h", "11", "P", "T", "50kg", "1A*" ],
    [ 0, "Command Undead", "A", "Y", "1r", "13", "2m", "10m", "", "1U*" ],
    [ 0, "Banish", "-", "Y", "1r", "13", "I", "10m", "", "1D*" ],
    [ 0, "Immobilize", "P", "Y", "1r", "13", "1r", "10m", "", "1C*" ],
    [ 0, "Animate Dead", "P", "N", "1 d", "13", "1d/P", "T", "50kg", "1C*" ],
    [ 0, "Exteriorize", "P", "N", "10m", "14", "1m", "S", "", "S" ] ],
  "earth" => [
    [ 0, "Animal Sense", "+", "Y", "5r", "9", "5m", "100m", "", "1A*" ],
    [ 0, "Ctrl Elemental", "A", "Y", "1r", "9", "2m", "10m", "", "1E*" ],
    [ 0, "Enh. Strength", "P", "Y", "10m", "9", "10m", "T", "100kg", "1C*" ],
    [ 0, "Extinguish", "-", "N", "1r", "9", "I", "5m", "", "1mr" ],
    [ 0, "Freeze Solid", "P", "N", "1r", "9", "2r", "5m", "20kg", "1/2mr" ],
    [ 0, "Glue", "P", "Y", "1r", "9", "1r", "5m", "", "5 cmr" ],
    [ 0, "Repair", "-", "N", "10m", "9", "I", "T", "20kg", "1O*" ],
    [ 0, "Summon Elemental", "-", "N", "5m", "11", "2m", "1m", "", "1E*" ],
    [ 0, "Darkness", "+", "Y", "1r", "11", "1r", "5m", "", "1mr" ],
    [ 0, "Armor", "P", "Y", "1r", "11", "5r", "T", "100kg", "1O*/1C*" ],
    [ 0, "Make Familiar", "-", "Y", "12h", "11", "P", "T", "50kg", "1A*" ],
    [ 0, "Prot. f Fire", "P", "Y", "1r", "11", "2r", "1m", "", "1O*/1C*" ],
    [ 0, "Banish", "-", "Y", "1r", "13", "I", "10m", "", "1D*" ],
    [ 0, "Immobilize", "P", "Y", "1r", "13", "1r", "10m", "", "1C*" ] ],
  "fire" => [
    [ 0, "Ignite", "-", "Y", "1r", "7", "I", "1m", "", "5 cmr" ],
    [ 0, "Light", "P", "Y", "1r", "7", "5r", "1m", "", "1mr" ],
    [ 0, "Animal Sense", "+", "Y", "5r", "9", "5m", "100m", "", "1A*" ],
    [ 0, "Cone of Light", "A", "N", "1r", "9", "2r", "25m", "", "=>3mr" ],
    [ 0, "Ctrl Elemental", "A", "Y", "1r", "9", "2m", "10m", "", "1E*" ],
    [ 0, "Extinguish", "-", "N", "1r", "9", "I", "5m", "", "1mr" ],
    [ 0, "Flash", "-", "N", "1r", "9", "I", "1m", "", "Spc" ],
    [ 0, "Fireball", "-", "N", "1r", "11", "I", "5m", "", "1/2mr" ],
    [ 0, "Create Fire", "+", "Y", "5r", "11", "5r", "1m", "", "1/2mr" ],
    [ 0, "Prot. f Fire", "P", "Y", "1r", "11", "2r", "1m", "", "1O*/1C*" ],
    [ 0, "Summon Elemental", "-", "N", "5m", "11", "2m", "1m", "", "1E*" ],
    [ 0, "Banish", "-", "Y", "1r", "13", "I", "10m", "", "1D*" ],
    [ 0, "Ctrl Fire", "A", "N", "1m", "13", "5m", "10m", "", "1/2mr" ] ],
  "life" => [
    [ 0, "Det. Disemb. Spirit", "A", "N", "1r", "8", "1r", "S", "", "10mr" ],
    [ 0, "Animal Sense", "+", "Y", "5r", "9", "5m", "100m", "", "1A*" ],
    [ 0, "Enh. AWARE", "P", "Y", "10m", "9", "10m", "T", "", "1C*" ],
    [ 0, "Enh. COORD", "P", "Y", "10m", "9", "10m", "T", "100kg", "1C*" ],
    [ 0, "Enh. ENDUR", "P", "Y", "10m", "9", "10m", "T", "100kg", "1C*" ],
    [ 0, "Enh. LEARN", "P", "Y", "10m", "9", "10m", "T", "", "1C*" ],
    [ 0, "Enh. STRNG", "P", "Y", "10m", "9", "10m", "T", "100kg", "1C*" ],
    [ 0, "Healing", "A", "Y", "1m", "9", "Spc", "T", "", "1C*" ],
    [ 0, "Night Vision", "P", "Y", "1m", "9", "10m", "T", "100kg", "1C*" ],
    [ 0, "Possession", "A", "Y", "1m", "10", "10m", "S", "", "1C*" ],
    [ 0, "Blindness", "P", "Y", "1r", "11", "1r", "5m", "", "1C*" ],
    [ 0, "Breathe in Water", "P", "Y", "1r", "11", "10m", "T", "", "1C*" ],
    [ 0, "Change Size", "P", "Y", "1m", "11", "5m", "T", "100kg", "1C*" ],
    [ 0, "Charm I", "P", "Y", "1r", "11", "5r", "5m", "", "1C*" ],
    [ 0, "Charm II", "P", "Y", "10m", "11", "1h", "5m", "", "1C*" ],
    [ 0, "Command", "A", "Y", "1r", "11", "1r", "1m", "", "1C*" ],
    [ 0, "Make Familiar", "-", "Y", "12h", "11", "P", "T", "50kg", "1A*" ],
    [ 0, "Prot. f Demons", "+", "N", "1r", "11", "1m", "T", "", "1C*" ],
    [ 0, "Prot. f Undeads", "+", "N", "1r", "11", "1m", "T", "", "1U*" ],
    [ 0, "Sleep", "P", "Y", "1m", "11", "2r", "10m", "", "1C" ],
    [ 0, "Turn Undead", "-", "Y", "1r", "11", "I", "5m", "", "1mr+1U" ],
    [ 0, "Read Thought", "A", "Y", "1r", "13", "1r", "5m", "", "S+1C*" ],
    [ 0, "Banish", "-", "Y", "1r", "13", "I", "10m", "", "1D*" ],
    [ 0, "Immobilize", "P", "Y", "1r", "13", "1r", "10m", "", "1C*" ],
    [ 0, "Project Thought", "A", "Y", "1r", "13", "1r", "5m", "", "S+1C*" ],
    [ 0, "Exteriorize", "P", "N", "10m", "14", "1m", "S", "", "S" ],
    [ 0, "Polymorph", "P", "Y", "1m", "15", "5m", "T", "", "1C*" ],
    [ 0, "Regeneration", "P", "Y", "1h", "15", "Spc", "T", "", "1C*" ],
    [ 0, "Resurrection", "-", "Y", "2h", "19", "I", "T", "", "1C*" ] ],
  "magic" => [
    [ 0, "Delay", "P", "N", "1r", "0", "1r", "As spell", "", "1S*" ],
    [ 0, "Passify", "P", "N", "As spell", "0", "1r", "-", "", "1S*" ],
    [ 0, "Warding", "P", "N", "10m", "0", "1 d", "T", "", "1O*/1mr" ],
    [ 0, "Dispel Magic", "P", "N", "1r", "Tot+3", "1m", "10m", "", "1S*/10mr/1C",  ],
    [ 0, "Pnency", "P", "N", "12h", "5", "Spc", "T", "", "1S*" ],
    [ 0, "Enchant Item", "P", "Y", "12h", "8", "P", "T", "5kg", "1O*+1S" ],
    [ 0, "Det. Magic", "A", "Y", "1r", "9", "1r", "T", "", "1C*" ],
    [ 0, "Ench. Weapon", "P", "Y", "1r", "11", "2r", "T", "3kg", "1W*" ],
    [ 0, "Ident. Magic", "-", "Y", "1h", "11", "I", "1m", "", "1O*, 1C*/1S*" ],
    [ 0, "Prot. f Magic", "P", "Y", "1m", "11", "1m", "T", "", "1C*" ],
    [ 0, "Sharpness", "P", "Y", "1r", "11", "2r", "T", "3kg", "1W*" ],
    [ 0, "Wall of Force", "P", "N", "1r", "13", "1r", "5m", "", "1/2mr" ] ],
  "perception" => [
    [ 0, "Light", "P", "Y", "1r", "7", "5r", "1m", "", "1mr" ],
    [ 0, "Animal Sense", "+", "Y", "5r", "9", "5m", "100m", "", "1A*" ],
    [ 0, "Cone of Light", "A", "N", "1r", "9", "2r", "25m", "", "=>3mr" ],
    [ 0, "Det. Magic", "A", "Y", "1r", "9", "1r", "T", "", "1C*" ],
    [ 0, "Det. Truth", "A", "Y", "1r", "9", "5r", "5m", "", "1C*" ],
    [ 0, "Enh. Awareness", "P", "Y", "10m", "9", "10m", "T", "", "1C*" ],
    [ 0, "Farsee", "P", "Y", "1r", "9", "1m", "T", "", "1C*" ],
    [ 0, "Night Vision", "P", "Y", "1m", "9", "10m", "T", "100kg", "1C*" ],
    [ 0, "Det. Disemb. Spirit", "A", "N", "1r", "11", "1r", "S", "", "10mr" ],
    [ 0, "Identify Magic", "-", "Y", "1h", "11", "I", "1m", "", "1O*, 1C*/1S*" ],
    [ 0, "Read Thought", "A", "Y", "1r", "13", "1r", "5m", "", "S+1C*" ] ],
  "protection" => [
    [ 0, "Prot. f Water", "P", "Y", "1r", "7", "2m", "T", "50kg", "1O*/1C*" ],
    [ 0, "Armor", "P", "Y", "1r", "11", "5r", "T", "100kg", "1O*/1C*" ],
    [ 0, "Prot. f Demons", "+", "N", "1r", "11", "1m", "T", "", "1C*" ],
    [ 0, "Prot. f Fire", "P", "Y", "1r", "11", "2r", "1m", "", "1O*/1C*" ],
    [ 0, "Prot. f Magic", "P", "Y", "1m", "11", "1m", "T", "", "1C*" ],
    [ 0, "Prot. f Undeads", "+", "N", "1r", "11", "1m", "T", "", "1U*" ] ],
  "summoning" => [
    [ 0, "Ctrl Elemental", "A", "Y", "1r", "9", "2m", "10m", "", "1E*" ],
    [ 0, "Call", "-", "Y", "5m", "11", "2m", "1m", "", "1D*" ],
    [ 0, "Command Demon", "P", "Y", "1r", "11", "Spc", "5m", "", "1D*" ],
    [ 0, "Prot. f Demons", "+", "N", "1r", "11", "1m", "T", "", "1C*" ],
    [ 0, "Summon Elemental", "-", "N", "5m", "11", "2m", "1m", "", "1E*" ],
    [ 0, "Summoning", "-", "N", "5m", "11", "2m", "1m", "", "1D*" ],
    [ 0, "Banish", "-", "Y", "1r", "13", "I", "10m", "", "1D*" ] ],
  "water" => [
    [ 0, "Prot. f Water", "P", "Y", "1r", "7", "2m", "T", "50kg", "1O*/1C*" ],
    [ 0, "Water to Wine", "-", "N", "2r", "7", "I", "1m", "", "1l" ],
    [ 0, "Animal Sense", "+", "Y", "5r", "9", "5m", "100m", "", "1A*" ],
    [ 0, "Ctrl Elemental", "A", "Y", "1r", "9", "2m", "10m", "", "1E*" ],
    [ 0, "Create Water", "-", "N", "1m", "9", "I", "5m", "", "10l" ],
    [ 0, "Extinguish", "-", "N", "1r", "9", "I", "5m", "", "1mr" ],
    [ 0, "Fog", "P", "N", "1m", "9", "5m", "10m", "", "10mr" ],
    [ 0, "Freeze Liquid", "P", "N", "1r", "9", "2r", "5m", "", "1/2mr" ],
    [ 0, "Make Familiar", "-", "Y", "12h", "11", "P", "T", "50kg", "1A*" ],
    [ 0, "Breathe in Water", "P", "Y", "1r", "11", "10m", "T", "", "1C*" ],
    [ 0, "Change Size", "P", "Y", "1m", "11", "5m", "T", "100kg", "1C*" ],
    [ 0, "Prot. f Fire", "P", "Y", "1r", "11", "2r", "1m", "", "1O*/1C*" ],
    [ 0, "Summon Elemental", "-", "N", "5m", "11", "2m", "1m", "", "1E*" ],
    [ 0, "Banish", "-", "Y", "1r", "13", "I", "10m", "", "1D*" ],
    [ 0, "Ctrl Water", "A", "N", "1m", "13", "5m", "10m", "", "1/2mr" ],
    [ 0, "Water Walking", "A", "Y", "5r", "13", "2m", "10m", "100kg", "1C*" ],
    [ 0, "Polymorph", "P", "Y", "1m", "15", "5m", "T", "", "1C*" ] ]
}
