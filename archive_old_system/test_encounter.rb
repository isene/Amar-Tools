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
load "includes/class_enc_new.rb"
load "cli_enc_output_new.rb"

# Generate a test encounter
enc = EncNew.new("Warriors", 3)

# Output with test mode
enc_output_new(enc, "test")
puts enc_output_new(enc, nil)