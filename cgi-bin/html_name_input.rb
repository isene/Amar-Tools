#!/usr/bin/env ruby

require "erb"

tmpl = File.read("../name_input.html")

$Name_type = 0 if $Name_type == nil

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
