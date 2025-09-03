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

puts "Testing Final Formatting - All Fixes Applied"
puts "=" * 50

# Test different character types to ensure no "1d6" appears
types = ["Wizard (air)", "Warrior", "Ranger", "Assassin"]

types.each do |type|
  npc = NpcNew.new("", type, 3, "", "", 0, 0, 0, "")
  output = npc_output_new(npc, nil)
  
  if output.include?("1d6")
    puts "ERROR: Found '1d6' in #{type} output!"
    puts output.lines.select { |line| line.include?("1d6") }
  else
    puts "✓ #{type}: No '1d6' found"
  end
end

puts "\n" + "=" * 50
puts "Showing complete Wizard (air) output:"
puts "=" * 50 + "\n"

# Show full wizard output
wizard = NpcNew.new("Merlin the Wise", "Wizard (air)", 5, "Amaronir", "M", 45, 175, 65, "")
puts npc_output_new(wizard, nil)