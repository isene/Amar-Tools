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

# Test with empty/zero values to trigger random generation
puts "Testing fixes for:"
puts "1. Random name/age/height/weight generation"
puts "2. No duplicate spells"
puts "3. Better skill distribution"
puts "4. Correct ENC penalty"
puts "=" * 120

npc = NpcNew.new("", "Wizard (water)", 6, "", "", 0, 0, 0, "")

# Output
puts npc_output_new(npc, nil)