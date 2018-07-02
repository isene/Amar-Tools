#!/usr/bin/env ruby

require "erb"

tmpl = File.read("../name_input.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
