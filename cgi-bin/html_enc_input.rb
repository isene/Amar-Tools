#!/usr/bin/env ruby

require "erb"

$Level = 0 if $Level == nil
$Day = 1 if $Day == nil
$Terrain = 0 if $Terraintype == nil
$Terraintype = 8 if $Terraintype == nil

load "/var/www/isene.org/html/includes/includes.rb"

tmpl = File.read("../enc_input.html")

@sorted = Array.new
$Encounters.each_key do |key|
  @sorted.push(key)
end

@sorted.sort!

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
