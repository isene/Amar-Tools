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

# Generate a Gladiator with specific stats to match the example
npc = NpcNew.new("Kaison Coy", "Gladiator", 1, "Rauinir", "F", 21, 172, 73, "")

# Output (without cli mode to avoid interactive prompts)
puts npc_output_new(npc, nil)