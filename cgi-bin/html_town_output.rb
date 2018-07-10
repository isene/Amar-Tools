#!/usr/bin/env ruby

require "cgi"
require "erb"

load "/var/www/isene.org/html/includes/includes.rb"

cgi = CGI.new
tmpl = File.read("../town_output.html")

@town_size = cgi["town_size"].to_i
@town_size = 1 if @town_size < 1
@town_size = 100 if @town_size > 100
@town_var  = cgi["town_var"].to_i
aTOWN = Town.new(@town_size, @town_var)
@t = aTOWN.town

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
