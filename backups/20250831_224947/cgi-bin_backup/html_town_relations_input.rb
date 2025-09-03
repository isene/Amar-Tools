#!/usr/bin/env ruby
#encoding: utf-8

require "erb"

# Include all core files via includes.rb
load "../includes/includes.rb"

tmpl = File.read("../town_relations_input.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
