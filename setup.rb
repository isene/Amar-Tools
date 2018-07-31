#! /usr/bin/ruby

# This is the setup program for Amar Tools.
# It must be run as root. After running it, you 
# can start Amar Tools via the command "npcg"

File.symlink(File.expand_path(__FILE__), /usr/bin/amar)

