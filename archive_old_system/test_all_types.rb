#!/usr/bin/ruby
#encoding: utf-8

$pgmdir = File.dirname(File.expand_path(__FILE__))
Dir.chdir($pgmdir)

# Load required files
load "includes/includes.rb"
load "includes/tables/tier_system.rb"
load "includes/tables/chartype_new_full.rb"  # Use the full character type file
load "includes/tables/spells_new.rb"
load "includes/class_npc_new.rb"
load "cli_npc_output_new.rb"

# Get a random character type
type = $ChartypeNewFull.keys.sample
puts "Generating a #{type}...\n\n"

# Generate the NPC
npc = NpcNew.new("", type, 3, "", "", 0, 0, 0, "")

# Output
puts npc_output_new(npc, nil)