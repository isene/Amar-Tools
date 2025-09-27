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

# Generate a Summoner
npc = NpcNew.new("Marilee Gorby", "Summoner", 5, "Feronir", "F", 46, 164, 67, "")

# Output
puts npc_output_new(npc, nil)