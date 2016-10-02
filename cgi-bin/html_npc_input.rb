#!/usr/bin/env ruby

require "erb"

load "/var/www/isene.org/html/includes/includes.rb"

tmpl = File.read("../npc_input.html")

@sorted = Array.new
$Chartype.each_key do |key|
  @sorted.push(key)
end

@sorted.sort!

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
