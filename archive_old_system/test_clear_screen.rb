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

puts "This text should disappear when the character is displayed..."
puts "Press Enter to generate and display an NPC (screen will clear)"
gets

# Generate an NPC - the screen should clear before displaying
npc = NpcNew.new("Test Character", "Warrior", 3, "Amaronir", "M", 25, 180, 75, "")

# Output with CLI mode to test screen clearing
puts npc_output_new(npc, "cli")