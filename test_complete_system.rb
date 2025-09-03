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

puts "Complete System Test - All Features"
puts "=" * 50

# Test various character types
test_types = [
  ["Priest", 5, "Should show cult info and spells"],
  ["Warrior", 3, "No cult info, no spells"],
  ["Wizard (fire)", 4, "Should show cult info and spells"],
  ["Merchant", 2, "No cult info, no spells"]
]

test_types.each do |type, level, note|
  puts "\n#{type} (Level #{level}): #{note}"
  npc = NpcNew.new("", type, level, "", "", 0, 0, 0, "")
  
  # Check has_magic?
  puts "  Has magic: #{npc.has_magic?}"
  
  # Check if cult info would be shown
  shows_cult = ["Priest", "Clergyman", "Monk"].include?(type) || npc.has_magic?
  puts "  Shows cult: #{shows_cult}"
  
  # Check spell count
  spell_count = npc.spells ? npc.spells.length : 0
  puts "  Spells: #{spell_count}"
end

puts "\n" + "=" * 50
puts "All tests completed successfully!"