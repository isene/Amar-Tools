#!/usr/bin/env ruby
#encoding: utf-8

require "erb"

# Include all core files via includes.rb
load "../includes/includes.rb"

tmpl = File.read("../npc_input.html")

# Get character types to display in the dropdown box
@sorted = Array.new
$Chartype.each_key do |key|
  @sorted.push(key)
end

# ...and sort them alphabetically
@sorted.sort!

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
