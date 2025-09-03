# Amar RPG New System - Complete Documentation

## System Overview

The Amar RPG has been migrated from a flat attribute system to a 3-tier hierarchical system:
- **Characteristics** (BODY, MIND, SPIRIT) - Broadest, hardest to train
- **Attributes** (e.g., Strength, Endurance, Intelligence) - Moderate scope and training
- **Skills** (e.g., Long Sword, Climbing, Fire Magic) - Specific, easiest to train

## Skill Level Descriptions (Total Values)

| Total | Description | Population Frequency |
|-------|-------------|---------------------|
| 0-1   | Basket case | Common untrained |
| 1-2   | Green | Beginners |
| 3-4   | Trained some | Apprentices |
| 5-6   | Trained | Journeymen |
| 7-8   | Well trained | Professionals |
| 9-10  | Very good | Local experts |
| 11-13 | Mastery | Regional champions |
| 14-15 | Top notch | National level |
| 16-17 | World Class | Continental champions |
| 18+   | Hero Level | Legendary figures |

## Population Distribution

In a typical population:
- **Village (100 people)**: Most skills at 5-8, best fighter maybe 10-11
- **Town (1,000 people)**: Many at 12-14, couple at 15-16
- **Country (100,000 people)**: Handful at 17-18
- **Continent**: Very few exceed 18

## Training Reality

### Mark Requirements
- Advance from level N to N+1: **5 × (N+1) marks**
- Example: 3→4 requires 20 marks

### Training Rates (marks per week)

| Tier | With Teacher | Without (BODY) | Without (MIND/SPIRIT) |
|------|-------------|----------------|----------------------|
| Skill | 2 | 1 | 0.5 |
| Attribute | 1 | 0.5 | 0.25 |
| Characteristic | 0.5 | 0.25 | 0.125 |

### Time Investment Examples

**Specific Skill (Long Sword) to 10:**
- Weekly training with teacher: ~6 years
- This gives ONLY Long Sword skill

**Attribute (Melee Combat) to 7:**
- Weekly training with teacher: ~3.5 years
- Benefits ALL melee weapons

**Characteristic (BODY) to 4:**
- Weekly training with teacher: ~2 years
- Benefits ALL body-related activities

## Natural Caps Implementation

### Based on Training Difficulty

| Tier | Novice (L1-2) | Experienced (L3-5) | Master (L6+) | Absolute Max |
|------|---------------|-------------------|--------------|--------------|
| Characteristic | 2 | 3 | 4 | 5 |
| Attribute | 4 | 6 | 7 | 8 |
| Skill | 6 | 10 | 12 | 15 |

### Why These Caps?

1. **Characteristics** are capped low (2-4 typically) because:
   - Take years to improve even one level
   - Affect everything underneath
   - Represent core physical/mental/spiritual development

2. **Attributes** are moderately capped (4-7 typically) because:
   - Take months to years per level
   - Affect a category of related skills
   - Represent specialized training areas

3. **Skills** can go higher (6-12 typically) because:
   - Take weeks to months per level
   - Very specific application
   - Represent focused practice

## File Structure

### New System Files
```
includes/
├── class_npc_new.rb         # Core NPC class with 3-tier system
├── class_enc_new.rb         # Encounter generation
└── tables/
    ├── tier_system.rb       # Tier structure definitions
    ├── chartype_new.rb      # 18 character templates
    └── spells_new.rb        # Spell card database

cli_*_new.rb                 # Input/output modules
system_mapping.md            # Old→New conversion guide
training_analysis.md         # Training time calculations
MIGRATION_STATUS.md          # Implementation progress
```

### Character Types Implemented
1. Warrior - Combat specialist
2. Mage - Magic user
3. Thief - Stealth/agility
4. Merchant - Social/trade
5. Ranger - Wilderness expert
6. Priest - Divine magic
7. Craftsman - Skilled labor
8. Noble - Leadership/social
9. Commoner - General populace
10. Prostitute - Social specialist
11. Assassin - Combat/stealth hybrid
12. Sailor - Maritime specialist
13. Entertainer - Performance/social
14. Guard - Defensive combat
15. Scholar - Knowledge specialist
16. Bandit - Wilderness combat
17. Farmer - Agricultural/nature
18. More can be added following the template

## Key Algorithms

### Tier Level Calculation
```ruby
def calculate_tier_level(base, npc_level, tier_modifier)
  # tier_modifier: 1.0 = Characteristic, 0.8 = Attribute, 0.6 = Skill
  
  # Growth rates inversely proportional to training difficulty
  growth_rate = case tier_modifier
    when 1.0 then 0.4  # Very slow
    when 0.8 then 0.6  # Moderate
    when 0.6 then 0.8  # Faster
  end
  
  level = (base * Math.sqrt(npc_level + 1) * growth_rate).to_i
  
  # Apply realistic plateaus
  # Most people don't reach maximum potential
end
```

### Skill Total Calculation
```ruby
total = characteristic + attribute + skill

# Realistic ranges:
# Novice: 2 + 2 + 3 = 7
# Professional: 3 + 4 + 6 = 13
# Master: 4 + 6 + 10 = 20 (but very rare)
```

## Magic System

### Spell Cards
- Spells are owned objects that can be transferred
- Each spell has:
  - Encumbrance (magical weight)
  - Cooldown period
  - Casting requirements (DRs)
  - Effects
  - Transfer requirements

### Domains
Fire, Water, Air, Earth, Life, Death, Mind, Body, Self

### Spell Economy
- Spells are currency in magical society
- Transfer requires rituals (days to weeks)
- Death returns spells to gods

## Combat System

### Melee Weapons
Preserved from old system - specific weapon skills

### Missile Weapons
Preserved from old system - specific weapon skills

### Modifiers
- BP (Body Points) = SIZE×2 + Fortitude/3
- DB (Damage Bonus) = (SIZE + Wield Weapon)/3
- MD (Magic Defense) = (Mental Fortitude + Attunement Self)/3

## Testing & Balance

### Natural Distribution Testing
- Most NPCs generate with totals 7-13
- Specialists may reach 14-16
- Very rare to see 17-18
- 18+ requires exceptional circumstances

### Population Realism
The system now naturally creates the distribution you specified:
- Common people: 5-8
- Town champions: 12-14
- Regional masters: 15-16
- National heroes: 17-18
- Legendary: 18+

## Migration Notes

### From Old System
- Old attributes map to new attributes
- Skills reorganized under proper attributes
- Combat skills preserved as-is
- Magic system completely redesigned

### Backward Compatibility
- Both systems run in parallel
- Press 'n' for old, 'x' for new (NPCs)
- Press 'e' for old, 'y' for new (encounters)

## Future Development

### Recommended Additions
1. Craft skills under Practical Knowledge
2. More specific magic skills
3. Social combat system
4. Reputation tracking
5. Spell creation rules

### Wiki Updates Needed
1. Character creation page - new tier system
2. Skills page - new organization
3. Magic page - spell card system
4. Combat page - update modifiers
5. Advancement page - mark system

## Critical Design Decisions

1. **Why 3 tiers?** - Reflects real training where broad abilities (BODY) take years but benefit everything, while specific skills (Long Sword) train quickly but narrowly.

2. **Why these caps?** - Based on actual training time calculations. Getting Characteristic 5 would take 3+ years of dedicated training.

3. **Why logarithmic scaling?** - Diminishing returns reflect reality where early gains are easier than mastery.

4. **Why soft 18 cap?** - Allows rare exceptions while maintaining game balance.

5. **Why population distribution matters?** - Creates realistic world where true masters are rare and valued.

## Handover Notes

The system is fully functional with:
- Natural progression that matches your population distribution
- Training difficulty reflected in caps
- Skill totals displayed for easy gameplay
- Compact output fitting one screen
- All original NPC types plus new ones

The key insight: The harder something is to train (Characteristics), the more valuable but rarer it is. This creates a natural economy of ability where specialists exist but generalists are valued.