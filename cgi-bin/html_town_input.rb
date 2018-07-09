#!/usr/bin/env ruby

require "erb"

load "/var/www/isene.org/html/includes/includes.rb"

tmpl = File.read("../town_input.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
