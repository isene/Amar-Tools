# Creative Spell Catalog for 3-Tier System
# Revolutionary flexible magic system with unique, creative spells

$SpellCatalog = {
  # FIRE MAGIC - Usually cast via Spirit->Casting->Fire
  "Crimson Burst" => {
    description: "A red fireball that leaves lingering embers",
    skill_path: ["Spirit", "Attunement", "Fire"],
    difficulty: 10,
    cooldown: 3,
    range: "30m",
    duration: "Instant",
    side_effects: "Caster's hands glow red for 1 hour"
  },

  "Blue Fireball" => {
    description: "Cold fire that burns but doesn't spread flames",
    skill_path: ["Spirit", "Attunement", "Fire"],
    difficulty: 12,
    cooldown: 2,
    range: "25m",
    duration: "Instant",
    side_effects: "Target feels cold for 10 minutes"
  },

  "Forge Heart" => {
    description: "Heats metal objects to forging temperature",
    skill_path: ["Spirit", "Attunement", "Fire"],
    difficulty: 8,
    cooldown: 1,
    range: "Touch",
    duration: "1 hour",
    side_effects: "Caster immune to cold for duration"
  },

  # WATER/ICE MAGIC
  "Frostbite Touch" => {
    description: "Freezes water on contact, gives caster a cold",
    skill_path: ["Spirit", "Attunement", "Water"],
    difficulty: 9,
    cooldown: 4,
    range: "Touch",
    duration: "Permanent",
    side_effects: "Caster sneezes for 2 hours"
  },

  "Misty Veil" => {
    description: "Creates concealing fog around caster",
    skill_path: ["Spirit", "Attunement", "Water"],
    difficulty: 7,
    cooldown: 2,
    range: "Self",
    duration: "10 minutes",
    side_effects: "Caster's clothes become damp"
  },

  # AIR/WIND MAGIC
  "Seeking Arrow" => {
    description: "Enchants projectile to seek specific target types",
    skill_path: ["Body", "Missile Combat", "Archery", "Spirit", "Casting", "Air"],
    difficulty: 15,
    cooldown: 5,
    range: "Weapon range",
    duration: "1 shot",
    side_effects: "Caster feels dizzy for 1 hour"
  },

  "Whisper Wind" => {
    description: "Carries a message on the wind to distant target",
    skill_path: ["Spirit", "Attunement", "Air"],
    difficulty: 11,
    cooldown: 1,
    range: "10 km",
    duration: "Instant",
    side_effects: "Caster loses voice for 10 minutes"
  },

  # EARTH MAGIC
  "Stone Skin" => {
    description: "Hardens skin like granite, reduces damage",
    skill_path: ["Spirit", "Attunement", "Earth"],
    difficulty: 13,
    cooldown: 6,
    range: "Self",
    duration: "1 hour",
    side_effects: "Movement reduced by half"
  },

  "Tremor Step" => {
    description: "Each footstep creates small earthquake",
    skill_path: ["Spirit", "Attunement", "Earth"],
    difficulty: 16,
    cooldown: 8,
    range: "Self",
    duration: "10 minutes",
    side_effects: "Caster can't sneak for 1 day"
  },

  # MIND MAGIC
  "Memory Thief" => {
    description: "Steals one specific memory from target",
    skill_path: ["Mind", "Social Knowledge", "Deception", "Spirit", "Casting", "Mind"],
    difficulty: 18,
    cooldown: 12,
    range: "Touch",
    duration: "Permanent",
    side_effects: "Caster gains the stolen memory"
  },

  "Confusion Aura" => {
    description: "Enemies in area attack randomly",
    skill_path: ["Spirit", "Attunement", "Mind"],
    difficulty: 14,
    cooldown: 4,
    range: "10m radius",
    duration: "5 minutes",
    side_effects: "Caster also confused for 1 minute"
  },

  # CREATIVE/UNIQUE SPELLS
  "Dancer's Grace" => {
    description: "Supernatural agility if Dancing roll 13+",
    skill_path: ["Body", "Performance", "Dancing"],
    difficulty: 13,
    cooldown: 2,
    range: "Self",
    duration: "1 hour",
    side_effects: "Must keep dancing or spell ends"
  },

  "Lucky Coin" => {
    description: "Enchants coin to always land on chosen side",
    skill_path: ["Spirit", "Attunement", "Fate"],
    difficulty: 6,
    cooldown: 1,
    range: "Touch",
    duration: "10 flips",
    side_effects: "Caster has bad luck for 1 day"
  },

  "Shadow Step" => {
    description: "Teleport between shadows up to 50 meters",
    skill_path: ["Spirit", "Attunement", "Shadow"],
    difficulty: 12,
    cooldown: 3,
    range: "50m",
    duration: "Instant",
    side_effects: "Caster loses 1 point of temporary strength"
  },

  "Beast Speech" => {
    description: "Communicate with animals of chosen type",
    skill_path: ["Mind", "Awareness", "Nature Knowledge", "Spirit", "Casting", "Nature"],
    difficulty: 9,
    cooldown: 1,
    range: "100m",
    duration: "1 hour",
    side_effects: "Caster makes animal sounds when talking"
  },

  "Time Pocket" => {
    description: "Small area experiences slower time flow",
    skill_path: ["Spirit", "Attunement", "Time"],
    difficulty: 20,
    cooldown: 24,
    range: "3m radius",
    duration: "10 minutes",
    side_effects: "Caster ages 1 year"
  },

  "Emotion Echo" => {
    description: "Target feels caster's current emotions intensely",
    skill_path: ["Mind", "Social Knowledge", "Empathy", "Spirit", "Casting", "Mind"],
    difficulty: 10,
    cooldown: 2,
    range: "Line of sight",
    duration: "1 hour",
    side_effects: "Emotions amplified for both"
  },

  # HEALING MAGIC
  "Gentle Mend" => {
    description: "Heals minor wounds and bruises",
    skill_path: ["Spirit", "Attunement", "Life"],
    difficulty: 8,
    cooldown: 1,
    range: "Touch",
    duration: "Instant",
    side_effects: "Caster feels target's pain briefly"
  },

  "Life Link" => {
    description: "Share life force between caster and target",
    skill_path: ["Spirit", "Attunement", "Life"],
    difficulty: 15,
    cooldown: 6,
    range: "Touch",
    duration: "1 hour",
    side_effects: "Damage splits between both"
  },

  # ILLUSION MAGIC
  "Mirror Self" => {
    description: "Creates perfect illusory duplicate",
    skill_path: ["Spirit", "Attunement", "Illusion"],
    difficulty: 14,
    cooldown: 4,
    range: "Self",
    duration: "10 minutes",
    side_effects: "Caster sees double for 1 hour"
  },

  "False Memory" => {
    description: "Implants believable false memory",
    skill_path: ["Mind", "Social Knowledge", "Deception", "Spirit", "Casting", "Illusion"],
    difficulty: 17,
    cooldown: 8,
    range: "Touch",
    duration: "Permanent",
    side_effects: "Caster questions own memories"
  },

  # NATURE MAGIC
  "Plant Growth" => {
    description: "Accelerates plant growth dramatically",
    skill_path: ["Spirit", "Attunement", "Nature"],
    difficulty: 9,
    cooldown: 2,
    range: "10m radius",
    duration: "1 hour",
    side_effects: "Caster needs to eat immediately"
  },

  "Animal Bond" => {
    description: "Forms temporary telepathic link with animal",
    skill_path: ["Mind", "Awareness", "Nature Knowledge", "Spirit", "Casting", "Nature"],
    difficulty: 12,
    cooldown: 3,
    range: "1 km",
    duration: "1 day",
    side_effects: "Caster adopts animal mannerisms"
  },

  # PROTECTION MAGIC
  "Ward Circle" => {
    description: "Creates protective barrier against hostile magic",
    skill_path: ["Spirit", "Attunement", "Protection"],
    difficulty: 11,
    cooldown: 4,
    range: "5m radius",
    duration: "1 hour",
    side_effects: "Drains 2 points temporary endurance"
  },

  "Truth Shield" => {
    description: "Protects against lies and deception",
    skill_path: ["Spirit", "Attunement", "Protection"],
    difficulty: 13,
    cooldown: 5,
    range: "Self",
    duration: "1 hour",
    side_effects: "Caster must speak only truth"
  },

  # DARK MAGIC
  "Fear Whisper" => {
    description: "Instills paralyzing fear in target",
    skill_path: ["Spirit", "Attunement", "Shadow"],
    difficulty: 12,
    cooldown: 3,
    range: "30m",
    duration: "10 minutes",
    side_effects: "Caster experiences target's fear"
  },

  "Soul Glimpse" => {
    description: "Briefly see target's deepest secrets",
    skill_path: ["Spirit", "Attunement", "Shadow"],
    difficulty: 16,
    cooldown: 7,
    range: "Touch",
    duration: "Instant",
    side_effects: "Caster's own secrets become visible to target"
  },

  # UTILITY SPELLS
  "Mend Object" => {
    description: "Repairs broken non-living items",
    skill_path: ["Spirit", "Attunement", "Matter"],
    difficulty: 7,
    cooldown: 1,
    range: "Touch",
    duration: "Instant",
    side_effects: "Caster feels phantom pain where object was broken"
  },

  "Language Gift" => {
    description: "Temporarily understand any spoken language",
    skill_path: ["Mind", "Social Knowledge", "Linguistics", "Spirit", "Casting", "Mind"],
    difficulty: 10,
    cooldown: 2,
    range: "Self",
    duration: "1 hour",
    side_effects: "Native language sounds foreign for 1 hour"
  },

  "Night Eyes" => {
    description: "See perfectly in complete darkness",
    skill_path: ["Spirit", "Attunement", "Light"],
    difficulty: 8,
    cooldown: 1,
    range: "Self",
    duration: "1 hour",
    side_effects: "Sensitive to bright light for 1 day"
  },

  # COMBAT ENHANCEMENT
  "Weapon Bond" => {
    description: "Temporarily merge consciousness with weapon",
    skill_path: ["Body", "Melee Combat", "Chosen Weapon", "Spirit", "Casting", "Matter"],
    difficulty: 14,
    cooldown: 5,
    range: "Touch",
    duration: "10 minutes",
    side_effects: "Caster feels every strike weapon takes"
  },

  "Battle Trance" => {
    description: "Enter combat state, ignore pain and fear",
    skill_path: ["Mind", "Awareness", "Battle Focus", "Spirit", "Casting", "Body"],
    difficulty: 13,
    cooldown: 6,
    range: "Self",
    duration: "Combat",
    side_effects: "Exhausted for 2 hours after"
  },

  # SOCIAL MAGIC
  "Charm Smile" => {
    description: "Irresistibly likeable for brief period",
    skill_path: ["Mind", "Social Knowledge", "Persuasion", "Spirit", "Casting", "Mind"],
    difficulty: 9,
    cooldown: 2,
    range: "Self",
    duration: "30 minutes",
    side_effects: "Everyone becomes suspicious after spell ends"
  },

  "Truth Compulsion" => {
    description: "Target must answer one question truthfully",
    skill_path: ["Mind", "Social Knowledge", "Interrogation", "Spirit", "Casting", "Mind"],
    difficulty: 15,
    cooldown: 4,
    range: "Conversation",
    duration: "1 question",
    side_effects: "Caster must also answer one truthful question"
  }
}

# Spell assignment logic based on character type and skills
def assign_spells_to_npc(npc)
  return [] unless npc.tiers["SPIRIT"] && (npc.tiers["SPIRIT"]["Casting"] || npc.tiers["SPIRIT"]["Attunement"])

  assigned_spells = []
  # More spells for competent magic users
  casting_total = npc.get_skill_total("SPIRIT", "Casting", "Total") rescue 0
  attunement_total = npc.get_skill_total("SPIRIT", "Attunement", "Total") rescue 0
  magic_skill = [casting_total, attunement_total].max

  max_spells = case magic_skill
               when 0..5 then 0      # No spells for beginners
               when 6..10 then 1     # 1 spell for novices
               when 11..15 then 2    # 2 spells for competent
               when 16..20 then 3    # 3 spells for skilled
               when 21..25 then 4    # 4 spells for experts
               else 5                # 5 spells for masters
               end

  # Get character's strongest magical domains
  casting_skills = npc.tiers["SPIRIT"]["Casting"]["skills"] || {} rescue {}
  attunement_skills = npc.tiers["SPIRIT"]["Attunement"]["skills"] || {} rescue {}
  all_magic_skills = casting_skills.merge(attunement_skills)
  preferred_domains = all_magic_skills.select { |skill, value| value > 0 }.keys

  # Filter spells based on character type and skills
  suitable_spells = $SpellCatalog.select do |spell_name, spell_data|
    # Check if character has required skills
    can_cast = true
    spell_data[:skill_path].each do |skill_part|
      # Simplified check - character should have some relevant skills
      case skill_part
      when "Fire" then can_cast &&= (all_magic_skills["Fire"] || 0) > 0
      when "Water" then can_cast &&= (all_magic_skills["Water"] || 0) > 0
      when "Air" then can_cast &&= (all_magic_skills["Air"] || 0) > 0
      when "Earth" then can_cast &&= (all_magic_skills["Earth"] || 0) > 0
      when "Mind" then can_cast &&= (all_magic_skills["Mind"] || 0) > 0
      when "Nature" then can_cast &&= (all_magic_skills["Nature"] || 0) > 0
      when "Protection" then can_cast &&= (all_magic_skills["Protection"] || 0) > 0
      when "Illusion" then can_cast &&= (all_magic_skills["Illusion"] || 0) > 0
      when "Shadow" then can_cast &&= (all_magic_skills["Shadow"] || 0) > 0
      when "Self" then can_cast &&= (all_magic_skills["Self"] || 0) > 0
      when "Life" then can_cast &&= (all_magic_skills["Life"] || 0) > 0
      end
    end
    can_cast
  end

  # Randomly select spells from suitable ones
  suitable_spells.keys.sample(max_spells).each do |spell_name|
    spell_data = suitable_spells[spell_name]
    assigned_spells << {
      name: spell_name,
      description: spell_data[:description],
      skill_path: spell_data[:skill_path].join(" → "),
      difficulty: spell_data[:difficulty],
      cooldown: spell_data[:cooldown],
      range: spell_data[:range],
      duration: spell_data[:duration],
      side_effects: spell_data[:side_effects]
    }
  end

  assigned_spells
end

# Character type spell preferences
$SpellPreferences = {
  "Mage" => ["Fire", "Water", "Air", "Earth"],
  "Sorcerer" => ["Fire", "Shadow", "Mind"],
  "Wizard (fire)" => ["Fire"],
  "Wizard (water)" => ["Water"],
  "Wizard (air)" => ["Air"],
  "Wizard (earth)" => ["Earth"],
  "Wizard (prot.)" => ["Protection"],
  "Witch (black)" => ["Shadow", "Mind", "Fear"],
  "Witch (white)" => ["Life", "Nature", "Protection"],
  "Summoner" => ["Mind", "Nature", "Shadow"],
  "Battle Mage" => ["Fire", "Protection", "Body"],
  "Seer" => ["Mind", "Time", "Illusion"],
  "Shaman" => ["Nature", "Spirit", "Animal"]
}