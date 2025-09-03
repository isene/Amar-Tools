# New Spell System for Amar RPG
# Spells are owned "cards" that can be transferred

$SpellDatabase = {
  # Fire Domain Spells
  "Spark" => {
    "domain" => "Fire",
    "encumbrance" => 1,
    "cooldown" => 1,
    "casting_time" => "1 round",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [5],
    "cost" => {"Mental Fortitude" => 1},
    "distance" => "10m",
    "duration" => "Instant",
    "aoe" => "Single target",
    "effects" => "1d6 fire damage",
    "transfer_req" => {"receiving" => "Fire Attunement 1", "giving" => "Ritual 1 day"}
  },
  
  "Fireball" => {
    "domain" => "Fire",
    "encumbrance" => 5,
    "cooldown" => 6,
    "casting_time" => "2 rounds",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [10],
    "cost" => {"Mental Fortitude" => 3},
    "distance" => "50m",
    "duration" => "Instant",
    "aoe" => "3m radius",
    "effects" => "3d6 fire damage to all in area",
    "transfer_req" => {"receiving" => "Fire Attunement 3", "giving" => "Ritual 3 days"}
  },
  
  "Wall of Fire" => {
    "domain" => "Fire",
    "encumbrance" => 8,
    "cooldown" => 24,
    "casting_time" => "3 rounds",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [15],
    "cost" => {"Mental Fortitude" => 5},
    "distance" => "30m",
    "duration" => "10 minutes",
    "aoe" => "10m x 3m wall",
    "effects" => "2d6 damage to those passing through",
    "transfer_req" => {"receiving" => "Fire Attunement 5", "giving" => "Ritual 1 week"}
  },
  
  # Water Domain Spells
  "Water Breathing" => {
    "domain" => "Water",
    "encumbrance" => 3,
    "cooldown" => 2,
    "casting_time" => "1 round",
    "active_passive" => "Active",
    "restrictions" => "Must be near water",
    "dr" => [8],
    "cost" => {"Mental Fortitude" => 2},
    "distance" => "Touch",
    "duration" => "1 hour",
    "aoe" => "Single target",
    "effects" => "Target can breathe underwater",
    "transfer_req" => {"receiving" => "Water Attunement 2", "giving" => "Ritual 2 days"}
  },
  
  "Ice Bolt" => {
    "domain" => "Water",
    "encumbrance" => 4,
    "cooldown" => 3,
    "casting_time" => "1 round",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [9],
    "cost" => {"Mental Fortitude" => 2},
    "distance" => "30m",
    "duration" => "Instant",
    "aoe" => "Single target",
    "effects" => "2d6 cold damage + slow for 1 round",
    "transfer_req" => {"receiving" => "Water Attunement 3", "giving" => "Ritual 2 days"}
  },
  
  "Fog Cloud" => {
    "domain" => "Water",
    "encumbrance" => 4,
    "cooldown" => 4,
    "casting_time" => "2 rounds",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [10],
    "cost" => {"Mental Fortitude" => 3},
    "distance" => "50m",
    "duration" => "10 min",
    "aoe" => "20m radius",
    "effects" => "Dense fog, visibility 2m",
    "transfer_req" => {"receiving" => "Water Attunement 3", "giving" => "Ritual 3 days"}
  },
  
  "Water Walk" => {
    "domain" => "Water",
    "encumbrance" => 2,
    "cooldown" => 2,
    "casting_time" => "1 round",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [7],
    "cost" => {"Mental Fortitude" => 2},
    "distance" => "Touch",
    "duration" => "30 min",
    "aoe" => "Single target",
    "effects" => "Walk on water surface",
    "transfer_req" => {"receiving" => "Water Attunement 2", "giving" => "Ritual 2 days"}
  },
  
  "Purify Water" => {
    "domain" => "Water",
    "encumbrance" => 1,
    "cooldown" => 1,
    "casting_time" => "3 rounds",
    "active_passive" => "Active",
    "restrictions" => "Water only",
    "dr" => [5],
    "cost" => {"Mental Fortitude" => 1},
    "distance" => "Touch",
    "duration" => "Permanent",
    "aoe" => "10 liters",
    "effects" => "Removes toxins",
    "transfer_req" => {"receiving" => "Water Attunement 1", "giving" => "Ritual 1 day"}
  },
  
  "Control Water" => {
    "domain" => "Water",
    "encumbrance" => 8,
    "cooldown" => 12,
    "casting_time" => "5 rounds",
    "active_passive" => "Active",
    "restrictions" => "Natural water",
    "dr" => [14],
    "cost" => {"Mental Fortitude" => 5},
    "distance" => "100m",
    "duration" => "Conc",
    "aoe" => "50m radius",
    "effects" => "Raise/lower 3m",
    "transfer_req" => {"receiving" => "Water Attunement 5", "giving" => "Ritual 1 week"}
  },
  
  "Frost Shield" => {
    "domain" => "Water",
    "encumbrance" => 5,
    "cooldown" => 6,
    "casting_time" => "1 round",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [11],
    "cost" => {"Mental Fortitude" => 3},
    "distance" => "Self",
    "duration" => "5 min",
    "aoe" => "Self",
    "effects" => "+3 AP vs physical",
    "transfer_req" => {"receiving" => "Water Attunement 3", "giving" => "Ritual 4 days"}
  },
  
  # Air Domain Spells
  "Levitate" => {
    "domain" => "Air",
    "encumbrance" => 4,
    "cooldown" => 4,
    "casting_time" => "2 rounds",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [10],
    "cost" => {"Mental Fortitude" => 3},
    "distance" => "Self",
    "duration" => "10 minutes",
    "aoe" => "Self",
    "effects" => "Float up to 10m high, move at walking speed",
    "transfer_req" => {"receiving" => "Air Attunement 3", "giving" => "Ritual 3 days"}
  },
  
  "Lightning Bolt" => {
    "domain" => "Air",
    "encumbrance" => 6,
    "cooldown" => 8,
    "casting_time" => "1 round",
    "active_passive" => "Active",
    "restrictions" => "Cannot use in metal armor",
    "dr" => [12],
    "cost" => {"Mental Fortitude" => 4},
    "distance" => "100m line",
    "duration" => "Instant",
    "aoe" => "Line 100m x 1m",
    "effects" => "4d6 electrical damage to all in line",
    "transfer_req" => {"receiving" => "Air Attunement 4", "giving" => "Ritual 4 days"}
  },
  
  # Earth Domain Spells
  "Stone Skin" => {
    "domain" => "Earth",
    "encumbrance" => 5,
    "cooldown" => 12,
    "casting_time" => "3 rounds",
    "active_passive" => "Active",
    "restrictions" => "Must be on ground",
    "dr" => [11],
    "cost" => {"Mental Fortitude" => 3},
    "distance" => "Touch",
    "duration" => "1 hour",
    "aoe" => "Single target",
    "effects" => "+3 armor points",
    "transfer_req" => {"receiving" => "Earth Attunement 3", "giving" => "Ritual 3 days"}
  },
  
  # Life Domain Spells
  "Heal Wounds" => {
    "domain" => "Life",
    "encumbrance" => 3,
    "cooldown" => 2,
    "casting_time" => "2 rounds",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [8],
    "cost" => {"Mental Fortitude" => 2},
    "distance" => "Touch",
    "duration" => "Instant",
    "aoe" => "Single target",
    "effects" => "Restore 2d6 BP",
    "transfer_req" => {"receiving" => "Life Attunement 2", "giving" => "Ritual 2 days"}
  },
  
  "Regeneration" => {
    "domain" => "Life",
    "encumbrance" => 7,
    "cooldown" => 24,
    "casting_time" => "5 rounds",
    "active_passive" => "Active",
    "restrictions" => "Target must be alive",
    "dr" => [15],
    "cost" => {"Mental Fortitude" => 5},
    "distance" => "Touch",
    "duration" => "1 day",
    "aoe" => "Single target",
    "effects" => "Restore 1 BP per hour",
    "transfer_req" => {"receiving" => "Life Attunement 5", "giving" => "Ritual 1 week"}
  },
  
  # Mind Domain Spells
  "Detect Thoughts" => {
    "domain" => "Mind",
    "encumbrance" => 4,
    "cooldown" => 4,
    "casting_time" => "1 round",
    "active_passive" => "Active",
    "restrictions" => "Target must be intelligent",
    "dr" => [10],
    "cost" => {"Mental Fortitude" => 3},
    "distance" => "10m",
    "duration" => "Concentration",
    "aoe" => "Single target",
    "effects" => "Read surface thoughts",
    "transfer_req" => {"receiving" => "Mind Attunement 3", "giving" => "Ritual 3 days"}
  },
  
  "Illusion" => {
    "domain" => "Mind",
    "encumbrance" => 5,
    "cooldown" => 6,
    "casting_time" => "2 rounds",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [11],
    "cost" => {"Mental Fortitude" => 3},
    "distance" => "30m",
    "duration" => "10 minutes",
    "aoe" => "3m x 3m area",
    "effects" => "Create visual and auditory illusion",
    "transfer_req" => {"receiving" => "Mind Attunement 3", "giving" => "Ritual 3 days"}
  },
  
  # Death Domain Spells
  "Drain Life" => {
    "domain" => "Death",
    "encumbrance" => 6,
    "cooldown" => 8,
    "casting_time" => "2 rounds",
    "active_passive" => "Active",
    "restrictions" => "Target must be living",
    "dr" => [12],
    "cost" => {"Mental Fortitude" => 4},
    "distance" => "Touch",
    "duration" => "Instant",
    "aoe" => "Single target",
    "effects" => "Deal 2d6 damage, heal self for half",
    "transfer_req" => {"receiving" => "Death Attunement 4", "giving" => "Ritual 4 days"}
  },
  
  "Animate Dead" => {
    "domain" => "Death",
    "encumbrance" => 10,
    "cooldown" => 48,
    "casting_time" => "10 rounds",
    "active_passive" => "Active",
    "restrictions" => "Requires corpse",
    "dr" => [18],
    "cost" => {"Mental Fortitude" => 8, "Corpse" => 1},
    "distance" => "Touch",
    "duration" => "Until destroyed",
    "aoe" => "Single corpse",
    "effects" => "Raise undead servant",
    "transfer_req" => {"receiving" => "Death Attunement 6", "giving" => "Ritual 2 weeks"}
  },
  
  # Body Domain Spells
  "Enhance Strength" => {
    "domain" => "Body",
    "encumbrance" => 3,
    "cooldown" => 4,
    "casting_time" => "1 round",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [8],
    "cost" => {"Mental Fortitude" => 2},
    "distance" => "Touch",
    "duration" => "10 minutes",
    "aoe" => "Single target",
    "effects" => "+3 to Strength attribute",
    "transfer_req" => {"receiving" => "Body Attunement 2", "giving" => "Ritual 2 days"}
  },
  
  # Self Domain Spells
  "Mirror Image" => {
    "domain" => "Self",
    "encumbrance" => 5,
    "cooldown" => 6,
    "casting_time" => "1 round",
    "active_passive" => "Active",
    "restrictions" => "None",
    "dr" => [10],
    "cost" => {"Mental Fortitude" => 3},
    "distance" => "Self",
    "duration" => "5 minutes",
    "aoe" => "Self",
    "effects" => "Create 3 illusory duplicates",
    "transfer_req" => {"receiving" => "Self Attunement 3", "giving" => "Ritual 3 days"}
  },
  
  "Teleport" => {
    "domain" => "Self",
    "encumbrance" => 8,
    "cooldown" => 24,
    "casting_time" => "5 rounds",
    "active_passive" => "Active",
    "restrictions" => "Must know destination",
    "dr" => [16],
    "cost" => {"Mental Fortitude" => 6},
    "distance" => "1km",
    "duration" => "Instant",
    "aoe" => "Self + carried items",
    "effects" => "Instantly transport to known location",
    "transfer_req" => {"receiving" => "Self Attunement 5", "giving" => "Ritual 1 week"}
  }
}

# Spell generation function for NPCs
def generate_spell_cards(npc_type, level, casting_level)
  spells = []
  
  # Determine domains based on character type
  domains = case npc_type
            when "Mage"
              ["Fire", "Air", "Mind", "Self"]
            when "Priest"
              ["Life", "Body", "Mind"]
            when "Ranger"
              ["Earth", "Life", "Body"]
            when "Noble"
              ["Mind", "Self"]
            when /Wizard \((.*?)\)/
              # Extract domain from wizard type (e.g., "Wizard (water)" -> "Water")
              wizard_domain = $1.capitalize
              [wizard_domain, wizard_domain]  # Primary domain focus
            else
              ["Fire", "Water", "Air", "Earth"].sample(2)
            end
  
  # Calculate number of spells based on level and casting ability
  # Higher level casters should have accumulated many spells over their career
  base_spells = case level
                when 1..2 then rand(1..2)
                when 3..4 then rand(2..4)
                when 5 then rand(4..6)
                when 6 then rand(6..10)
                else rand(8..12)
                end
  
  # Add bonus spells for high casting level
  casting_bonus = (casting_level / 2).to_i
  spell_count = base_spells + casting_bonus
  spell_count = 1 if spell_count < 1
  spell_count = 15 if spell_count > 15  # Cap at 15 to avoid overwhelming the sheet
  
  # Generate spell cards
  selected_spells = []
  attempts = 0
  
  while selected_spells.length < spell_count && attempts < 20
    attempts += 1
    domain = domains.sample
    domain_spells = $SpellDatabase.select { |_, v| v["domain"] == domain }
    
    if domain_spells.any?
      available_spells = domain_spells.keys - selected_spells
      if available_spells.any?
        spell_name = available_spells.sample
        selected_spells << spell_name
        
        spell_data = $SpellDatabase[spell_name].dup
        spell_data["name"] = spell_name
        
        # Add ownership tracking
        spell_data["owner_id"] = rand(100000)
        spell_data["transfer_history"] = []
        
        spells << spell_data
      end
    end
  end
  
  spells
end

# Spell transfer mechanics
class SpellTransfer
  def self.can_transfer?(spell, giver, receiver)
    # Check giving requirements
    return false unless meets_giving_requirements?(spell, giver)
    
    # Check receiving requirements
    return false unless meets_receiving_requirements?(spell, receiver)
    
    true
  end
  
  def self.transfer(spell, giver, receiver)
    return false unless can_transfer?(spell, giver, receiver)
    
    # Remove from giver
    giver.spells.delete(spell)
    
    # Add to receiver
    spell["transfer_history"] << {
      "from" => giver.name,
      "to" => receiver.name,
      "date" => Time.now
    }
    receiver.spells << spell
    
    true
  end
  
  private
  
  def self.meets_giving_requirements?(spell, giver)
    # Check if giver owns the spell
    return false unless giver.spells.include?(spell)
    
    # Check ritual requirements (simplified for now)
    true
  end
  
  def self.meets_receiving_requirements?(spell, receiver)
    # Check attunement requirements
    req = spell["transfer_req"]["receiving"]
    
    if req.include?("Attunement")
      parts = req.split(" ")
      domain = parts[0]
      required_level = parts[-1].to_i
      
      # Check receiver's attunement level
      receiver_attunement = receiver.get_skill("SPIRIT", "Attunement", domain)
      return false if receiver_attunement < required_level
    end
    
    true
  end
end