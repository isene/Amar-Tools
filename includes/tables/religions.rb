# Religious Affiliations Table for Amar RPG
# Based on d6gaming.org/index.php/Mythology

$ReligionTable = {
  # Primary Gods
  "Alesia" => {
    "domain" => "Earth",
    "portfolio" => "Stability, Protection, Agriculture",
    "worshippers" => ["Farmer", "Guard", "Protector"],
    "alignment" => "Good"
  },
  "Ikalio" => {
    "domain" => "Fire", 
    "portfolio" => "Creativity, Passion, Thought",
    "worshippers" => ["Wizard (fire)", "Artist", "Creator", "Mage"],
    "alignment" => "Neutral"
  },
  "Shalissa" => {
    "domain" => "Wind/Air",
    "portfolio" => "Freedom, Speed, Adventure",
    "worshippers" => ["Wizard (air)", "Scout", "Adventurer"],
    "alignment" => "Neutral"
  },
  "Walmaer" => {
    "domain" => "Water",
    "portfolio" => "Sea, Rivers, Maritime",
    "worshippers" => ["Wizard (water)", "Sailor", "Fisher"],
    "alignment" => "Neutral"
  },
  "Ielina" => {
    "domain" => "Moon/Time",
    "portfolio" => "Perception, Wisdom, Time",
    "worshippers" => ["Seer", "Mystic", "Monk"],
    "alignment" => "Neutral"
  },
  
  # Lesser Gods
  "Cal Amae" => {
    "domain" => "Good",
    "portfolio" => "Good Deeds, Heroism, Protection",
    "worshippers" => ["Paladin", "Knight", "Priest", "Witch (white)"],
    "alignment" => "Good"
  },
  "Taroc" => {
    "domain" => "War",
    "portfolio" => "Battle, Conflict, Strategy",
    "worshippers" => ["Warrior", "Soldier", "Guard", "Gladiator"],
    "alignment" => "Neutral"
  },
  "Fal Munir" => {
    "domain" => "Knowledge",
    "portfolio" => "Learning, Wisdom, Research",
    "worshippers" => ["Scholar", "Sage", "Scribe", "Monk"],
    "alignment" => "Neutral"
  },
  "Elesi" => {
    "domain" => "Creation",
    "portfolio" => "Art, Craftsmanship, Beauty",
    "worshippers" => ["Artist", "Craftsman", "Witch (white)", "Mage"],
    "alignment" => "Good"
  },
  "Anashina" => {
    "domain" => "Nature",
    "portfolio" => "Wilderness, Animals, Plants",
    "worshippers" => ["Ranger", "Hunter", "Druid", "Barbarian"],
    "alignment" => "Neutral"
  },
  "Gwendyll" => {
    "domain" => "Royalty",
    "portfolio" => "Leadership, Nobility, Authority",
    "worshippers" => ["Noble", "Knight", "Lord"],
    "alignment" => "Neutral"
  },
  "Mailatroz" => {
    "domain" => "Trade",
    "portfolio" => "Commerce, Wealth, Business",
    "worshippers" => ["Merchant", "Trader", "Shopkeeper"],
    "alignment" => "Neutral"
  },
  "Juba" => {
    "domain" => "Entertainment",
    "portfolio" => "Joy, Performance, Festivity",
    "worshippers" => ["Entertainer", "Jester", "Bard"],
    "alignment" => "Good"
  },
  "Kraagh" => {
    "domain" => "Death",
    "portfolio" => "Death, Reincarnation, Afterlife",
    "worshippers" => ["Necromancer", "Summoner", "Witch (black)"],
    "alignment" => "Neutral"
  },
  "Mestronorpha" => {
    "domain" => "Evil",
    "portfolio" => "Darkness, Corruption, Malice",
    "worshippers" => ["Sorcerer", "Witch (black)", "Assassin"],
    "alignment" => "Evil"
  },
  "Tsankili" => {
    "domain" => "Thievery",
    "portfolio" => "Trickery, Stealth, Cunning",
    "worshippers" => ["Thief", "Rogue", "Assassin", "Highwayman"],
    "alignment" => "Neutral"
  },
  "Man Peggon" => {
    "domain" => "Strength",
    "portfolio" => "Physical Power, Athletics",
    "worshippers" => ["Barbarian", "Gladiator", "Body guard"],
    "alignment" => "Neutral"
  },
  "Maleko" => {
    "domain" => "Inner Strength",
    "portfolio" => "Meditation, Self-Control, Discipline",
    "worshippers" => ["Monk", "Mystic"],
    "alignment" => "Good"
  },
  "Recolar" => {
    "domain" => "Sports",
    "portfolio" => "Competition, Athletics, Games",
    "worshippers" => ["Gladiator", "Athlete"],
    "alignment" => "Neutral"
  },
  "Liandra" => {
    "domain" => "Hope",
    "portfolio" => "Dreams, Optimism, Inspiration",
    "worshippers" => ["Clergyman", "Healer"],
    "alignment" => "Good"
  }
}

# Character type to deity mapping with variations
# Arrays allow for religious diversity - not everyone of a type worships the same god
$CharacterReligions = {
  # Wizards by element - primary deity but with some variation
  "Wizard (water)" => ["Walmaer", "Walmaer", "Walmaer", "Ielina", "Alesia"],  # 60% Walmaer
  "Wizard (fire)" => ["Ikalio", "Ikalio", "Ikalio", "Taroc", "Elesi"],  # 60% Ikalio
  "Wizard (air)" => ["Shalissa", "Shalissa", "Shalissa", "Ielina", "Anashina"],  # 60% Shalissa
  "Wizard (earth)" => ["Alesia", "Alesia", "Alesia", "Anashina", "Ikalio"],  # 60% Alesia
  "Wizard (prot.)" => ["Alesia", "Cal Amae", "Gwendyll", "MacGillan"],
  
  # Magic users - diverse religious affiliations
  "Mage" => ["Ikalio", "Elesi", "Ielina", "Taroc", "Shalissa", "Alesia"],
  "Witch (white)" => ["Cal Amae", "Liandra", "Elesi", "Gwendyll", "Alesia"],
  "Witch (black)" => ["Mestronorpha", "Kraagh", "Moltan"],
  "Sorcerer" => ["Mestronorpha", "Kraagh", "Moltan", "Tsankili"],
  "Summoner" => ["Kraagh", "Ielina", "Mestronorpha"],
  "Necromancer" => ["Kraagh", "Kraagh", "Moltan"],
  "Seer" => ["Ielina", "Ielina", "Fal Munir"],
  
  # Religious types - broad range of deities
  "Priest" => ["Cal Amae", "Alesia", "Shalissa", "Ielina", "Elesi", "Liandra", "Walmaer", "Ikalio"],
  "Clergyman" => ["Cal Amae", "Liandra", "Elesi", "Alesia", "any"],
  "Monk" => ["Maleko", "Ielina", "Fal Munir", "Cal Amae"],
  
  # Warriors - mostly Taroc but variations
  "Warrior" => ["Taroc", "Taroc", "Taroc", "Recolar", "Man Peggon", "Cal Amae"],
  "Soldier" => ["Taroc", "Taroc", "Cal Amae", "nobility"],
  "Guard" => ["Taroc", "Alesia", "Cal Amae", "nobility"],
  "Body guard" => ["Taroc", "Man Peggon", "nobility", "Cal Amae"],
  "Gladiator" => ["Taroc", "Recolar", "Man Peggon", "Juba"],
  "Knight" => ["Cal Amae", "nobility", "Taroc"],
  "Paladin" => ["Cal Amae", "Cal Amae", "Alesia"],
  
  # Nature types
  "Ranger" => ["Anashina", "Anashina", "Alesia", "Shalissa"],
  "Hunter" => ["Anashina", "Anashina", "Taroc"],
  "Druid" => ["Anashina", "Anashina", "Anashina", "Alesia"],
  "Barbarian" => ["Man Peggon", "Anashina", "Taroc", "Kraagh"],
  
  # Rogues
  "Thief" => ["Tsankili", "Tsankili", "None", "Juba"],
  "Rogue" => ["Tsankili", "Tsankili", "Shalissa"],
  "Assassin" => ["Tsankili", "Mestronorpha", "Kraagh", "None"],
  "Highwayman" => ["Tsankili", "None", "Taroc"],
  "Scout" => ["Shalissa", "Anashina", "Tsankili"],
  
  # Scholars
  "Scholar" => ["Fal Munir", "Fal Munir", "Elesi", "Ielina"],
  "Sage" => ["Fal Munir", "Ielina", "Elesi", "any"],
  "Scribe" => ["Fal Munir", "Elesi", "nobility"],
  
  # Social types
  "Noble" => ["nobility", "nobility", "Taroc", "Alesia", "Ikalio", "Shalissa", "Walmaer"],
  "Merchant" => ["Mailatroz", "Mailatroz", "Juba", "Alesia", "Walmaer"],
  "Trader" => ["Mailatroz", "Mailatroz", "Juba", "Shalissa"],
  "Entertainer" => ["Juba", "Juba", "Elaari", "Shalissa"],
  "Jester" => ["Juba", "Tsankili", "Elaari"],
  
  # Default for commoners
  "Commoner" => ["Alesia", "Ikalio", "Shalissa", "Walmaer", "Cal Amae", "Mailatroz", "None", "any"],
  "Farmer" => ["Alesia", "Alesia", "Cal Amae"],
  "Craftsman" => ["Elesi", "Mailatroz", "Alesia"],
  "Sailor" => ["Walmaer", "Walmaer", "Shalissa"]
}

# Weighted random deity selection for "any"
$RandomDeityWeights = {
  "Alesia" => 4,
  "Anashina" => 3,
  "Cal Amae" => 2,
  "Elesi" => 1,
  "Elaari" => 1,
  "Fal Munir" => 2,
  "Gwendyll" => 2,
  "Ielina" => 3,
  "Ikalio" => 3,
  "Juba" => 3,
  "Kraagh" => 2,
  "Liandra" => 1,
  "MacGillan" => 2,
  "Mailatroz" => 2,
  "Maleko" => 2,
  "Man Peggon" => 1,
  "Mestronorpha" => 1,
  "Moltan" => 3,
  "Recolar" => 3,
  "Shalissa" => 3,
  "Taroc" => 5,
  "Tsankili" => 2,
  "Walmaer" => 5,
  "None" => 6
}

# Function to get appropriate deity for a character type
def get_character_religion(type, sex = nil)
  # Check for exact match first
  if $CharacterReligions[type]
    deity = $CharacterReligions[type].sample
  else
    # Check for partial matches (for types with parentheses)
    deity = nil
    $CharacterReligions.each do |key, deities|
      if type.include?(key) || key.include?(type)
        deity = deities.sample
        break
      end
    end
    
    # Default to weighted random selection
    deity ||= "any"
  end
  
  # Handle special cases
  case deity
  when "nobility"
    # MacGillan for males, Gwendyll for females
    sex == "F" ? "Gwendyll" : "MacGillan"
  when "any"
    # Weighted random selection
    total_weight = $RandomDeityWeights.values.sum
    random_value = rand(total_weight)
    cumulative = 0
    
    $RandomDeityWeights.each do |god, weight|
      cumulative += weight
      if random_value < cumulative
        return god
      end
    end
    
    "None"  # Fallback
  when "None"
    nil  # No religious affiliation
  else
    deity
  end
end