#!/usr/bin/env ruby

require "erb"

load "../includes/includes.rb"

tmpl = File.read("../town_relations_input.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
