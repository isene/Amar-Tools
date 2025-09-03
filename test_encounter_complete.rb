#!/usr/bin/ruby
#encoding: utf-8

$pgmdir = File.dirname(File.expand_path(__FILE__))
Dir.chdir($pgmdir)

# Load required files
load "includes/includes.rb"
load "includes/tables/tier_system.rb"
load "includes/tables/chartype_new_full.rb"
load "includes/tables/spells_new.rb"
load "includes/tables/enc_type.rb"
load "includes/tables/enc_specific.rb"
load "includes/tables/encounters.rb"
load "includes/class_npc_new.rb"
load "includes/class_enc_new.rb"
load "cli_npc_output_new.rb"
load "cli_enc_output_new.rb"

puts "Testing Complete Encounter System"
puts "=" * 80

# Test different terrain types and day/night
test_cases = [
  [0, "City at night"],
  [8, "City during day"],
  [4, "Hills at night"],
  [12, "Hills during day"],
  [7, "Wilderness at night"],
  [15, "Wilderness during day"]
]

test_cases.each do |terraintype, description|
  puts "\n#{description} (Terraintype: #{terraintype})"
  puts "-" * 60
  
  # Set globals
  $Terraintype = terraintype
  $Terrain = terraintype % 8
  $Day = terraintype >= 8 ? 1 : 0
  $Level = rand(3) - 1  # -1 to +1
  
  # Generate encounter
  enc = EncNew.new("", 0, terraintype, $Level)
  
  if enc.is_no_encounter?
    puts "NO ENCOUNTER"
  else
    puts "#{enc.enc_attitude}: #{enc.summary}"
    puts "Number of NPCs: #{enc.npcs.length}"
    puts "Total threat level: #{enc.total_threat_level}"
    
    # Show first NPC details
    if enc.npcs.first
      npc = enc.npcs.first
      puts "\nFirst NPC: #{npc.type} (Level #{npc.level}, #{npc.sex})"
      puts "  BP: #{npc.BP}, DB: #{npc.DB}, MD: #{npc.MD}"
    end
  end
end

puts "\n" + "=" * 80
puts "\nTesting specific encounters"
puts "-" * 60

# Test specific encounter types
$Terraintype = 8  # City during day
$Terrain = 0
$Day = 1
$Level = 0

specific_types = ["Guard", "Merchant", "Thief", "Noble"]

specific_types.each do |type|
  enc = EncNew.new(type, 3, $Terraintype, $Level)
  
  puts "\n#{type} encounter:"
  puts "  #{enc.enc_attitude}: #{enc.summary}"
  puts "  NPCs: #{enc.npcs.map(&:type).join(', ')}"
end

puts "\n" + "=" * 80
puts "Encounter system test complete!"