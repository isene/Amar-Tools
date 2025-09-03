# Amar RPG System Migration Mapping

## Old System → New System Conversion

### Attributes to Tier System Mapping

#### Old Attributes:
- **SIZE** → Keep as modifier (not part of tier system)
- **STRNG** → BODY/Strength
- **ENDUR** → BODY/Endurance  
- **COORD** → BODY/Athletics
- **LEARN** → MIND/Intelligence
- **AWARE** → MIND/Awareness
- **MAGAP** → SPIRIT/Casting

### Skills Mapping

#### Physical Skills (Old) → BODY Skills (New)
- Balance → BODY/Athletics/Balance
- Climb → BODY/Athletics/Climb
- Dodge → BODY/Athletics/Tumble
- Hide → BODY/Athletics/Hide
- Move Quietly → BODY/Athletics/Move Quietly
- Ride → BODY/Athletics/Ride
- Swim → BODY/Athletics/Swim
- Jump → BODY/Athletics/Jump
- Tumble → BODY/Athletics/Tumble
- Sleight → BODY/Sleight/Pick pockets or Stage Magic
- Melee skills → BODY/Melee Combat/(specific weapons)
- Missile skills → BODY/Missile Combat/(specific weapons)

#### Awareness Skills (Old) → MIND/Awareness Skills (New)
- Detect Traps → MIND/Awareness/Detect Traps
- Tracking → MIND/Awareness/Tracking
- Reaction Speed → MIND/Awareness/Reaction Speed
- Listening → MIND/Awareness/Listening

#### Learning Skills (Old) → MIND Skills (New)
- Medical Lore → MIND/Nature Knowledge/Medical lore
- Animal Handling → MIND/Nature Knowledge/Animal Handling
- Social Lore → MIND/Social Knowledge/Social lore
- Spoken Language → MIND/Social Knowledge/Spoken Language
- Read/Write → MIND/Social Knowledge/Literacy
- Survival → MIND/Practical Knowledge/Survival Lore
- Trapping → MIND/Practical Knowledge/Set traps

### Derived Statistics

#### Old System:
- BP = 2 × SIZE + (ENDUR/3)
- DB = (SIZE + STRNG)/3
- MD = Current MAGAP/3

#### New System:
- BP = SIZE×2 + Fortitude/3
- DB = (SIZE + Wield Weapon)/3
- MD = (Mental Fortitude + Attunement Self)/3

### Level Conversion
- Old Level 1-5 → New tier levels will range 0-10
- Conversion: New Level = Old Level × 2 (approximate)

### Experience/Progression

#### Old System:
- 10 experience marks + target value to increase
- Gain marks through use

#### New System:
- 5 marks × next level required
- Training yields marks (2 with teacher, 1 without for BODY)
- Can convert 3 marks from lower tier to 1 mark higher tier
- Skills get 1 mark per use requiring roll
- Level increase gives 1 mark to tier above

### Combat Styles
- Keep existing weapon skills as-is
- Weapon categories remain the same
- Offensive/Defensive modifiers unchanged

### Magic System

#### Old System:
- Spell levels 1-10
- MA consumed per cast
- Path-based magic

#### New System:
- Spells as owned "cards"
- Encumbrance instead of MA cost
- Cooldown periods
- Spell transfer economy
- SPIRIT tier handles all magical abilities