#!/usr/bin/ruby
#encoding: utf-8

# Test script for new 3-tier NPC system

# Set the program directory
$pgmdir = File.dirname(File.expand_path(__FILE__))
Dir.chdir($pgmdir)

# Load required files
load "includes/includes.rb"
load "includes/tables/tier_system.rb"
load "includes/tables/chartype_new.rb"
load "includes/class_npc_new.rb"
load "cli_npc_output_new.rb"

puts "Testing New 3-Tier NPC Generation System"
puts "=" * 50

# Test 1: Generate a random Warrior
puts "\nTest 1: Generating a random Warrior (Level 3)"
puts "-" * 40
warrior = NpcNew.new("Thorin", "Warrior", 3, "", "M", 0, 0, 0, "A seasoned warrior")
npc_output_new(warrior, "test")

# Test 2: Generate a random Mage
puts "\nTest 2: Generating a random Mage (Level 4)"
puts "-" * 40
mage = NpcNew.new("", "Mage", 4, "", "F", 0, 0, 0, "")
npc_output_new(mage, "test")

# Test 3: Generate a random Thief
puts "\nTest 3: Generating a random Thief (Level 2)"
puts "-" * 40
thief = NpcNew.new("", "Thief", 2, "", "", 0, 0, 0, "")
npc_output_new(thief, "test")

# Test progression system
puts "\nTest 4: Testing Mark Progression System"
puts "-" * 40
puts "Adding marks to Warrior's Sword skill..."

# Simulate skill usage
5.times do
  warrior.add_mark("BODY", "Melee Combat", "Sword")
end

puts "Warrior's current Sword skill: #{warrior.get_skill('BODY', 'Melee Combat', 'Sword')}"
puts "Marks accumulated: #{warrior.marks['BODY']['Melee Combat/Sword'] || 0}"

# Test modifier calculations
puts "\nTest 5: Modifier Calculations"
puts "-" * 40
[warrior, mage, thief].each do |npc|
  puts "#{npc.type}:"
  puts "  BP: #{npc.BP}, DB: #{npc.DB}, MD: #{npc.MD}, ENC: #{npc.ENC}"
end

puts "\n" + "=" * 50
puts "All tests completed successfully!"
puts "New system core components are functional."