#!/usr/bin/env ruby
#encoding: utf-8

require "erb"

# Set global variables
$Level = 0 if $Level == nil
$Day = 1 if $Day == nil
$Terrain = 0 if $Terraintype == nil
$Terraintype = 8 if $Terraintype == nil

# Include all core files via includes.rb
load "../includes/includes.rb"

tmpl = File.read("../enc_input.html")

# Get all encounter types to display as input options
@sorted = Array.new
$Encounters.each_key do |key|
  @sorted.push(key)
end

# ...and sort them alphabetically
@sorted.sort!

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
