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

# Generate a Wizard (air) to test spell formatting
npc = NpcNew.new("Gradevordo San", "Wizard (air)", 4, "Rauinir", "M", 31, 184, 71, "")

# Output
puts npc_output_new(npc, nil)