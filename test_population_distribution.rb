#!/usr/bin/ruby
#encoding: utf-8

# Test population distribution matches requirements

$pgmdir = File.dirname(File.expand_path(__FILE__))
Dir.chdir($pgmdir)

# Load required files
load "includes/includes.rb"
load "includes/tables/tier_system.rb"
load "includes/tables/chartype_new.rb"
load "includes/tables/spells_new.rb"
load "includes/class_npc_new.rb"

puts "Testing Population Distribution"
puts "=" * 60

# Test different NPC levels
results = {}

[1, 2, 3, 4, 5, 6, 7].each do |level|
  puts "\nLevel #{level} NPCs (10 samples):"
  puts "-" * 40
  
  totals = []
  10.times do
    # Generate a warrior for consistent testing
    npc = NpcNew.new("", "Warrior", level, "", "", 0, 0, 0, "")
    
    # Get best combat skill total
    best_total = 0
    ["BODY"].each do |char|
      npc.tiers[char].each do |attr_name, attr_data|
        if attr_name == "Melee Combat"
          attr_data["skills"].each do |skill_name, _|
            total = npc.get_skill_total(char, attr_name, skill_name)
            best_total = total if total > best_total
          end
        end
      end
    end
    
    totals << best_total
  end
  
  avg = totals.sum.to_f / totals.size
  puts "Best combat skill totals: #{totals.join(', ')}"
  puts "Average: #{avg.round(1)}, Range: #{totals.min}-#{totals.max}"
  
  results[level] = { avg: avg, min: totals.min, max: totals.max }
end

puts "\n" + "=" * 60
puts "Population Distribution Summary:"
puts "-" * 40

results.each do |level, stats|
  category = case level
             when 1..2 then "Common folk"
             when 3..4 then "Town champions"
             when 5..6 then "Regional masters"
             else "National heroes"
             end
  
  expected = case level
             when 1 then "5-6"
             when 2 then "7-8"
             when 3 then "9-10"
             when 4 then "11-13"
             when 5 then "14-15"
             when 6 then "16-17"
             else "18+"
             end
  
  puts "L#{level} (#{category}): #{stats[:min]}-#{stats[:max]} (Expected: #{expected})"
end

puts "\nConclusion:"
puts "The system should generate:"
puts "- Village (L1-2): Most at 5-8"
puts "- Town champions (L3-4): 12-14, few at 15-16"
puts "- Regional masters (L5-6): 16-17"
puts "- National heroes (L7+): 17-18+"