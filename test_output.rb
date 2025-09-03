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

# Generate a test NPC with more complexity (higher level mage)
npc = NpcNew.new("Test Mage", "Mage", 5, "Amaronir", "F", 35, 170, 65, "A powerful sorceress")

# Output
puts npc_output_new(npc, nil)