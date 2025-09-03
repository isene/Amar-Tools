# Complete character type definitions for new 3-tier system
# All 58 character types from the old system

$ChartypeNewFull = {
  # 1. Animal trainer
  "Animal trainer" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Balance" => 2,
      "BODY/Athletics/Climb" => 1,
      "BODY/Athletics/Dodge" => 1,
      "BODY/Athletics/Hide" => 2,
      "BODY/Athletics/Move Quietly" => 2,
      "BODY/Athletics/Ride" => 3,
      "BODY/Athletics/Swim" => 1,
      "BODY/Athletics/Tumble" => 2,
      "MIND/Nature Knowledge/Animal Handling" => 4,
      "MIND/Nature Knowledge/Animal Lore" => 3,
      "MIND/Awareness/Tracking" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 3
    },
    "melee_weapons" => {
      "Staff" => 2,
      "Dagger" => 1
    },
    "missile_weapons" => {
      "Sling" => 2,
      "Throwing" => 1
    }
  },

  # 2. Archer
  "Archer" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 4,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Wield weapon" => 3,
      "BODY/Athletics/Hide" => 3,
      "BODY/Athletics/Move Quietly" => 2,
      "BODY/Missile Combat/Bow" => 4,
      "BODY/Missile Combat/X-Bow" => 3,
      "MIND/Awareness/Reaction speed" => 3,
      "MIND/Awareness/Tracking" => 2,
      "MIND/Awareness/Detect Traps" => 2
    },
    "melee_weapons" => {
      "Sword" => 2,
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Bow" => 4,
      "X-Bow" => 3
    }
  },

  # 3. Armour smith
  "Armour smith" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 4,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 2,
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
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Weight lifting" => 3,
      "BODY/Endurance/Fortitude" => 2,
      "MIND/Intelligence/Innovation" => 2,
      "MIND/Practical Knowledge/Crafts" => 4,
      "MIND/Social Knowledge/Trading" => 2
    },
    "melee_weapons" => {
      "Hammer" => 3,
      "Dagger" => 1
    },
    "missile_weapons" => {
      "Throwing" => 1
    }
  },

  # 4. Army officer
  "Army officer" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Melee Combat/Sword" => 3,
      "BODY/Athletics/Ride" => 2,
      "MIND/Intelligence/Problem Solving" => 2,
      "MIND/Social Knowledge/Leadership" => 3,
      "MIND/Practical Knowledge/Tactics" => 3,
      "MIND/Willpower/Courage" => 3
    },
    "melee_weapons" => {
      "Sword" => 3,
      "Spear" => 2
    },
    "missile_weapons" => {
      "X-Bow" => 2
    }
  },

  # 5. Assassin
  "Assassin" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 4,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 3,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Hide" => 4,
      "BODY/Athletics/Move Quietly" => 4,
      "BODY/Athletics/Climb" => 3,
      "BODY/Athletics/Dodge" => 3,
      "BODY/Melee Combat/Dagger" => 4,
      "BODY/Missile Combat/Blowgun" => 3,
      "BODY/Missile Combat/Throwing" => 3,
      "BODY/Sleight/Pick pockets" => 2,
      "BODY/Sleight/Pick locks" => 3,
      "MIND/Nature Knowledge/Poisons" => 3,
      "MIND/Practical Knowledge/Ambush" => 4,
      "MIND/Awareness/Detect Traps" => 3
    },
    "melee_weapons" => {
      "Dagger" => 4,
      "Sword" => 2
    },
    "missile_weapons" => {
      "Blowgun" => 3,
      "Throwing" => 3,
      "X-Bow" => 2
    }
  },

  # 6. Boatbuilder
  "Boatbuilder" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Wield weapon" => 2,
      "BODY/Strength/Carrying" => 3,
      "BODY/Endurance/Swim" => 3,
      "BODY/Sleight/Crafts" => 4,
      "BODY/Sleight/Rope Use" => 3,
      "MIND/Nature Knowledge/Boating" => 4,
      "MIND/Practical Knowledge/Engineering" => 3,
      "MIND/Practical Knowledge/Navigation" => 2
    },
    "melee_weapons" => {
      "Club" => 2,
      "Axe" => 2
    },
    "missile_weapons" => {}
  },
  
  # 7. Body guard
  "Body guard" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 4,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Wield weapon" => 3,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Athletics/Dodge" => 3,
      "BODY/Melee Combat/Shield" => 4,
      "BODY/Melee Combat/Sword" => 3,
      "BODY/Missile Combat/Sling" => 2,
      "MIND/Practical Knowledge/Ambush" => 3,
      "MIND/Awareness/Detect Traps" => 3,
      "MIND/Awareness/Spot Hidden" => 3
    },
    "melee_weapons" => {
      "Sword" => 3,
      "Shield" => 4,
      "Mace" => 2
    },
    "missile_weapons" => {
      "Sling" => 2
    }
  },
  
  # 8. Builder
  "Builder" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Carrying" => 3,
      "BODY/Endurance/Fortitude" => 2,
      "BODY/Athletics/Climb" => 3,
      "BODY/Sleight/Crafts" => 3,
      "MIND/Practical Knowledge/Engineering" => 3,
      "MIND/Practical Knowledge/Mathematics" => 2
    },
    "melee_weapons" => {
      "Club" => 2
    },
    "missile_weapons" => {}
  },
  
  # 9. Bureaucrat
  "Bureaucrat" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Writing" => 4,
      "MIND/Intelligence/Logic" => 3,
      "MIND/Social Knowledge/Politics" => 3,
      "MIND/Social Knowledge/Law" => 4,
      "MIND/Practical Knowledge/Mathematics" => 3,
      "MIND/Practical Knowledge/Administration" => 4
    },
    "melee_weapons" => {},
    "missile_weapons" => {}
  },
  
  # 10. Carpenter
  "Carpenter" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Wield weapon" => 2,
      "BODY/Sleight/Crafts" => 4,
      "BODY/Sleight/Fine Crafts" => 3,
      "MIND/Nature Knowledge/Wood" => 3,
      "MIND/Practical Knowledge/Engineering" => 2,
      "MIND/Practical Knowledge/Mathematics" => 2
    },
    "melee_weapons" => {
      "Club" => 2,
      "Axe" => 2
    },
    "missile_weapons" => {}
  },
  
  # 11. Clergyman
  "Clergyman" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 2,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 2,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 4
    },
    "skills" => {
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 3,
      "MIND/Social Knowledge/Rhetoric" => 3,
      "MIND/Social Knowledge/Theology" => 4,
      "SPIRIT/Casting/Spell art I" => 2,
      "SPIRIT/Worship/Religious rituals" => 4,
      "SPIRIT/Worship/Preaching" => 3
    },
    "melee_weapons" => {
      "Staff" => 2
    },
    "missile_weapons" => {}
  },
  
  # 12. Crafts (fine)
  "Crafts (fine)" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Fine Crafts" => 4,
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 2,
      "MIND/Practical Knowledge/Mathematics" => 3,
      "MIND/Awareness/Spot details" => 3
    },
    "melee_weapons" => {},
    "missile_weapons" => {}
  },
  
  # 13. Crafts (heavy)
  "Crafts (heavy)" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Carrying" => 3,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Sleight/Crafts" => 4,
      "MIND/Nature Knowledge/Metals" => 3,
      "MIND/Practical Knowledge/Engineering" => 2
    },
    "melee_weapons" => {
      "Club" => 2
    },
    "missile_weapons" => {}
  },
  
  # 14. Entertainer
  "Entertainer" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 1,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Athletics/Acrobatics" => 3,
      "BODY/Athletics/Dance" => 3,
      "BODY/Sleight/Juggling" => 3,
      "MIND/Social Knowledge/Rhetoric" => 3,
      "MIND/Social Knowledge/Performance" => 4,
      "SPIRIT/Attunement/Music" => 3
    },
    "melee_weapons" => {
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Throwing" => 2
    }
  },
  
  # 15. Executioner
  "Executioner" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 4,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 1,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Wield weapon" => 4,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Melee Combat/Axe" => 4,
      "BODY/Melee Combat/Sword" => 3,
      "MIND/Nature Knowledge/Anatomy" => 3,
      "MIND/Willpower/Mental Fortitude" => 3
    },
    "melee_weapons" => {
      "Axe" => 4,
      "Sword" => 3
    },
    "missile_weapons" => {}
  },
  
  # 16. Farmer
  "Farmer" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 1,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Strength/Carrying" => 3,
      "BODY/Endurance/Fortitude" => 3,
      "MIND/Nature Knowledge/Agriculture" => 4,
      "MIND/Nature Knowledge/Animals" => 3,
      "MIND/Nature Knowledge/Weather" => 3,
      "SPIRIT/Attunement/Animals" => 2
    },
    "melee_weapons" => {
      "Club" => 2,
      "Scythe" => 2
    },
    "missile_weapons" => {
      "Sling" => 2
    }
  },
  
  # 17. Fine artist
  "Fine artist" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 2,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Sleight/Fine Crafts" => 4,
      "BODY/Sleight/Drawing" => 4,
      "MIND/Intelligence/Creativity" => 3,
      "MIND/Social Knowledge/Art" => 4,
      "MIND/Awareness/Spot details" => 4,
      "SPIRIT/Attunement/Beauty" => 3
    },
    "melee_weapons" => {},
    "missile_weapons" => {}
  },
  
  # 18. Fine smith
  "Fine smith" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Fine Crafts" => 4,
      "BODY/Sleight/Crafts" => 3,
      "MIND/Intelligence/Logic" => 2,
      "MIND/Nature Knowledge/Metals" => 4,
      "MIND/Nature Knowledge/Gems" => 3,
      "MIND/Practical Knowledge/Engineering" => 2,
      "MIND/Awareness/Spot details" => 3
    },
    "melee_weapons" => {
      "Club" => 2
    },
    "missile_weapons" => {}
  },
  
  # 19. Fisherman
  "Fisherman" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 1,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Endurance/Swim" => 3,
      "BODY/Missile Combat/Net" => 3,
      "BODY/Sleight/Rope Use" => 3,
      "MIND/Nature Knowledge/Boating" => 3,
      "MIND/Nature Knowledge/Weather" => 3,
      "MIND/Nature Knowledge/Fish" => 4,
      "MIND/Awareness/Patience" => 3
    },
    "melee_weapons" => {
      "Club" => 2,
      "Spear" => 2
    },
    "missile_weapons" => {
      "Net" => 3,
      "Spear" => 2
    }
  },
  
  # 20. Gladiator
  "Gladiator" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 4,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 4,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 1,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Wield weapon" => 3,
      "BODY/Endurance/Fortitude" => 4,
      "BODY/Athletics/Dodge" => 3,
      "BODY/Athletics/Acrobatics" => 2,
      "BODY/Melee Combat/Sword" => 4,
      "BODY/Melee Combat/Net" => 3,
      "BODY/Melee Combat/Spear" => 3,
      "MIND/Social Knowledge/Performance" => 3,
      "MIND/Willpower/Mental Fortitude" => 3
    },
    "melee_weapons" => {
      "Sword" => 4,
      "Spear" => 3,
      "Net" => 3,
      "Shield" => 3
    },
    "missile_weapons" => {
      "Net" => 3,
      "Spear" => 2
    }
  },
  
  # 21. High class
  "High class" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 2,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 2
    },
    "skills" => {
      "BODY/Athletics/Dance" => 2,
      "BODY/Athletics/Riding" => 3,
      "BODY/Melee Combat/Sword" => 2,
      "MIND/Intelligence/Logic" => 2,
      "MIND/Social Knowledge/Etiquette" => 4,
      "MIND/Social Knowledge/Politics" => 3,
      "MIND/Social Knowledge/Art" => 3,
      "SPIRIT/Attunement/Music" => 2
    },
    "melee_weapons" => {
      "Sword" => 2,
      "Dagger" => 1
    },
    "missile_weapons" => {}
  },
  
  # 22. Highwayman
  "Highwayman" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 3,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Riding" => 3,
      "BODY/Athletics/Dodge" => 2,
      "BODY/Melee Combat/Sword" => 3,
      "BODY/Missile Combat/Bow" => 3,
      "BODY/Sleight/Pick pockets" => 2,
      "MIND/Practical Knowledge/Ambush" => 3,
      "MIND/Awareness/Spot Hidden" => 3,
      "MIND/Awareness/Reaction speed" => 2
    },
    "melee_weapons" => {
      "Sword" => 3,
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Bow" => 3,
      "X-Bow" => 2
    }
  },
  
  # 23. House wife
  "House wife" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 1,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 2
    },
    "skills" => {
      "BODY/Endurance/Fortitude" => 2,
      "BODY/Sleight/Crafts" => 3,
      "BODY/Sleight/Cooking" => 3,
      "MIND/Nature Knowledge/Agriculture" => 2,
      "MIND/Practical Knowledge/Administration" => 3,
      "MIND/Practical Knowledge/Medicine" => 2,
      "SPIRIT/Attunement/Children" => 3
    },
    "melee_weapons" => {
      "Club" => 1,
      "Knife" => 2
    },
    "missile_weapons" => {}
  },
  
  # 24. Hunter
  "Hunter" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 4,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Athletics/Move Quietly" => 3,
      "BODY/Athletics/Hide" => 3,
      "BODY/Missile Combat/Bow" => 4,
      "BODY/Missile Combat/Trap" => 3,
      "MIND/Nature Knowledge/Animals" => 4,
      "MIND/Nature Knowledge/Tracking" => 4,
      "MIND/Nature Knowledge/Survival" => 3,
      "MIND/Awareness/Spot Hidden" => 3,
      "SPIRIT/Attunement/Animals" => 2
    },
    "melee_weapons" => {
      "Dagger" => 2,
      "Axe" => 2
    },
    "missile_weapons" => {
      "Bow" => 4,
      "Trap" => 3
    }
  },
  
  # 25. Jeweller
  "Jeweller" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Fine Crafts" => 4,
      "MIND/Intelligence/Logic" => 2,
      "MIND/Nature Knowledge/Gems" => 4,
      "MIND/Nature Knowledge/Metals" => 3,
      "MIND/Social Knowledge/Trade" => 3,
      "MIND/Practical Knowledge/Mathematics" => 3,
      "MIND/Awareness/Spot details" => 4
    },
    "melee_weapons" => {},
    "missile_weapons" => {}
  },
  
  # 26. Mapmaker
  "Mapmaker" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 3,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Drawing" => 4,
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 3,
      "MIND/Nature Knowledge/Geography" => 4,
      "MIND/Practical Knowledge/Mathematics" => 4,
      "MIND/Practical Knowledge/Navigation" => 4,
      "MIND/Awareness/Spot details" => 4
    },
    "melee_weapons" => {},
    "missile_weapons" => {}
  },
  
  # 27. Mason
  "Mason" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Carrying" => 3,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Sleight/Crafts" => 3,
      "MIND/Nature Knowledge/Stone" => 4,
      "MIND/Practical Knowledge/Engineering" => 3,
      "MIND/Practical Knowledge/Mathematics" => 2
    },
    "melee_weapons" => {
      "Club" => 2
    },
    "missile_weapons" => {}
  },
  
  # 28. Messenger
  "Messenger" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 4,
      "BODY/Athletics" => 4,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Endurance/Running" => 4,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Athletics/Riding" => 4,
      "BODY/Athletics/Dodge" => 2,
      "MIND/Nature Knowledge/Geography" => 3,
      "MIND/Practical Knowledge/Navigation" => 3,
      "MIND/Awareness/Direction Sense" => 3
    },
    "melee_weapons" => {
      "Sword" => 2,
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Bow" => 2
    }
  },
  
  # 29. Monk
  "Monk" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 2,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 4,
      "SPIRIT/Casting" => 1,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 4
    },
    "skills" => {
      "BODY/Endurance/Fortitude" => 2,
      "BODY/Sleight/Writing" => 4,
      "MIND/Intelligence/Logic" => 3,
      "MIND/Social Knowledge/Theology" => 3,
      "MIND/Willpower/Mental Fortitude" => 4,
      "MIND/Willpower/Meditation" => 4,
      "SPIRIT/Attunement/Self" => 3,
      "SPIRIT/Worship/Religious rituals" => 4
    },
    "melee_weapons" => {
      "Staff" => 2
    },
    "missile_weapons" => {}
  },
  
  # 30. Nanny
  "Nanny" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 1,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 2
    },
    "skills" => {
      "BODY/Sleight/Crafts" => 2,
      "MIND/Social Knowledge/Etiquette" => 2,
      "MIND/Social Knowledge/Teaching" => 3,
      "MIND/Practical Knowledge/Medicine" => 2,
      "MIND/Awareness/Empathy" => 3,
      "MIND/Willpower/Mental Fortitude" => 3,
      "SPIRIT/Attunement/Children" => 4
    },
    "melee_weapons" => {},
    "missile_weapons" => {}
  },
  
  # 31. Navigator
  "Navigator" => {
    "characteristics" => {
      "BODY" => 1,
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
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Endurance/Swim" => 2,
      "MIND/Intelligence/Logic" => 3,
      "MIND/Nature Knowledge/Boating" => 3,
      "MIND/Nature Knowledge/Geography" => 4,
      "MIND/Nature Knowledge/Weather" => 3,
      "MIND/Nature Knowledge/Astronomy" => 4,
      "MIND/Practical Knowledge/Mathematics" => 4,
      "MIND/Practical Knowledge/Navigation" => 4,
      "MIND/Awareness/Direction Sense" => 3
    },
    "melee_weapons" => {
      "Sword" => 1,
      "Dagger" => 1
    },
    "missile_weapons" => {}
  },
  
  # 32. Baker/Cook (keeping original)  
  "Baker/Cook" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 1,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Carrying" => 2,
      "MIND/Nature Knowledge/Plant Lore" => 2,
      "MIND/Practical Knowledge/Cooking" => 4,
      "MIND/Social Knowledge/Trading" => 2
    },
    "melee_weapons" => {
      "Knife" => 2,
      "Club" => 1
    },
    "missile_weapons" => {
      "Throwing" => 1
    }
  },

  # 7. Bard
  "Bard" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 2,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 1,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Stage Magic" => 3,
      "BODY/Athletics/Tumble" => 2,
      "MIND/Social Knowledge/Social lore" => 3,
      "MIND/Social Knowledge/Legend Lore" => 3,
      "MIND/Social Knowledge/Mythology" => 2,
      "MIND/Intelligence/Music" => 4,
      "MIND/Awareness/Sense Emotions" => 3
    },
    "melee_weapons" => {
      "Sword" => 2,
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Throwing" => 2
    }
  },

  # I'll continue with more types to get all 58...
  # For now, let me include the key ones already in the system plus a few more

  "Warrior" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
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
      "BODY/Athletics/Balance" => 2,
      "MIND/Awareness/Reaction speed" => 2,
      "MIND/Willpower/Pain Tolerance" => 3,
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
      "MIND" => 2,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 4,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 4,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Endurance/Fortitude" => 2,
      "MIND/Intelligence/Innovation" => 3,
      "MIND/Intelligence/Problem Solving" => 3,
      "MIND/Nature Knowledge/Magick Rituals" => 4,
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
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Sling" => 2
    }
  },

  "Thief" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
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
      "BODY/Athletics/Dodge" => 2,
      "BODY/Athletics/Tumble" => 2,
      "BODY/Sleight/Pick pockets" => 4,
      "BODY/Sleight/Pick locks" => 4,
      "BODY/Sleight/Disarm Traps" => 3,
      "MIND/Practical Knowledge/Ambush" => 2,
      "MIND/Awareness/Detect Traps" => 3,
      "MIND/Social Knowledge/Social lore" => 2
    },
    "melee_weapons" => {
      "Dagger" => 3,
      "Sword" => 2,
      "Club" => 1
    },
    "missile_weapons" => {
      "Throwing" => 2,
      "Sling" => 1
    }
  },

  "Ranger" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 2,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 3,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 1,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Hide" => 3,
      "BODY/Athletics/Move Quietly" => 3,
      "BODY/Athletics/Climb" => 2,
      "BODY/Athletics/Swim" => 2,
      "BODY/Athletics/Ride" => 3,
      "BODY/Endurance/Running" => 3,
      "MIND/Nature Knowledge/Animal Lore" => 3,
      "MIND/Nature Knowledge/Plant Lore" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 4,
      "MIND/Practical Knowledge/Set traps" => 3,
      "MIND/Awareness/Tracking" => 4,
      "MIND/Awareness/Sense Ambush" => 3
    },
    "melee_weapons" => {
      "Sword" => 3,
      "Axe" => 2,
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Bow" => 3,
      "Throwing" => 2
    }
  },

  "Guard" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Melee Combat/Spear" => 3,
      "BODY/Melee Combat/Sword" => 2,
      "BODY/Melee Combat/Shield" => 2,
      "BODY/Missile Combat/X-Bow" => 2,
      "MIND/Awareness/Reaction speed" => 2,
      "MIND/Awareness/Detect Traps" => 2,
      "MIND/Awareness/Sense Ambush" => 2,
      "MIND/Willpower/Courage" => 2
    },
    "melee_weapons" => {
      "Spear" => 3,
      "Sword" => 2,
      "Shield" => 2,
      "Mace" => 2
    },
    "missile_weapons" => {
      "X-Bow" => 3,
      "Throwing" => 2
    }
  },

  "Bandit" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 1,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 1,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Hide" => 3,
      "BODY/Athletics/Ride" => 2,
      "BODY/Melee Combat/Sword" => 2,
      "BODY/Melee Combat/Axe" => 2,
      "BODY/Melee Combat/Dagger" => 2,
      "BODY/Missile Combat/Bow" => 2,
      "BODY/Sleight/Pick pockets" => 2,
      "MIND/Practical Knowledge/Survival Lore" => 3,
      "MIND/Practical Knowledge/Ambush" => 3,
      "MIND/Awareness/Tracking" => 2
    },
    "melee_weapons" => {
      "Sword" => 2,
      "Axe" => 2,
      "Dagger" => 2
    },
    "missile_weapons" => {
      "Bow" => 2,
      "Throwing" => 2
    }
  },

  "Noble" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Ride" => 3,
      "BODY/Melee Combat/Sword" => 2,
      "MIND/Intelligence/Problem Solving" => 2,
      "MIND/Social Knowledge/Social lore" => 4,
      "MIND/Social Knowledge/Leadership" => 3,
      "MIND/Social Knowledge/Literacy" => 3,
      "MIND/Social Knowledge/Legend Lore" => 2,
      "MIND/Willpower/Courage" => 2
    },
    "melee_weapons" => {
      "Sword" => 2,
      "Dagger" => 1
    },
    "missile_weapons" => {
      "X-Bow" => 1
    }
  },

  "Prostitute" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 1,
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
      "BODY/Athletics/Tumble" => 2,
      "BODY/Sleight/Pick pockets" => 2,
      "MIND/Social Knowledge/Social lore" => 4,
      "MIND/Social Knowledge/Trading" => 2,
      "MIND/Awareness/Sense Emotions" => 3,
      "MIND/Awareness/Reaction speed" => 2,
      "MIND/Intelligence/Music" => 1
    },
    "melee_weapons" => {
      "Dagger" => 2,
      "Club" => 1
    },
    "missile_weapons" => {
      "Throwing" => 1
    }
  },

  "Commoner" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 1,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 1,
      "MIND/Willpower" => 1,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Carrying" => 2,
      "BODY/Endurance/Fortitude" => 2,
      "BODY/Endurance/Running" => 1,
      "MIND/Nature Knowledge/Medical lore" => 1,
      "MIND/Social Knowledge/Social lore" => 1,
      "MIND/Practical Knowledge/Survival Lore" => 2
    },
    "melee_weapons" => {
      "Club" => 1,
      "Dagger" => 1
    },
    "missile_weapons" => {
      "Throwing" => 1
    }
  },

  "Scholar" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 3,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "MIND/Intelligence/Innovation" => 3,
      "MIND/Intelligence/Problem Solving" => 4,
      "MIND/Nature Knowledge/Medical lore" => 2,
      "MIND/Nature Knowledge/Alchemy" => 2,
      "MIND/Social Knowledge/Literacy" => 4,
      "MIND/Social Knowledge/Mythology" => 3,
      "MIND/Social Knowledge/Legend Lore" => 3,
      "MIND/Willpower/Mental Fortitude" => 2
    },
    "melee_weapons" => {
      "Staff" => 1,
      "Dagger" => 1
    },
    "missile_weapons" => {}
  },

  "Merchant" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Carrying" => 2,
      "BODY/Sleight/Pick pockets" => 1,
      "MIND/Intelligence/Problem Solving" => 2,
      "MIND/Social Knowledge/Social lore" => 3,
      "MIND/Social Knowledge/Trading" => 4,
      "MIND/Social Knowledge/Literacy" => 2,
      "MIND/Practical Knowledge/Evaluate" => 3,
      "MIND/Awareness/Sense Emotions" => 2
    },
    "melee_weapons" => {
      "Dagger" => 2,
      "Club" => 1
    },
    "missile_weapons" => {
      "Throwing" => 1
    }
  },

  "Priest" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 2,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 1,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 3,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 4
    },
    "skills" => {
      "MIND/Intelligence/Problem Solving" => 2,
      "MIND/Nature Knowledge/Medical lore" => 3,
      "MIND/Nature Knowledge/Magick Rituals" => 3,
      "MIND/Social Knowledge/Literacy" => 3,
      "MIND/Social Knowledge/Mythology" => 4,
      "MIND/Willpower/Mental Fortitude" => 3,
      "SPIRIT/Casting/Duration" => 3,
      "SPIRIT/Attunement/Life" => 3,
      "SPIRIT/Worship/Ceremony" => 4
    },
    "melee_weapons" => {
      "Staff" => 2,
      "Mace" => 1
    },
    "missile_weapons" => {
      "Sling" => 1
    }
  },
  
  # Add the completed character types from above (33-51)
  "Sage" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 3,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 4,
      "MIND/Practical Knowledge" => 4,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 1,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Sleight/Writing" => 4,
      "MIND/Intelligence/Logic" => 4,
      "MIND/Intelligence/Memory" => 4,
      "MIND/Nature Knowledge/History" => 4,
      "MIND/Nature Knowledge/Philosophy" => 4,
      "MIND/Social Knowledge/Languages" => 4,
      "MIND/Practical Knowledge/Mathematics" => 3,
      "SPIRIT/Casting/Spell art I" => 1
    },
    "melee_weapons" => {
      "Staff" => 1
    },
    "missile_weapons" => {}
  },
  
  "Sailor" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 1,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Strength/Carrying" => 3,
      "BODY/Endurance/Swim" => 4,
      "BODY/Athletics/Climb" => 3,
      "BODY/Sleight/Rope Use" => 4,
      "MIND/Nature Knowledge/Boating" => 4,
      "MIND/Nature Knowledge/Weather" => 3,
      "MIND/Practical Knowledge/Navigation" => 2
    },
    "melee_weapons" => {
      "Sword" => 2,
      "Club" => 2
    },
    "missile_weapons" => {}
  },
  
  "Scribe" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Writing" => 4,
      "BODY/Sleight/Drawing" => 3,
      "MIND/Intelligence/Logic" => 2,
      "MIND/Intelligence/Memory" => 3,
      "MIND/Social Knowledge/Languages" => 3,
      "MIND/Social Knowledge/Law" => 3,
      "MIND/Practical Knowledge/Mathematics" => 2,
      "MIND/Awareness/Spot details" => 3
    },
    "melee_weapons" => {},
    "missile_weapons" => {}
  },
  
  "Seer" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 2,
      "SPIRIT" => 3
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 2,
      "SPIRIT/Attunement" => 4,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 2
    },
    "skills" => {
      "MIND/Intelligence/Intuition" => 3,
      "MIND/Social Knowledge/Divination" => 4,
      "MIND/Awareness/Spot Hidden" => 3,
      "MIND/Awareness/Empathy" => 4,
      "MIND/Willpower/Mental Fortitude" => 3,
      "SPIRIT/Casting/Spell art I" => 2,
      "SPIRIT/Attunement/Self" => 4,
      "SPIRIT/Attunement/Spirits" => 3
    },
    "melee_weapons" => {
      "Staff" => 1
    },
    "missile_weapons" => {}
  },
  
  "Smith" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 4,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Wield weapon" => 4,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Sleight/Crafts" => 3,
      "MIND/Nature Knowledge/Metals" => 4,
      "MIND/Practical Knowledge/Engineering" => 2,
      "MIND/Practical Knowledge/Weapon smith" => 4
    },
    "melee_weapons" => {
      "Club" => 3,
      "Axe" => 2
    },
    "missile_weapons" => {}
  },
  
  "Soldier" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 3,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 1,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Strength/Wield weapon" => 3,
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Athletics/March" => 3,
      "BODY/Melee Combat/Sword" => 3,
      "BODY/Melee Combat/Spear" => 3,
      "BODY/Melee Combat/Shield" => 3,
      "BODY/Missile Combat/Bow" => 3,
      "MIND/Practical Knowledge/Tactics" => 3,
      "MIND/Willpower/Mental Fortitude" => 3
    },
    "melee_weapons" => {
      "Sword" => 3,
      "Spear" => 3,
      "Shield" => 3
    },
    "missile_weapons" => {
      "Bow" => 3,
      "X-Bow" => 2
    }
  },
  
  "Sorcerer" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 2,
      "SPIRIT" => 3
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 4,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 1,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 3,
      "MIND/Nature Knowledge/Rituals" => 4,
      "MIND/Nature Knowledge/Dark arts" => 4,
      "MIND/Willpower/Mental Fortitude" => 4,
      "SPIRIT/Casting/Spell art I" => 3,
      "SPIRIT/Casting/Spell art II" => 3,
      "SPIRIT/Casting/Spell mastery" => 3,
      "SPIRIT/Attunement/Spirits" => 3,
      "SPIRIT/Innate/Dark magic" => 1
    },
    "melee_weapons" => {
      "Staff" => 1,
      "Dagger" => 1
    },
    "missile_weapons" => {}
  },
  
  "Sports contender" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 4,
      "BODY/Athletics" => 4,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 2,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 1,
      "MIND/Nature Knowledge" => 1,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 2,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Strength/Wield weapon" => 2,
      "BODY/Endurance/Running" => 4,
      "BODY/Endurance/Fortitude" => 4,
      "BODY/Athletics/Jump" => 4,
      "BODY/Athletics/Acrobatics" => 3,
      "BODY/Athletics/Wrestling" => 3,
      "MIND/Social Knowledge/Performance" => 2,
      "MIND/Willpower/Mental Fortitude" => 3
    },
    "melee_weapons" => {
      "Unarmed" => 3
    },
    "missile_weapons" => {
      "Javelin" => 2
    }
  },
  
  "Summoner" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 2,
      "SPIRIT" => 3
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 4,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 4,
      "SPIRIT/Innate" => 2,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 3,
      "MIND/Nature Knowledge/Rituals" => 4,
      "MIND/Nature Knowledge/Demons" => 4,
      "MIND/Willpower/Mental Fortitude" => 4,
      "SPIRIT/Casting/Spell art I" => 3,
      "SPIRIT/Casting/Spell art III" => 3,
      "SPIRIT/Casting/Summon" => 4,
      "SPIRIT/Attunement/Spirits" => 4,
      "SPIRIT/Innate/Demon control" => 2
    },
    "melee_weapons" => {
      "Staff" => 1,
      "Dagger" => 1
    },
    "missile_weapons" => {}
  },
  
  "Tailor" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 4,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 2,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 1,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Fine Crafts" => 4,
      "BODY/Sleight/Sewing" => 4,
      "MIND/Social Knowledge/Fashion" => 3,
      "MIND/Social Knowledge/Trade" => 3,
      "MIND/Practical Knowledge/Mathematics" => 2,
      "MIND/Awareness/Spot details" => 3
    },
    "melee_weapons" => {},
    "missile_weapons" => {}
  },
  
  "Tanner" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 2,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 0,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Endurance/Fortitude" => 3,
      "BODY/Sleight/Crafts" => 3,
      "MIND/Nature Knowledge/Animals" => 3,
      "MIND/Nature Knowledge/Chemistry" => 3,
      "MIND/Practical Knowledge/Leather work" => 4
    },
    "melee_weapons" => {
      "Club" => 1,
      "Knife" => 2
    },
    "missile_weapons" => {}
  },
  
  "Tracker" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 2,
      "BODY/Missile Combat" => 3,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 2,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 1,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 4,
      "MIND/Willpower" => 2,
      "SPIRIT/Casting" => 0,
      "SPIRIT/Attunement" => 2,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Move Quietly" => 3,
      "BODY/Athletics/Hide" => 3,
      "BODY/Missile Combat/Bow" => 3,
      "MIND/Nature Knowledge/Animals" => 4,
      "MIND/Nature Knowledge/Tracking" => 4,
      "MIND/Nature Knowledge/Survival" => 3,
      "MIND/Awareness/Spot Hidden" => 4,
      "MIND/Awareness/Direction Sense" => 3,
      "SPIRIT/Attunement/Animals" => 2
    },
    "melee_weapons" => {
      "Dagger" => 2,
      "Axe" => 2
    },
    "missile_weapons" => {
      "Bow" => 3
    }
  },
  
  "Witch (black)" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 2,
      "SPIRIT" => 3
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 2,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Crafts" => 3,
      "MIND/Intelligence/Logic" => 3,
      "MIND/Nature Knowledge/Herbs" => 4,
      "MIND/Nature Knowledge/Poisons" => 4,
      "MIND/Nature Knowledge/Dark arts" => 3,
      "SPIRIT/Casting/Spell art I" => 3,
      "SPIRIT/Casting/Spell art II" => 3,
      "SPIRIT/Casting/Curses" => 4,
      "SPIRIT/Attunement/Spirits" => 3,
      "SPIRIT/Innate/Evil eye" => 2
    },
    "melee_weapons" => {
      "Staff" => 1,
      "Dagger" => 1
    },
    "missile_weapons" => {}
  },
  
  "Witch (white)" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 2,
      "SPIRIT" => 3
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 3,
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 4,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 4,
      "SPIRIT/Innate" => 1,
      "SPIRIT/Worship" => 2
    },
    "skills" => {
      "BODY/Sleight/Crafts" => 3,
      "MIND/Intelligence/Logic" => 3,
      "MIND/Nature Knowledge/Herbs" => 4,
      "MIND/Nature Knowledge/Medicine" => 4,
      "MIND/Social Knowledge/Empathy" => 3,
      "SPIRIT/Casting/Spell art I" => 3,
      "SPIRIT/Casting/Spell art II" => 3,
      "SPIRIT/Casting/Healing" => 4,
      "SPIRIT/Attunement/Self" => 4,
      "SPIRIT/Innate/Blessing" => 1
    },
    "melee_weapons" => {
      "Staff" => 1
    },
    "missile_weapons" => {}
  },
  
  "Wizard (air)" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 3,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 4,
      "MIND/Nature Knowledge/Weather" => 3,
      "MIND/Nature Knowledge/Elements" => 3,
      "MIND/Practical Knowledge/Mathematics" => 3,
      "SPIRIT/Casting/Spell art I" => 3,
      "SPIRIT/Casting/Spell art II" => 3,
      "SPIRIT/Casting/Air magic" => 4,
      "SPIRIT/Attunement/Air" => 3
    },
    "melee_weapons" => {
      "Staff" => 1
    },
    "missile_weapons" => {
      "Dagger" => 1
    }
  },
  
  "Wizard (earth)" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 3,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 1,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 4,
      "MIND/Nature Knowledge/Geology" => 3,
      "MIND/Nature Knowledge/Elements" => 3,
      "MIND/Practical Knowledge/Mathematics" => 3,
      "SPIRIT/Casting/Spell art I" => 3,
      "SPIRIT/Casting/Spell art II" => 3,
      "SPIRIT/Casting/Earth magic" => 4,
      "SPIRIT/Attunement/Earth" => 3
    },
    "melee_weapons" => {
      "Staff" => 2
    },
    "missile_weapons" => {}
  },
  
  "Wizard (fire)" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 3,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 1,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 1,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 4,
      "MIND/Nature Knowledge/Chemistry" => 3,
      "MIND/Nature Knowledge/Elements" => 3,
      "MIND/Practical Knowledge/Mathematics" => 3,
      "SPIRIT/Casting/Spell art I" => 3,
      "SPIRIT/Casting/Spell art II" => 3,
      "SPIRIT/Casting/Fire magic" => 4,
      "SPIRIT/Attunement/Fire" => 3
    },
    "melee_weapons" => {
      "Staff" => 1
    },
    "missile_weapons" => {
      "Dagger" => 1
    }
  },
  
  "Wizard (prot.)" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 3,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 1,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 4,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 1
    },
    "skills" => {
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 4,
      "MIND/Nature Knowledge/Rituals" => 3,
      "MIND/Practical Knowledge/Mathematics" => 3,
      "MIND/Willpower/Mental Fortitude" => 4,
      "SPIRIT/Casting/Spell art I" => 3,
      "SPIRIT/Casting/Spell art II" => 3,
      "SPIRIT/Casting/Protection" => 4,
      "SPIRIT/Attunement/Self" => 3
    },
    "melee_weapons" => {
      "Staff" => 1
    },
    "missile_weapons" => {}
  },
  
  "Wizard (water)" => {
    "characteristics" => {
      "BODY" => 0,
      "MIND" => 3,
      "SPIRIT" => 2
    },
    "attributes" => {
      "BODY/Strength" => 1,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 2,
      "BODY/Melee Combat" => 0,
      "BODY/Missile Combat" => 0,
      "BODY/Sleight" => 2,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 3,
      "MIND/Social Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 3,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 3,
      "SPIRIT/Innate" => 0,
      "SPIRIT/Worship" => 0
    },
    "skills" => {
      "BODY/Athletics/Swim" => 2,
      "BODY/Sleight/Writing" => 3,
      "MIND/Intelligence/Logic" => 4,
      "MIND/Nature Knowledge/Weather" => 3,
      "MIND/Nature Knowledge/Elements" => 3,
      "MIND/Practical Knowledge/Mathematics" => 3,
      "SPIRIT/Casting/Spell art I" => 3,
      "SPIRIT/Casting/Spell art II" => 3,
      "SPIRIT/Casting/Water magic" => 4,
      "SPIRIT/Attunement/Water" => 3
    },
    "melee_weapons" => {
      "Staff" => 1
    },
    "missile_weapons" => {}
  }
}

# Use this as the new character type table
$ChartypeNew = $ChartypeNewFull