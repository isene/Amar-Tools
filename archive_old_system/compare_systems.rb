#!/usr/bin/ruby
#encoding: utf-8

$pgmdir = File.dirname(File.expand_path(__FILE__))
Dir.chdir($pgmdir)

# Load required files for new system
load "includes/includes.rb"
load "includes/tables/tier_system.rb"
load "includes/tables/chartype_new_full.rb"
load "includes/tables/spells_new.rb"
load "includes/class_npc_new.rb"
load "cli_npc_output_new.rb"

puts "=" * 120
puts "COMPARISON: 20 ADVANCED NPCs - NEW SYSTEM IMPROVEMENTS"
puts "=" * 120

# Test configurations
test_npcs = [
  # 10 with magic
  ["Alpharius the Wise", "Wizard (fire)", 6, "M"],
  ["Bethany Stormcaller", "Wizard (air)", 5, "F"],
  ["Caspian Darkwater", "Priest", 6, "M"],
  ["Diana Moonwhisper", "Witch (white)", 5, "F"],
  ["Ezra Shadowbane", "Sorcerer", 6, "M"],
  ["Freya Lightbringer", "Mage", 5, "F"],
  ["Gareth Ironspell", "Wizard (earth)", 6, "M"],
  ["Helena Frostweaver", "Wizard (water)", 5, "F"],
  ["Ivan Soulkeeper", "Summoner", 6, "M"],
  ["Jasmine Starweaver", "Sage", 5, "F"],
  
  # 10 without magic
  ["Klaus Ironfist", "Warrior", 6, "M"],
  ["Lyra Swiftblade", "Ranger", 5, "F"],
  ["Marcus Goldcoin", "Merchant", 6, "M"],
  ["Nina Shadowstep", "Thief", 5, "F"],
  ["Otto Strongarm", "Gladiator", 6, "M"],
  ["Petra Keeneye", "Hunter", 5, "F"],
  ["Quinn Silvertongue", "Noble", 6, "M"],
  ["Rosa Fleetfoot", "Scout", 5, "F"],
  ["Stefan Mastermind", "Scholar", 6, "M"],
  ["Tara Quickfingers", "Assassin", 5, "F"]
]

# Summary stats
magic_count = 0
total_skills_count = 0
spell_count_total = 0
correct_domains = 0
cult_affiliations = 0

# Generate each NPC with new system
test_npcs.each_with_index do |config, idx|
  name, type, level, sex = config
  
  puts "\n" + "=" * 80
  puts "NPC #{idx + 1}: #{name} - #{type} Level #{level}"
  puts "-" * 80
  
  # Generate with new system
  npc = NpcNew.new(name, type, level, "Capital", sex, rand(25..60), rand(160..190), rand(55..95), "")
  
  # Count skills
  total_skills = 0
  ["BODY", "MIND", "SPIRIT"].each do |char|
    npc.tiers[char].each do |attr_name, attr_data|
      if attr_data["skills"]
        attr_data["skills"].each do |skill_name, skill_value|
          total_skills += 1 if skill_value > 0
        end
      end
    end
  end
  total_skills_count += total_skills
  
  # Check magic
  if npc.has_magic?
    magic_count += 1
    spell_count_total += (npc.spells ? npc.spells.length : 0)
    
    # Check domain matching for wizards
    if type =~ /Wizard \((.*?)\)/
      expected_domain = $1.capitalize
      if npc.spells && npc.spells.length > 0
        domains = npc.spells.map { |s| s["domain"] }.uniq
        correct_domains += 1 if domains.include?(expected_domain)
        puts "  Spell Domains: #{domains.join(', ')} (Expected: #{expected_domain})"
      end
    end
  end
  
  # Check cult affiliation
  attunement = npc.tiers["SPIRIT"]["Attunement"]["level"] || 0
  has_cult = ["Priest", "Clergyman", "Monk"].include?(npc.type) || npc.has_magic? || attunement > 0
  cult_affiliations += 1 if has_cult
  
  puts "  Total Skills: #{total_skills}"
  puts "  Has Magic: #{npc.has_magic? ? 'Yes' : 'No'}"
  puts "  Spell Count: #{npc.spells ? npc.spells.length : 0}"
  puts "  Has Cult: #{has_cult ? 'Yes' : 'No'}"
end

puts "\n" + "=" * 80
puts "OVERALL SUMMARY:"
puts "-" * 80
puts "Average Skills per NPC: #{(total_skills_count.to_f / test_npcs.length).round(1)}"
puts "Magic Users: #{magic_count}/10 expected"
puts "Average Spells per Magic User: #{magic_count > 0 ? (spell_count_total.to_f / magic_count).round(1) : 0}"
puts "Wizards with Correct Spell Domains: #{correct_domains}/5"
puts "NPCs with Cult Affiliations: #{cult_affiliations}/20"
puts "=" * 80