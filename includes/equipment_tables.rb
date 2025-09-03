# Equipment tables based on d6gaming.org/index.php/Equipment

$EquipmentTables = {
  # Basic adventuring gear (with costs in copper pieces)
  "basic" => [
    { name: "Backpack", cost: 30, weight: 1.0 },
    { name: "Waterskin", cost: 20, weight: 0.5 },
    { name: "Flint & steel", cost: 10, weight: 0.1 },
    { name: "Blanket", cost: 120, weight: 2.0 }, # 6sp = 120cp
    { name: "Torch", cost: 3, weight: 0.5 },
    { name: "Oil lamp", cost: 100, weight: 0.5 }, # 5sp
    { name: "Rope (10m)", cost: 60, weight: 5.0 }, # 3sp
    { name: "Grappling hook", cost: 100, weight: 2.0 }, # 5sp
    { name: "Canvas tent", cost: 200, weight: 8.0 }, # 10sp
    { name: "Belt pouch", cost: 10, weight: 0.1 },
    { name: "Whetstone", cost: 5, weight: 0.2 },
    { name: "Fishing gear", cost: 40, weight: 1.0 }, # 2sp
    { name: "Cooking pot", cost: 30, weight: 1.5 },
    { name: "Rations (3 days)", cost: 30, weight: 1.5 }
  ],
  
  "warrior" => [
    { name: "Shield strap", cost: 10, weight: 0.1 },
    { name: "Weapon oil", cost: 5, weight: 0.1 },
    { name: "Spare bowstring", cost: 5, weight: 0.05 },
    { name: "Quiver", cost: 20, weight: 0.3 },
    { name: "Armor repair kit", cost: 50, weight: 1.0 }
  ],
  
  "thief" => [
    { name: "Lockpicks", cost: 100, weight: 0.1 }, # 5sp
    { name: "Dark cloak", cost: 60, weight: 1.0 }, # 3sp
    { name: "Caltrops", cost: 20, weight: 0.5 },
    { name: "Smoke powder", cost: 40, weight: 0.2 },
    { name: "Glass cutter", cost: 100, weight: 0.1 } # 5sp
  ],
  
  "mage" => [
    { name: "Spell components", cost: 100, weight: 0.5 }, # 5sp
    { name: "Scroll case", cost: 20, weight: 0.3 },
    { name: "Ink & quill", cost: 20, weight: 0.1 },
    { name: "Parchment (10)", cost: 40, weight: 0.2 }, # 2sp
    { name: "Spellbook", cost: 300, weight: 2.0 }, # 15sp
    { name: "Crystal focus", cost: 200, weight: 0.2 } # 10sp
  ],
  
  "ranger" => [
    { name: "Tracking kit", cost: 60, weight: 0.5 }, # 3sp
    { name: "Snares (5)", cost: 20, weight: 0.5 },
    { name: "Camouflage net", cost: 40, weight: 1.0 }, # 2sp
    { name: "Field guide", cost: 100, weight: 0.5 }, # 5sp
    { name: "Hunting knife", cost: 40, weight: 0.3 } # 2sp
  ],
  
  "merchant" => [
    { name: "Scales", cost: 100, weight: 2.0 }, # 5sp
    { name: "Ledger", cost: 60, weight: 0.5 }, # 3sp
    { name: "Money pouch", cost: 10, weight: 0.1 },
    { name: "Merchant license", cost: 200, weight: 0.05 }, # 10sp
    { name: "Sample case", cost: 100, weight: 1.0 } # 5sp
  ],
  
  "noble" => [
    { name: "Signet ring", cost: 500, weight: 0.05 }, # 25sp
    { name: "Fine clothes", cost: 400, weight: 2.0 }, # 20sp
    { name: "Perfume", cost: 100, weight: 0.1 }, # 5sp
    { name: "Silver flask", cost: 200, weight: 0.3 }, # 10sp
    { name: "Writing kit", cost: 60, weight: 0.5 } # 3sp
  ],
  
  "priest" => [
    { name: "Holy symbol", cost: 100, weight: 0.2 }, # 5sp
    { name: "Prayer beads", cost: 20, weight: 0.1 },
    { name: "Incense", cost: 40, weight: 0.2 }, # 2sp
    { name: "Holy water", cost: 50, weight: 0.5 },
    { name: "Religious texts", cost: 200, weight: 1.0 } # 10sp
  ]
}

# Generate equipment based on character type and level
def generate_npc_equipment(type, level)
  equipment = []
  
  # Determine character archetype
  type_str = type.to_s.downcase
  archetype = case 
    when type_str.include?("warrior") || type_str.include?("guard") || type_str.include?("soldier")
      "warrior"
    when type_str.include?("thief") || type_str.include?("bandit") || type_str.include?("assassin")
      "thief"
    when type_str.include?("mage") || type_str.include?("wizard") || type_str.include?("sorcerer")
      "mage"
    when type_str.include?("ranger") || type_str.include?("hunter") || type_str.include?("scout")
      "ranger"
    when type_str.include?("merchant") || type_str.include?("trader")
      "merchant"
    when type_str.include?("noble") || type_str.include?("lord") || type_str.include?("lady")
      "noble"
    when type_str.include?("priest") || type_str.include?("cleric") || type_str.include?("monk")
      "priest"
    else
      "basic"
    end
  
  # Add basic items (1-3 based on level)
  basic_items = $EquipmentTables["basic"].sample([1 + level/3, 4].min)
  equipment += basic_items.map { |item| item[:name] }
  
  # Add archetype-specific items if applicable
  if archetype != "basic" && $EquipmentTables[archetype]
    specific_items = $EquipmentTables[archetype].sample([1 + level/4, 3].min)
    equipment += specific_items.map { |item| item[:name] }
  end
  
  # Always have at least backpack and waterskin
  equipment << "Backpack" unless equipment.any? { |e| e.include?("Backpack") }
  equipment << "Waterskin" unless equipment.any? { |e| e.include?("Waterskin") }
  
  equipment.uniq
end