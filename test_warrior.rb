#!/usr/bin/ruby
#encoding: utf-8

$pgmdir = File.dirname(File.expand_path(__FILE__))
Dir.chdir($pgmdir)

# Load required files
load "includes/includes.rb"
load "includes/tables/tier_system.rb"
load "includes/tables/chartype_new.rb"
load "includes/tables/spells_new.rb"
load "includes/class_npc_new.rb"
load "cli_npc_output_new.rb"

# Generate a test Warrior
npc = NpcNew.new("Test Warrior", "Warrior", 4, "Amaronir", "M", 30, 185, 85, "A veteran soldier")

# Output
puts npc_output_new(npc, nil)