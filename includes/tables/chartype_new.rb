# Character type templates for the new 3-tier system

# Load the full character type definitions with all 64 types
load File.join($pgmdir, "includes/tables/chartype_new_full.rb")

# The main character type table is now loaded from chartype_new_full.rb
# $ChartypeNew is set at the end of that file

# Legacy character type table (kept for reference only)
$ChartypeNewLegacy = {
  "Warrior" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 4,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 4,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Carrying" => 2,
      "BODY/Strength/Weight lifting" => 2,
      "BODY/Strength/Wield weapon" => 3,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Endurance/Combat Tenacity" => 3,
      "BODY/Endurance/Running" => 2,
      "BODY/Athletics/Climb" => 1,
      "BODY/Athletics/Dodge" => 2,
      "BODY/Athletics/Balance" => 1,
      "MIND/Awareness/Reaction speed" => 2,
      "MIND/Willpower/Pain Tolerance" => 2,
      "MIND/Willpower/Courage" => 3
    },
    "melee_weapons" => {
      "Sword" => 3,
      "Shield" => 3,
      "Axe" => 2,
      "Spear" => 2
    },
    "missile_weapons" => {
      "Bow" => 2,
      "Throwing" => 2
    }
  },
  
  "Mage" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 3,
      "SPIRIT" => 3
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 4,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 4,
      "SPIRIT/Innate" => 1,
      "SPIRIT/Worship" => 2
    },
    "skills" => {
      "BODY/Endurance/Fortitude" => 2,
      "MIND/Intelligence/Innovation" => 3,
      "MIND/Intelligence/Problem Solving" => 3,
      "MIND/Nature Knowledge/Magick Rituals" => 3,
      "MIND/Nature Knowledge/Alchemy" => 3,
      "MIND/Social Knowledge/Literacy" => 3,
      "MIND/Social Knowledge/Mythology" => 3,
      "MIND/Awareness/Sense Magick" => 3,
      "MIND/Willpower/Mental Fortitude" => 3,
      "SPIRIT/Casting/Range" => 3,
      "SPIRIT/Casting/Duration" => 3,
      "SPIRIT/Casting/Area of Effect" => 2,
      "SPIRIT/Attunement/Fire" => 3,
      "SPIRIT/Attunement/Mind" => 3,
      "SPIRIT/Attunement/Self" => 3
    },
    "melee_weapons" => {
      "Staff" => 2,
      "Dagger" => 1
    },
    "missile_weapons" => {
      "Sling" => 1
    }
  },
  
  "Thief" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 3,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 4,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 3,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Hide" => 3,
      "BODY/Athletics/Move Quietly" => 3,
      "BODY/Athletics/Climb" => 3,
      "BODY/Athletics/Balance" => 3,
      "BODY/Athletics/Tumble" => 3,
      "BODY/Sleight/Pick pockets" => 3,
      "BODY/Sleight/Disarm Traps" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 2,
      "MIND/Practical Knowledge/Set traps" => 3,
      "MIND/Awareness/Detect Traps" => 3,
      "MIND/Awareness/Listening" => 3,
      "MIND/Social Knowledge/Social lore" => 3
    },
    "melee_weapons" => {
      "Dagger" => 3,
      "Short sword" => 2
    },
    "missile_weapons" => {
      "Throwing" => 3,
      "Bow" => 2
    }
  },
  
  "Merchant" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 3,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Athletics/Ride" => 2,
      "MIND/Intelligence/Problem Solving" => 3,
      "MIND/Social Knowledge/Social lore" => 3,
      "MIND/Social Knowledge/Spoken Language" => 3,
      "MIND/Social Knowledge/Literacy" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 2,
      "MIND/Awareness/Sense Emotions" => 3,
      "MIND/Willpower/Mental Fortitude" => 3
    },
    "melee_weapons" => {
      "Dagger" => 1,
      "Staff" => 1
    },
    "missile_weapons" => {}
  },
  
  "Ranger" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 3,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 4,
      "BODY/Athletics" => 4,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 4,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 1,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Endurance/Running" => 3,
      "BODY/Athletics/Hide" => 3,
      "BODY/Athletics/Move Quietly" => 3,
      "BODY/Athletics/Climb" => 3,
      "BODY/Athletics/Swim" => 3,
      "MIND/Nature Knowledge/Animal Lore" => 3,
      "MIND/Nature Knowledge/Plant Lore" => 3,
      "MIND/Nature Knowledge/Animal Handling" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 3,
      "MIND/Practical Knowledge/Set traps" => 3,
      "MIND/Awareness/Tracking" => 3,
      "MIND/Awareness/Sense of Direction" => 3
    },
    "melee_weapons" => {
      "Sword" => 3,
      "Axe" => 2,
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Bow" => 3,
      "Throwing" => 3
    }
  },
  
  "Priest" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 3,
      "SPIRIT" => 3
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 4,
      "SPIRIT/Casting" => 3,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 4
    },
    "skills" => {
      "MIND/Nature Knowledge/Medical lore" => 3,
      "MIND/Social Knowledge/Mythology" => 3,
      "MIND/Social Knowledge/Legend Lore" => 3,
      "MIND/Social Knowledge/Literacy" => 3,
      "MIND/Willpower/Mental Fortitude" => 3,
      "MIND/Willpower/Courage" => 3,
      "SPIRIT/Casting/Duration" => 3,
      "SPIRIT/Attunement/Life" => 3,
      "SPIRIT/Attunement/Mind" => 2
    },
    "melee_weapons" => {
      "Mace" => 2,
      "Staff" => 2
    },
    "missile_weapons" => {
      "Sling" => 1
    }
  },
  
  "Craftsman" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 3,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Carrying" => 3,
      "BODY/Strength/Weight lifting" => 3,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Sleight/Stage Magic" => 2,
      "MIND/Intelligence/Problem Solving" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 2,
      "MIND/Willpower/Pain Tolerance" => 3
    },
    "melee_weapons" => {
      "Hammer" => 2,
      "Dagger" => 1
    },
    "missile_weapons" => {}
  },
  
  "Noble" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 3,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 1,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 4,
      "SPIRIT/Casting" => 1,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 2
    },
    "skills" => {
      "BODY/Athletics/Ride" => 3,
      "BODY/Athletics/Balance" => 2,
      "MIND/Social Knowledge/Social lore" => 3,
      "MIND/Social Knowledge/Spoken Language" => 3,
      "MIND/Social Knowledge/Literacy" => 3,
      "MIND/Social Knowledge/Legend Lore" => 3,
      "MIND/Awareness/Sense Emotions" => 3,
      "MIND/Willpower/Courage" => 3,
      "MIND/Willpower/Mental Fortitude" => 3
    },
    "melee_weapons" => {
      "Sword" => 3,
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Bow" => 2
    }
  },
  
  "Prostitute" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Balance" => 3,
      "BODY/Athletics/Tumble" => 2,
      "BODY/Sleight/Stage Magic" => 3,
      "MIND/Social Knowledge/Social lore" => 3,
      "MIND/Social Knowledge/Spoken Language" => 3,
      "MIND/Awareness/Sense Emotions" => 3,
      "MIND/Awareness/Listening" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 2
    },
    "melee_weapons" => {
      "Dagger" => 1
    },
    "missile_weapons" => {}
  },
  
  "Assassin" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 3,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 4,
      "BODY/Melee Combat" => 4,
      "BODY/Missile Combat" => 4,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Hide" => 3,
      "BODY/Athletics/Move Quietly" => 3,
      "BODY/Athletics/Climb" => 3,
      "BODY/Sleight/Pick pockets" => 3,
      "BODY/Sleight/Disarm Traps" => 3,
      "MIND/Nature Knowledge/Plant Lore" => 3,  # Poisons
      "MIND/Practical Knowledge/Set traps" => 3,
      "MIND/Practical Knowledge/Ambush" => 3,
      "MIND/Awareness/Tracking" => 3,
      "MIND/Awareness/Listening" => 3
    },
    "melee_weapons" => {
      "Dagger" => 3,
      "Short sword" => 3,
      "Garrote" => 3
    },
    "missile_weapons" => {
      "Throwing" => 3,
      "Blowgun" => 3,
      "X-Bow" => 3
    }
  },
  
  "Sailor" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 4,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Strength/Carrying" => 3,
      "BODY/Athletics/Climb" => 3,
      "BODY/Athletics/Swim" => 3,
      "BODY/Athletics/Balance" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 3,
      "MIND/Awareness/Sense of Direction" => 3,
      "MIND/Nature Knowledge/Animal Lore" => 2,  # Sea creatures
      "MIND/Willpower/Hold Breath" => 3
    },
    "melee_weapons" => {
      "Cutlass" => 3,
      "Dagger" => 2,
      "Club" => 2
    },
    "missile_weapons" => {
      "Throwing" => 2
    }
  },
  
  "Entertainer" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 3,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 1,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Athletics/Tumble" => 3,
      "BODY/Athletics/Balance" => 3,
      "BODY/Athletics/Jump" => 2,
      "BODY/Sleight/Stage Magic" => 3,
      "MIND/Social Knowledge/Social lore" => 3,
      "MIND/Social Knowledge/Mythology" => 3,
      "MIND/Social Knowledge/Legend Lore" => 3,
      "MIND/Awareness/Sense Emotions" => 3
    },
    "melee_weapons" => {
      "Dagger" => 1,
      "Staff" => 2
    },
    "missile_weapons" => {
      "Throwing" => 2
    }
  },
  
  "Guard" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 4,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 4,
      "BODY/Missile Combat" => 3,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Endurance/Combat Tenacity" => 3,
      "BODY/Athletics/Dodge" => 2,
      "MIND/Awareness/Reaction speed" => 3,
      "MIND/Awareness/Detect Traps" => 3,
      "MIND/Awareness/Sense Ambush" => 3,
      "MIND/Awareness/Listening" => 3,
      "MIND/Willpower/Courage" => 3
    },
    "melee_weapons" => {
      "Spear" => 3,
      "Sword" => 3,
      "Shield" => 3,
      "Mace" => 2
    },
    "missile_weapons" => {
      "X-Bow" => 3,
      "Throwing" => 2
    }
  },
  
  "Scholar" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 3,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 1,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "MIND/Intelligence/Innovation" => 3,
      "MIND/Intelligence/Problem Solving" => 3,
      "MIND/Social Knowledge/Literacy" => 3,
      "MIND/Social Knowledge/Mythology" => 3,
      "MIND/Social Knowledge/Legend Lore" => 3,
      "MIND/Nature Knowledge/Medical lore" => 3,
      "MIND/Nature Knowledge/Alchemy" => 3,
      "MIND/Nature Knowledge/Magick Rituals" => 3
    },
    "melee_weapons" => {
      "Staff" => 1
    },
    "missile_weapons" => {}
  },
  
  "Bandit" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Hide" => 3,
      "BODY/Athletics/Ride" => 3,
      "BODY/Sleight/Pick pockets" => 2,
      "MIND/Practical Knowledge/Survival Lore" => 3,
      "MIND/Practical Knowledge/Ambush" => 3,
      "MIND/Awareness/Tracking" => 3
    },
    "melee_weapons" => {
      "Sword" => 3,
      "Axe" => 3,
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Bow" => 3,
      "Throwing" => 2
    }
  },
  
  "Farmer" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 4,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Strength/Carrying" => 3,
      "BODY/Endurance/Fortitude" => 3,
      "MIND/Nature Knowledge/Plant Lore" => 3,
      "MIND/Nature Knowledge/Animal Handling" => 3,
      "MIND/Nature Knowledge/Animal Lore" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 3,
      "MIND/Awareness/Sense of Direction" => 2
    },
    "melee_weapons" => {
      "Pitchfork" => 2,
      "Club" => 1,
      "Scythe" => 2
    },
    "missile_weapons" => {
      "Sling" => 2
    }
  },
  
  "Commoner" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Strength/Carrying" => 2,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Endurance/Running" => 2,
      "MIND/Practical Knowledge/Survival Lore" => 3,
      "MIND/Social Knowledge/Social lore" => 2
    },
    "melee_weapons" => {
      "Club" => 1,
      "Dagger" => 1
    },
    "missile_weapons" => {
      "Throwing" => 1
    }
  }
}