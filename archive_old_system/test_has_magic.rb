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

# Test that has_magic? is now public
puts "Testing has_magic? method visibility..."

# Test with a Priest (should have magic)
priest = NpcNew.new("Test", "Priest", 3, "", "", 0, 0, 0, "")
puts "Priest has_magic?: #{priest.has_magic?}"

# Test with a Warrior (should not have magic)
warrior = NpcNew.new("Test", "Warrior", 3, "", "", 0, 0, 0, "")
puts "Warrior has_magic?: #{warrior.has_magic?}"

# Test full output with Priest to ensure no errors
puts "\nGenerating Priest output (should show cult info)..."
puts npc_output_new(priest, nil)