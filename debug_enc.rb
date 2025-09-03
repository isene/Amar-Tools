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

# Generate a Gladiator
npc = NpcNew.new("Kaison Coy", "Gladiator", 1, "Rauinir", "F", 21, 172, 73, "")

puts "DEBUG ENCUMBRANCE CALCULATION:"
puts "SIZE: #{npc.SIZE}"
puts "Carrying skill: #{npc.get_skill('BODY', 'Strength', 'Carrying')}"
puts "ENC capacity: #{npc.ENC}"

# Calculate weight
def debug_weight(n)
  base = 5.0  # Base equipment
  armor = n.armor ? get_armor_weight(n.armor[:name]) : 0
  weapons = 6.0  # Estimate
  total = base + armor + weapons
  puts "Base equipment: #{base}kg"
  puts "Armor: #{armor}kg (#{n.armor ? n.armor[:name] : 'none'})"
  puts "Weapons: #{weapons}kg"
  puts "Total weight: #{total}kg"
  total
end

def get_armor_weight(armor_name)
  case armor_name
  when "Leather" then 3
  when "Chain mail" then 8
  when "Scale armor" then 6
  when "Plate armor" then 12
  else 0
  end
end

total_weight = debug_weight(npc)

puts "\nENCUMBRANCE THRESHOLDS:"
puts "ENC capacity: #{npc.ENC}"
puts "2x capacity (#{npc.ENC * 2}kg): No penalty"
puts "5x capacity (#{npc.ENC * 5}kg): -1 penalty"
puts "10x capacity (#{npc.ENC * 10}kg): -3 penalty"
puts "Weight carried: #{total_weight}kg"

enc_penalty = if total_weight <= npc.ENC * 2
  0
elsif total_weight <= npc.ENC * 5
  -1
elsif total_weight <= npc.ENC * 10
  -3
elsif total_weight <= npc.ENC * 20
  -5
else
  -10
end

puts "Calculated penalty: #{enc_penalty}"