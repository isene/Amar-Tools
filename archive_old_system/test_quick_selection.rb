#!/usr/bin/ruby
#encoding: utf-8

$pgmdir = File.dirname(File.expand_path(__FILE__))
Dir.chdir($pgmdir)

# Load required files
load "includes/includes.rb"
load "includes/tables/tier_system.rb"
load "includes/tables/chartype_new_full.rb"
load "includes/tables/spells_new.rb"
load "includes/class_npc_new.rb"
load "cli_npc_output_new.rb"

puts "Quick NPC Generation Test"
puts "=" * 40

# Show how easy it is to find and generate specific character types
types = $ChartypeNew.keys.sort
gladiator_index = types.index("Gladiator") + 1
witch_black_index = types.index("Witch (black)") + 1  
wizard_fire_index = types.index("Wizard (fire)") + 1

puts "Finding character types in the new numbered system:"
puts "- Gladiator: ##{gladiator_index}"
puts "- Witch (black): ##{witch_black_index}" 
puts "- Wizard (fire): ##{wizard_fire_index}"

puts "\nGenerating a Wizard (fire)..."
npc = NpcNew.new("", "Wizard (fire)", 3, "", "", 0, 0, 0, "")
puts npc_output_new(npc, nil)