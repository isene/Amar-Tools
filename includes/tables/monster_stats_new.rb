# Monster and Animal stats for the new 3-tier system
# These are simplified templates that create appropriate stat blocks

$MonsterStats = {
  # Undead
  "zombie" => {
    "type" => "Undead",
    "base_body" => 3,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [8, 10],
    "skills" => ["Unarmed combat", "Grappling"],
    "special" => "No fear, No pain, Slow movement",
    "armor" => "Natural (2 AP)",
    "description" => "Shambling undead"
  },
  "skeleton" => {
    "type" => "Undead",
    "base_body" => 2,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [7, 9],
    "skills" => ["Sword", "Shield"],
    "special" => "No fear, No pain, Vulnerable to blunt",
    "armor" => "Natural (1 AP)",
    "description" => "Animated bones"
  },
  "vampire" => {
    "type" => "Undead",
    "base_body" => 5,
    "base_mind" => 4,
    "base_spirit" => 3,
    "size_range" => [9, 10],
    "skills" => ["Unarmed combat", "Dodge", "Stealth"],
    "special" => "Regeneration, Blood drain, Sunlight vulnerability",
    "armor" => "Natural (3 AP)",
    "description" => "Powerful undead lord"
  },
  "ghoul" => {
    "type" => "Undead",
    "base_body" => 3,
    "base_mind" => 2,
    "base_spirit" => 0,
    "size_range" => [8, 9],
    "skills" => ["Claw attacks", "Bite"],
    "special" => "Paralyzing touch, Corpse eater",
    "armor" => "Natural (1 AP)",
    "description" => "Flesh-eating undead"
  },
  
  # Monsters
  "troll" => {
    "type" => "Monster",
    "base_body" => 5,
    "base_mind" => 1,
    "base_spirit" => 1,
    "size_range" => [12, 15],
    "skills" => ["Club", "Throwing"],
    "special" => "Regeneration, Fire vulnerability",
    "armor" => "Natural (4 AP)",
    "description" => "Large regenerating humanoid"
  },
  "ogre" => {
    "type" => "Monster",
    "base_body" => 4,
    "base_mind" => 2,
    "base_spirit" => 1,
    "size_range" => [11, 13],
    "skills" => ["Club", "Grappling"],
    "special" => "Strong but slow",
    "armor" => "Natural (2 AP)",
    "description" => "Large brutish humanoid"
  },
  "goblin" => {
    "type" => "Monster",
    "base_body" => 2,
    "base_mind" => 2,
    "base_spirit" => 1,
    "size_range" => [5, 7],
    "skills" => ["Dagger", "Sling", "Stealth"],
    "special" => "Pack tactics, Cowardly",
    "armor" => "Leather (1 AP)",
    "description" => "Small cunning humanoid"
  },
  "orc" => {
    "type" => "Monster",
    "base_body" => 3,
    "base_mind" => 2,
    "base_spirit" => 1,
    "size_range" => [8, 10],
    "skills" => ["Sword", "Spear", "Shield"],
    "special" => "Warlike culture",
    "armor" => "Chain (3 AP)",
    "description" => "Aggressive warrior humanoid"
  },
  "giant spider" => {
    "type" => "Monster",
    "base_body" => 3,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [6, 10],
    "skills" => ["Bite", "Web"],
    "special" => "Poison, Web entangle",
    "armor" => "Natural (2 AP)",
    "description" => "Large arachnid predator"
  },
  "wyvern" => {
    "type" => "Monster",
    "base_body" => 4,
    "base_mind" => 2,
    "base_spirit" => 1,
    "size_range" => [11, 14],
    "skills" => ["Bite", "Tail sting", "Flight"],
    "special" => "Poison tail, Flight",
    "armor" => "Natural (3 AP)",
    "description" => "Lesser dragon"
  },
  "dragon" => {
    "type" => "Monster",
    "base_body" => 6,
    "base_mind" => 5,
    "base_spirit" => 4,
    "size_range" => [15, 20],
    "skills" => ["Bite", "Claw", "Breath weapon", "Flight"],
    "special" => "Breath weapon, Flight, Magic resistance",
    "armor" => "Natural (6 AP)",
    "description" => "Ancient magical beast"
  },
  
  # Animals - Predators
  "wolf" => {
    "type" => "Animal",
    "base_body" => 3,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [6, 8],
    "skills" => ["Bite", "Tracking", "Pack tactics"],
    "special" => "Pack hunter",
    "armor" => "Natural (0 AP)",
    "description" => "Pack hunting canine"
  },
  "bear" => {
    "type" => "Animal",
    "base_body" => 4,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [10, 12],
    "skills" => ["Claw", "Bite", "Grappling"],
    "special" => "Powerful strength",
    "armor" => "Natural (1 AP)",
    "description" => "Large powerful omnivore"
  },
  "lion" => {
    "type" => "Animal",
    "base_body" => 3,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [8, 10],
    "skills" => ["Bite", "Claw", "Pounce"],
    "special" => "Pounce attack",
    "armor" => "Natural (0 AP)",
    "description" => "Large feline predator"
  },
  "wild dog" => {
    "type" => "Animal",
    "base_body" => 2,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [5, 7],
    "skills" => ["Bite", "Pack tactics"],
    "special" => "Pack hunter",
    "armor" => "Natural (0 AP)",
    "description" => "Feral canine"
  },
  
  # Animals - Prey
  "deer" => {
    "type" => "Animal",
    "base_body" => 2,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [7, 9],
    "skills" => ["Dodge", "Running"],
    "special" => "Fast runner",
    "armor" => "Natural (0 AP)",
    "description" => "Swift herbivore"
  },
  "boar" => {
    "type" => "Animal",
    "base_body" => 3,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [7, 9],
    "skills" => ["Charge", "Tusk attack"],
    "special" => "Aggressive when threatened",
    "armor" => "Natural (1 AP)",
    "description" => "Wild swine"
  },
  "horse" => {
    "type" => "Animal",
    "base_body" => 3,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [10, 12],
    "skills" => ["Kick", "Running"],
    "special" => "Fast runner, Can be tamed",
    "armor" => "Natural (0 AP)",
    "description" => "Large herbivore"
  },
  
  # Small animals
  "rat" => {
    "type" => "Animal",
    "base_body" => 1,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [1, 2],
    "skills" => ["Bite", "Stealth"],
    "special" => "Disease carrier",
    "armor" => "Natural (0 AP)",
    "description" => "Small rodent"
  },
  "snake" => {
    "type" => "Animal",
    "base_body" => 1,
    "base_mind" => 1,
    "base_spirit" => 0,
    "size_range" => [2, 4],
    "skills" => ["Bite", "Stealth"],
    "special" => "Some poisonous",
    "armor" => "Natural (0 AP)",
    "description" => "Legless reptile"
  },
  
  # Default for unknown monsters
  "default" => {
    "type" => "Unknown",
    "base_body" => 2,
    "base_mind" => 2,
    "base_spirit" => 1,
    "size_range" => [8, 10],
    "skills" => ["Natural weapons"],
    "special" => "Unknown abilities",
    "armor" => "Natural (1 AP)",
    "description" => "Unknown creature"
  }
}

# Function to get monster stats
def get_monster_stats(monster_name)
  # Clean up the monster name
  clean_name = monster_name.downcase.gsub(/monster:|animal:|small |large /, "").strip
  
  # Try to find exact match
  return $MonsterStats[clean_name] if $MonsterStats[clean_name]
  
  # Try partial matches
  $MonsterStats.each do |key, stats|
    return stats if clean_name.include?(key) || key.include?(clean_name)
  end
  
  # Return default if no match
  $MonsterStats["default"]
end