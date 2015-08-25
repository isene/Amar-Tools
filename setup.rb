#! /usr/bin/ruby

# This is the setup program for NPC Generation.
# It must be run as root. After running it, you 
# can start NPCg via the command "npcg"

File.symlink(File.expand_path(__FILE__), /usr/bin/npcg)

