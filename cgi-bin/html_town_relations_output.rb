#!/usr/bin/ruby
#encoding: utf-8

require "cgi"
require "erb"

load "../includes/includes.rb"

cgi = CGI.new
@town = cgi.params["upfile"][0].read
File.write("town.txt", @town) unless @town.to_s == ""

town_relations("town.txt")
town_dot2txt("town.txt")

tmpl = File.read("../town_relations_output.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
