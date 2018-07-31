#!/usr/bin/env ruby
#encoding: utf-8

# The simplest of input files
require "erb"

tmpl = File.read("../name_input.html")

$Name_type = 0 if $Name_type == nil

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
