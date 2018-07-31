#! /usr/bin/ruby

# This is the setup program for Amar Tools.
# It must be run as root from this directory. 
# After running it, you can start Amar Tools via the command "amar"

File.symlink(File.expand_path("amar.rb"), "/usr/bin/amar")

