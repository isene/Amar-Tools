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
load "cli_npc_input_new.rb"

# Test the input function
puts "Testing the new numbered character type selection..."

# Mock the input to avoid interactive session - just show the list
types = $ChartypeNew.keys.sort
puts "\nCharacter Types (#{types.length} available):"
puts "0: Random"

# Display types in 3 columns
types.each_with_index do |type_name, index|
  number = index + 1
  print "#{number.to_s.rjust(2)}: #{type_name}".ljust(25)
  print "\n" if number % 3 == 0
end
puts "\n" if types.length % 3 != 0

puts "\nExample: To select 'Gladiator', you would enter its number from the list above."
puts "This replaces the long scrolling menu with a quick number entry."