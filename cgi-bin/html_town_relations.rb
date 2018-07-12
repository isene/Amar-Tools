#!/usr/bin/ruby
#encoding: utf-8

require "cgi"
require "erb"

cgi = CGI.new
@town = cgi.params["upfile"][0].read
File.write("town.txt", @town)

town_relations("/cgi-bin/town.txt")

tmpl = File.read("../town_relations_output.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
