#!/usr/bin/ruby
#encoding: utf-8

# Test script to verify no skill totals can exceed 18

$pgmdir = File.dirname(File.expand_path(__FILE__))
Dir.chdir($pgmdir)

# Load required files
load "includes/includes.rb"
load "includes/tables/tier_system.rb"
load "includes/tables/chartype_new.rb"
load "includes/tables/spells_new.rb"
load "includes/class_npc_new.rb"

puts "Testing Natural 18 Limit Across All Character Types"
puts "=" * 60

max_found = 0
violations = []

# Test each character type at various levels
$ChartypeNew.keys.each do |type|
  [1, 3, 5, 7].each do |level|
    # Generate multiple NPCs to account for randomness
    5.times do
      npc = NpcNew.new("", type, level, "", "", 0, 0, 0, "")
      
      # Check all skill totals
      ["BODY", "MIND", "SPIRIT"].each do |char|
        npc.tiers[char].each do |attr_name, attr_data|
          attr_data["skills"].each do |skill_name, skill_level|
            next if skill_level == 0
            
            total = npc.get_skill_total(char, attr_name, skill_name)
            
            if total > max_found
              max_found = total
            end
            
            if total > 18
              violations << {
                type: type,
                level: level,
                skill: "#{char}/#{attr_name}/#{skill_name}",
                total: total
              }
            end
          end
        end
      end
    end
  end
end

puts "\nResults:"
puts "-" * 40

if violations.empty?
  puts "✓ SUCCESS: No skill totals exceeded 18"
  puts "Maximum total found: #{max_found}"
else
  puts "✗ FAILURE: Found #{violations.length} violations"
  puts "\nViolations:"
  violations[0..10].each do |v|
    puts "  #{v[:type]} L#{v[:level]}: #{v[:skill]} = #{v[:total]}"
  end
  puts "  ..." if violations.length > 10
end

# Also test the mathematical limits
puts "\n" + "-" * 40
puts "Theoretical Maximum:"
puts "  Characteristic: 5 (hard limit)"
puts "  Attribute: 6 (hard limit)"
puts "  Skill: 7 (hard limit)"
puts "  Total: 5 + 6 + 7 = 18 ✓"