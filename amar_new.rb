#!/usr/bin/ruby
#encoding: utf-8

# The main menu for the new Amar Tools (3-tier system)

$pgmdir = File.dirname(File.expand_path(__FILE__))
Dir.chdir($pgmdir)

# Load all required files
require 'tty-prompt'
load "includes/includes.rb"
load "includes/tables/tier_system.rb"
load "includes/tables/chartype_new_full.rb"
load "includes/tables/spells_new.rb"
load "includes/tables/enc_type.rb"
load "includes/tables/enc_specific.rb"
load "includes/tables/encounters.rb"
load "includes/tables/religions.rb"
load "includes/class_npc_new.rb"
load "includes/class_enc_new.rb"
load "cli_npc_input_new.rb"
load "cli_npc_output_new.rb"
load "cli_enc_input_new.rb"
load "cli_enc_output_new.rb"

def menu
  prompt = TTY::Prompt.new
  
  # Clear screen
  system("clear")
  
  # Display header with box characters
  puts "\u2554#{"═" * 58}\u2557"
  puts "\u2551#{"AMAR RPG TOOLS - NEW 3-TIER SYSTEM".center(58)}\u2551"
  puts "\u2551#{"Version 2.0 - ".ljust(58)}\u2551"
  puts "\u255a#{"═" * 58}\u255d"
  puts
  
  choices = {
    "Generate NPC (New System)" => 1,
    "Generate Encounter (New System)" => 2,
    "--- Old System Options ---" => nil,
    "Generate NPC (Old System)" => 3,
    "Generate Encounter (Old System)" => 4,
    "--- Information ---" => nil,
    "About" => 5,
    "Exit" => 6
  }
  
  choice = prompt.select("Choose option:", choices, filter: true, per_page: 10)
  
  case choice
  when 1
    # New NPC generation
    system("clear")
    npc = npc_input_new
    npc_output_new(npc, "cli")
    puts "\nPress any key to continue..."
    STDIN.getch
    menu
  when 2
    # New Encounter generation
    system("clear")
    enc_spec, enc_number, terraintype, level = enc_input_new
    enc = EncNew.new(enc_spec, enc_number, terraintype, level)
    enc_output_new(enc, "cli")
    puts "\nPress any key to continue..."
    STDIN.getch
    menu
  when 3
    # Old NPC generation
    system("clear")
    if File.exist?("cli_npc_input.rb") && File.exist?("cli_npc_output.rb")
      load "cli_npc_input.rb"
      load "cli_npc_output.rb"
      load "includes/class_npc.rb"
      npc = npc_input
      npc_output(npc, "cli")
    else
      puts "Old system files not found!"
      puts "Please ensure old system files are in place."
    end
    puts "\nPress any key to continue..."
    STDIN.getch
    menu
  when 4
    # Old Encounter generation
    system("clear")
    if File.exist?("cli_enc_input.rb") && File.exist?("cli_enc_output.rb")
      load "cli_enc_input.rb"
      load "cli_enc_output.rb"
      load "includes/class_enc.rb"
      enc_spec, enc_number = enc_input
      enc = Enc.new(enc_spec, enc_number)
      enc_output(enc, "cli")
    else
      puts "Old system files not found!"
      puts "Please ensure old system files are in place."
    end
    puts "\nPress any key to continue..."
    STDIN.getch
    menu
  when 5
    # About
    system("clear")
    puts "\u2554#{"═" * 70}\u2557"
    puts "\u2551#{"ABOUT AMAR TOOLS".center(70)}\u2551"
    puts "\u2560#{"═" * 70}\u2563"
    puts "\u2551#{"".ljust(70)}\u2551"
    puts "\u2551  Amar Tools v2.0 - The official toolset for the Amar RPG         \u2551"
    puts "\u2551#{"".ljust(70)}\u2551"
    puts "\u2551  NEW 3-TIER SYSTEM:                                               \u2551"
    puts "\u2551  - Hierarchical: Characteristics > Attributes > Skills            \u2551"
    puts "\u2551  - Natural progression based on training difficulty               \u2551"
    puts "\u2551  - Realistic population distribution                              \u2551"
    puts "\u2551  - Enhanced religious affiliations with variations                \u2551"
    puts "\u2551  - Day/Night encounter variations                                 \u2551"
    puts "\u2551#{"".ljust(70)}\u2551"
    puts "\u2551  Website: https://d6gaming.org                                    \u2551"
    puts "\u2551  Author: Geir Isene                                               \u2551"
    puts "\u2551  Migration: Claude (Anthropic)                                    \u2551"
    puts "\u2551#{"".ljust(70)}\u2551"
    puts "\u255a#{"═" * 70}\u255d"
    puts "\nPress any key to continue..."
    STDIN.getch
    menu
  when 6
    # Exit
    system("clear")
    puts "Thank you for using Amar Tools!"
    exit
  end
end

# Main program
begin
  # Set defaults
  $Day = 1      # Default to day
  $Terrain = 1  # Default to Rural
  $Level = 0    # Default level modifier
  
  # Start menu
  menu
rescue Interrupt
  system("clear")
  puts "\nExiting Amar Tools..."
  exit
end