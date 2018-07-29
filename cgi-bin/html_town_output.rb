#!/usr/bin/env ruby

require "cgi"
require "erb"

load "../includes/includes.rb"

cgi = CGI.new
tmpl = File.read("../town_output.html")

@town_size = cgi["town_size"].to_i
@town_size = 1 if @town_size < 1
@town_size = 200 if @town_size > 200
@town_var  = cgi["town_var"].to_i
@town_name = cgi["town_name"].to_s
aTOWN = Town.new(@town_name, @town_size, @town_var)
# Use cli output function to write the town text file
town_output(aTOWN, "web")

# Generate a relationship map
#town_relations($nfile)
#town_dot2txt($nfile)

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
