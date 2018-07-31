#!/usr/bin/env ruby
#encoding: utf-8

require "erb"

# Initialize global variables
$Town_size = 10 if $Town_size == nil
$Town_var = 0 if $Town_var == nil

# Include all core files via includes.rb
load "../includes/includes.rb"

tmpl = File.read("../town_input.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
