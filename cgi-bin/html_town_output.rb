#!/usr/bin/env ruby
#encoding: utf-8

require "cgi"
require "erb"

# Include all core files via includes.rb
load "../includes/includes.rb"
# ...and load this cli module to save downloadable town file
load "../cli_town_output.rb"

cgi = CGI.new
tmpl = File.read("../town_output.html")

# Get all variables for town creation from cgi
@town_size = cgi["town_size"].to_i
@town_size = 1 if @town_size < 1
# Set max size to limit stress on the server
@town_size = 200 if @town_size > 200
@town_var  = cgi["town_var"].to_i
@town_name = cgi["town_name"].to_s

# Create /castle/village/town/city
aTOWN = Town.new(@town_name, @town_size, @town_var)

# Use cli output function to write the town text file
town_output(aTOWN, "web")

# Generate a relationship map
town_relations($nfile)
# ...and generate it as text file
town_dot2txt($nfile)

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
