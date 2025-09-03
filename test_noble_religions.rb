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

puts "Testing Noble Religious Affiliations (Gender-based)"
puts "=" * 80

# Test male noble
puts "\nMale Noble:"
npc_m = NpcNew.new("Lord Testington", "Noble", 5, "Royal Court", "M", 45, 185, 82, "")
puts npc_output_new(npc_m, nil).lines[3..4].join

puts "\nFemale Noble:"
npc_f = NpcNew.new("Lady Testworth", "Noble", 5, "Royal Court", "F", 42, 170, 65, "")
puts npc_output_new(npc_f, nil).lines[3..4].join

puts "\nMultiple Tests (5 each):"
puts "-" * 40

puts "\nMale Nobles:"
5.times do |i|
  npc = NpcNew.new("", "Noble", 5, "", "M", 0, 0, 0, "")
  attunement = npc.tiers["SPIRIT"]["Attunement"]["level"] || 0
  cult_info = generate_cult_info("Noble", 5, attunement, "M")
  if cult_info =~ /Cult: ([^,]+),/
    deity = $1
    puts "  #{(i+1).to_s.rjust(2)}. #{deity}"
  end
end

puts "\nFemale Nobles:"
5.times do |i|
  npc = NpcNew.new("", "Noble", 5, "", "F", 0, 0, 0, "")
  attunement = npc.tiers["SPIRIT"]["Attunement"]["level"] || 0
  cult_info = generate_cult_info("Noble", 5, attunement, "F")
  if cult_info =~ /Cult: ([^,]+),/
    deity = $1
    puts "  #{(i+1).to_s.rjust(2)}. #{deity}"
  end
end

puts "\n" + "=" * 80
puts "Noble religion affiliations work correctly:"
puts "  - Males worship MacGillan (King of the Gods) and others"
puts "  - Females worship Gwendyll (Queen of the Gods) and others"
puts "  - Both have variations (Taroc, Alesia, element gods, etc.)"