# Race-based character templates for encounters in Amar
# Based on the demographics: Elves, Dwarves, Goblins, Lizardmen, Centaurs, Ogres, Trollkins, Trolls, Araxi, Faeries

$RaceTemplates = {
  "Elf: Warrior" => {
    "characteristics" => {
      "BODY" => 2,  # Elves are agile but not as strong
      "MIND" => 3,  # More intelligent than average
      "SPIRIT" => 1  # Some magical affinity
    },
    "attributes" => {
      "BODY/Strength" => 2,
      "BODY/Endurance" => 2,
      "BODY/Athletics" => 4,  # Very agile
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 4,  # Excellent archers
      "MIND/Intelligence" => 3,
      "MIND/Awareness" => 4,  # Keen senses
      "MIND/Willpower" => 2
    },
    "skills" => {
      "BODY/Missile Combat/Bow" => 3,
      "BODY/Melee Combat/Sword" => 2,
      "BODY/Athletics/Dodge" => 2,
      "MIND/Awareness/Alertness" => 2
    }
  },
  
  "Elf: Ranger" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 3,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Athletics" => 4,
      "BODY/Missile Combat" => 4,
      "MIND/Nature Knowledge" => 3,
      "MIND/Practical Knowledge" => 3,
      "MIND/Awareness" => 4
    },
    "skills" => {
      "BODY/Missile Combat/Bow" => 3,
      "BODY/Athletics/Move Quietly" => 3,
      "MIND/Awareness/Tracking" => 3,
      "MIND/Practical Knowledge/Survival Lore" => 2
    }
  },
  
  "Elf: Mage" => {
    "characteristics" => {
      "BODY" => 1,
      "MIND" => 3,
      "SPIRIT" => 3  # High magical affinity
    },
    "attributes" => {
      "BODY/Athletics" => 3,
      "MIND/Intelligence" => 4,
      "MIND/Nature Knowledge" => 4,
      "SPIRIT/Casting" => 3,
      "SPIRIT/Attunement" => 3
    },
    "skills" => {
      "SPIRIT/Attunement/Life" => 2,
      "SPIRIT/Attunement/Mind" => 2,
      "MIND/Nature Knowledge/Magick Rituals" => 2
    }
  },
  
  "Dwarf: Warrior" => {
    "characteristics" => {
      "BODY" => 3,  # Strong and sturdy
      "MIND" => 2,
      "SPIRIT" => 0  # No magic
    },
    "attributes" => {
      "BODY/Strength" => 4,
      "BODY/Endurance" => 5,  # Very tough
      "BODY/Melee Combat" => 4,
      "BODY/Missile Combat" => 2,
      "MIND/Practical Knowledge" => 3,
      "MIND/Willpower" => 4  # Stubborn
    },
    "skills" => {
      "BODY/Melee Combat/Axe" => 3,
      "BODY/Melee Combat/Shield" => 2,
      "BODY/Endurance/Fortitude" => 2
    }
  },
  
  "Dwarf: Smith" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 5,
      "BODY/Endurance" => 4,
      "BODY/Sleight" => 3,  # Craftsmanship
      "MIND/Intelligence" => 2,
      "MIND/Practical Knowledge" => 4
    },
    "skills" => {
      "BODY/Melee Combat/Hammer" => 2,
      "BODY/Strength/Weight lifting" => 2,
      "MIND/Practical Knowledge/Smithing" => 4
    }
  },
  
  "Dwarf: Guard" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 4,
      "BODY/Endurance" => 5,
      "BODY/Melee Combat" => 3,
      "MIND/Awareness" => 3,
      "MIND/Willpower" => 4
    },
    "skills" => {
      "BODY/Melee Combat/Spear" => 2,
      "BODY/Melee Combat/Shield" => 3,
      "MIND/Awareness/Alertness" => 3
    }
  },
  
  "Araxi: Warrior" => {
    "characteristics" => {
      "BODY" => 4,  # Savage and strong
      "MIND" => 1,  # Not very intelligent
      "SPIRIT" => 0  # No magic
    },
    "attributes" => {
      "BODY/Strength" => 4,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,
      "BODY/Melee Combat" => 4,
      "MIND/Awareness" => 3,  # Good hunters
      "MIND/Willpower" => 2
    },
    "skills" => {
      "BODY/Melee Combat/Unarmed" => 3,  # Claws/teeth
      "BODY/Athletics/Hide" => 2,
      "MIND/Awareness/Tracking" => 2
    }
  },
  
  "Troll: Warrior" => {
    "characteristics" => {
      "BODY" => 5,  # Very large and strong
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 6,
      "BODY/Endurance" => 5,
      "BODY/Melee Combat" => 3,
      "MIND/Willpower" => 1
    },
    "skills" => {
      "BODY/Melee Combat/Club" => 3,
      "BODY/Strength/Carrying" => 3
    }
  },
  
  "Ogre: Warrior" => {
    "characteristics" => {
      "BODY" => 4,
      "MIND" => 1,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 5,
      "BODY/Endurance" => 4,
      "BODY/Melee Combat" => 3,
      "MIND/Awareness" => 2
    },
    "skills" => {
      "BODY/Melee Combat/Club" => 2,
      "BODY/Melee Combat/Unarmed" => 2
    }
  },
  
  "Lizard Man: Warrior" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 3,
      "BODY/Endurance" => 3,
      "BODY/Athletics" => 3,  # Good swimmers
      "BODY/Melee Combat" => 3,
      "MIND/Awareness" => 3
    },
    "skills" => {
      "BODY/Melee Combat/Spear" => 2,
      "BODY/Athletics/Swim" => 3,
      "BODY/Athletics/Hide" => 2
    }
  },
  
  "Goblin: Warrior" => {
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
      "MIND/Awareness" => 3
    },
    "skills" => {
      "BODY/Melee Combat/Sword" => 1,
      "BODY/Athletics/Hide" => 2,
      "BODY/Athletics/Move Quietly" => 2
    }
  },
  
  "Goblin: Thief" => {
    "characteristics" => {
      "BODY" => 2,
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Athletics" => 4,
      "BODY/Sleight" => 3,
      "MIND/Awareness" => 3,
      "MIND/Practical Knowledge" => 2
    },
    "skills" => {
      "BODY/Athletics/Hide" => 3,
      "BODY/Athletics/Move Quietly" => 3,
      "BODY/Sleight/Pick pockets" => 2,
      "MIND/Awareness/Alertness" => 2
    }
  },
  
  "Centaur: Warrior" => {
    "characteristics" => {
      "BODY" => 4,  # Horse body = strong
      "MIND" => 2,
      "SPIRIT" => 0
    },
    "attributes" => {
      "BODY/Strength" => 4,
      "BODY/Endurance" => 4,
      "BODY/Athletics" => 3,  # Fast runners
      "BODY/Melee Combat" => 3,
      "BODY/Missile Combat" => 3,
      "MIND/Nature Knowledge" => 2
    },
    "skills" => {
      "BODY/Melee Combat/Spear" => 2,
      "BODY/Missile Combat/Bow" => 2,
      "BODY/Endurance/Running" => 3
    }
  },
  
  "Centaur: Ranger" => {
    "characteristics" => {
      "BODY" => 3,
      "MIND" => 2,
      "SPIRIT" => 1
    },
    "attributes" => {
      "BODY/Athletics" => 4,
      "BODY/Missile Combat" => 4,
      "MIND/Nature Knowledge" => 3,
      "MIND/Awareness" => 3
    },
    "skills" => {
      "BODY/Missile Combat/Bow" => 3,
      "BODY/Endurance/Running" => 3,
      "MIND/Awareness/Tracking" => 2,
      "MIND/Nature Knowledge/Plant Lore" => 2
    }
  },
  
  "Faerie: Mage" => {
    "characteristics" => {
      "BODY" => 1,  # Tiny and weak
      "MIND" => 3,
      "SPIRIT" => 4  # Highly magical
    },
    "attributes" => {
      "BODY/Athletics" => 5,  # Can fly
      "MIND/Intelligence" => 3,
      "MIND/Nature Knowledge" => 4,
      "SPIRIT/Casting" => 4,
      "SPIRIT/Attunement" => 4,
      "SPIRIT/Innate" => 3
    },
    "skills" => {
      "SPIRIT/Innate/Flying" => 5,
      "SPIRIT/Attunement/Life" => 3,
      "BODY/Athletics/Dodge" => 3,
      "MIND/Nature Knowledge/Plant Lore" => 3
    }
  }
}

# Merge race templates into the main character type table
if defined?($ChartypeNew)
  $ChartypeNew.merge!($RaceTemplates)
else
  $ChartypeNew = $RaceTemplates
end