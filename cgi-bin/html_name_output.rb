#!/usr/bin/env ruby
#encoding: utf-8

require "cgi"
require "erb"

cgi = CGI.new
tmpl = File.read("../name_output.html")

c = cgi["name_type"].to_i
@names = "<br />"

@header = "<b>#{$Names[c][0]} names:</b>"

# Generate the names
10.times do
  @names +=  naming($Names[c][0])
  @names += "<br /><br />"
end

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
