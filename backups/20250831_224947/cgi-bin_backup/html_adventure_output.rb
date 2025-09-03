#!/usr/bin/env ruby
#encoding: utf-8

require "erb"

# Include all core files via includes.rb
load "../includes/includes.rb"

tmpl = File.read("../adventure_output.html")

cmd        = "openai -f " + __dir__ + "/../amar.txt -x 2000"
@adventure = %x[#{cmd}]

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
