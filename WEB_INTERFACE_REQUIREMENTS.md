# Amar Tools Web Interface Requirements

## Overview
Create a web interface that replicates the TUI functionality exactly, using the same backend classes and generating identical output.

## Key Requirements

### 1. Use EXACT TUI Backend
- Use NpcNew class (3-tier system) but with ORIGINAL weapon/armor tables
- Call same functions as TUI: `npc_output_new()`, `enc_output_new()`, etc.
- Generate identical output to TUI including colors and formatting

### 2. Original Weapon/Armor Tables Integration
- Use `$Melee` table (30 entries) for weapon combinations like "Longsword/Buc"
- Use `$Missile` table (12 entries) for missiles like "Bow(H) [1]" with proper ranges
- Use `$Armour` table for armor selection with proper AP values
- Implement EXACT selection logic from original CLI class_npc.rb

### 3. Correct Calculations
- **Initiative**: Weapon init + Reaction speed skill total
- **Off (Offensive)**: Weapon off + skill total
- **Def (Defense)**: Weapon def + skill total + (Dodge/5)
- **Damage**: Weapon damage + DB (Damage Bonus)
- **Range**: From missile weapon table (40m for Bow(H), etc.)

### 4. UI Layout Requirements
- **Input section**: 3 columns at top
  - Column 1: Name, Race, Type (radio buttons in 4-column grid)
  - Column 2: Level (0-6), Area, Sex
  - Column 3: Age, Height, Weight, Description (5+ rows, full width)
- **Output section**: Full-width below inputs with larger font (16px+)
- **Colors**: Green fantasy theme with readable colors
  - Names: Dark gold (#b8860b)
  - Skills: Black (#000000)
  - Headers: Steel blue
  - Stats: Forest green

### 5. TUI Input Replication
- **Exact field labels**: "Name:", "Race:", "Level:", etc. (not verbose instructions)
- **Exact options**:
  - Race: Human (default), Elf, Half-elf, Dwarf, Goblin, Lizard Man, Centaur, Ogre, Troll, Araxi, Faerie
  - Level: 0=Random, 1=Novice, 2=Apprentice, 3=Journeyman, 4=Expert, 5=Master, 6=Grandmaster
  - Area: Random, Amaronir, Merisir, Calaronir, Feronir, Aleresir, Rauinir, Outskirts, Other
- **Character types**: Load from `$ChartypeNew` including race templates

### 6. Functionality Requirements
- **Editable output**: Click to edit generated content
- **Copy to clipboard**: Working copy function with fallbacks
- **Save as file**: Export generated content
- **ANSI color conversion**: Convert TUI colors to HTML spans
- **Race-specific traits**: Proper heights/weights/ages per race

### 7. Server Architecture
- **Sinatra server** on port 8889 for API endpoints
- **Static file serving** for HTML/CSS/JS
- **API endpoints**:
  - `/api/character-types` - Get available character types
  - `/api/npc/new` - Generate NPC using exact TUI logic
  - `/api/encounter/new` - Generate encounters
  - `/api/town` - Generate towns
  - `/api/weather` - Generate weather
  - `/api/names` - Generate names

### 8. Original CLI Integration Points
From original class_npc.rb:
```ruby
# Armor selection
tmp = rand(@npc["specials"]["Arm-level"]) + 1
@npc["items"]["Armour"] = $Armour[tmp].dup

# Weapon selection
tmp = rand(@npc["specials"]["Wpn-level"]) + 1
@npc["items"]["Melee1"] = $Melee[tmp].dup
# Apply modifiers: DB, Reaction, skill levels, Dodge/5

# Missile weapons
tmp = rand(@npc["specials"]["Msl-level"]) + 1
@npc["items"]["Missile1"] = $Missile[tmp].dup
# Strength adjustments for throwing weapons
```

### 9. Critical Output Format
Must match original CLI output:
```
WEAPON             SKILL    INI     OFF    DEF    DAM    HP    RANGE
Longsword/Buc         12      15      12     13      4     12
Bow(H) [1]            10               8              3           40m
```

### 10. Missing Features to Add
- All TUI menu items: Encounter, Monster, Town, Weather, Names generators
- Town relations map generation
- Weather PDF generation
- Proper error handling and validation
- Mobile responsive design

## Technical Notes
- **ANSI codes**: TUI uses `\e[1;36m` format, convert to HTML spans
- **Width**: 120 characters for proper formatting
- **Tables**: Must use original $Melee, $Missile, $Armour arrays exactly
- **Race handling**: Extract race from type string like "Dwarf: Warrior"
- **Weapon skills**: Map weapon names to 3-tier skills (Sword -> "BODY/Melee Combat/Sword")

## Current Status
- TUI works perfectly with 3-tier system
- Web interface was lost in git reset
- Need to implement original weapon/armor tables in both TUI and web
- Priority: Fix TUI weapon tables first, then rebuild web interface