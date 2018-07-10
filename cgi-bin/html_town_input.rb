#!/usr/bin/env ruby

require "erb"

$Town_size = 10 if $Town_size == nil
$Town_var = 0 if $Town_var == nil

load "/var/www/isene.org/html/includes/includes.rb"

tmpl = File.read("../town_input.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
