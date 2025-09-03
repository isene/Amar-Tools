# New 3-Tier System Structure for Amar RPG
# Characteristics > Attributes > Skills

$TierSystem = {
  "BODY" => {
    "Strength" => {
      "skills" => ["Carrying", "Weight lifting", "Wield weapon"],
      "base" => 3
    },
    "Endurance" => {
      "skills" => ["Fortitude", "Combat Tenacity", "Running", "Poison Resistance"],
      "base" => 3
    },
    "Athletics" => {
      "skills" => ["Hide", "Move Quietly", "Climb", "Swim", "Ride", "Jump", "Balance", "Tumble"],
      "base" => 3
    },
    "Melee Combat" => {
      "skills" => [], # Will be populated from existing melee weapons table
      "base" => 2
    },
    "Missile Combat" => {
      "skills" => [], # Will be populated from existing missile weapons table
      "base" => 2
    },
    "Sleight" => {
      "skills" => ["Pick pockets", "Stage Magic", "Disarm Traps"],
      "base" => 2
    }
  },
  "MIND" => {
    "Intelligence" => {
      "skills" => ["Innovation", "Problem Solving"],
      "base" => 3
    },
    "Nature Knowledge" => {
      "skills" => ["Medical lore", "Plant Lore", "Animal Lore", "Animal Handling", "Magick Rituals", "Alchemy"],
      "base" => 2
    },
    "Social Knowledge" => {
      "skills" => ["Social lore", "Spoken Language", "Literacy", "Mythology", "Legend Lore"],
      "base" => 2
    },
    "Practical Knowledge" => {
      "skills" => ["Survival Lore", "Set traps", "Ambush"],
      "base" => 2
    },
    "Awareness" => {
      "skills" => ["Reaction speed", "Tracking", "Detect Traps", "Sense Emotions", "Sense Ambush", "Sense of Direction", "Sense Magick", "Listening"],
      "base" => 3
    },
    "Willpower" => {
      "skills" => ["Pain Tolerance", "Courage", "Hold Breath", "Mental Fortitude"],
      "base" => 2
    }
  },
  "SPIRIT" => {
    "Casting" => {
      "skills" => ["Range", "Duration", "Area of Effect", "Weight", "Number of targets"],
      "base" => 0
    },
    "Attunement" => {
      "skills" => ["Fire", "Water", "Air", "Earth", "Life", "Death", "Mind", "Body", "Self"],
      "base" => 0
    },
    "Innate" => {
      "skills" => ["Flying", "Camouflage", "Shape Shifting"],
      "base" => 0
    },
    "Worship" => {
      "skills" => [], # Will be populated with gods/entities
      "base" => 0
    }
  }
}

# Mark requirements for advancement
$MarkRequirements = {
  "marks_per_level" => 5, # Marks needed = 5 * next_level
  "training_marks" => {
    "BODY" => {
      "with_teacher" => 2,
      "without_teacher" => 1
    },
    "MIND" => {
      "with_teacher" => 2,
      "without_teacher" => 0.5
    },
    "SPIRIT" => {
      "with_teacher" => 2,
      "without_teacher" => 0.5
    }
  },
  "conversion_rate" => 3, # 3 marks in lower tier = 1 mark in higher tier
  "use_mark" => 1, # 1 mark per skill use requiring roll
  "consecutive_use_bonus" => 2 # 5 consecutive uses = 2 marks
}

# Modifier calculations for new system
$NewModifiers = {
  "BP" => lambda { |size, fortitude| size * 2 + fortitude / 3 },
  "DB" => lambda { |size, wield_weapon| (size + wield_weapon) / 3 },
  "MD" => lambda { |mental_fortitude, attunement_self| (mental_fortitude + attunement_self) / 3 }
}