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

puts "Testing Religious Affiliations"
puts "=" * 80

# Test various character types
test_types = [
  ["Wizard (water)", 5, "Should worship Walmaer"],
  ["Wizard (fire)", 5, "Should worship Ikalio"],
  ["Wizard (air)", 5, "Should worship Shalissa"],
  ["Wizard (earth)", 5, "Should worship Alesia"],
  ["Warrior", 4, "Should worship Taroc"],
  ["Ranger", 4, "Should worship Anashina"],
  ["Scholar", 4, "Should worship Fal Munir"],
  ["Merchant", 4, "Should worship Mailatroz"],
  ["Thief", 4, "Should worship Tsankili"],
  ["Noble", 4, "Should worship Gwendyll"]
]

test_types.each do |type, level, expectation|
  npc = NpcNew.new("", type, level, "", "", 0, 0, 0, "")
  
  # Get cult info
  attunement = npc.tiers["SPIRIT"]["Attunement"]["level"] || 0
  cult_info = generate_cult_info(type, level, attunement)
  
  puts "\n#{type.ljust(20)} => #{cult_info.ljust(35)} (#{expectation})"
end

puts "\n" + "=" * 80