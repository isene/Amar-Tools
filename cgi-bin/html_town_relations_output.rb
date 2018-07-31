#!/usr/bin/ruby
#encoding: utf-8

require "cgi"
require "erb"

# Include all core files via includes.rb
load "../includes/includes.rb"

# Get all parameters from cgi
cgi = CGI.new
# Read the uploaded file
@town = cgi.params["upfile"][0].read
File.write("town.txt", @town) unless @town.to_s == ""

# Generate relationship map
town_relations("town.txt")
# ...and as text file
town_dot2txt("town.txt")

tmpl = File.read("../town_relations_output.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
