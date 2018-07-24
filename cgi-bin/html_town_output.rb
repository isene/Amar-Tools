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
@t = aTOWN.town

# Start: From the CLI module
f = "#################################<By NPCg 0.5>#################################\n\n"

case aTOWN.town_size
when 1
  @tn = "Castle"
when 2..25
  @tn = "Village"
when 26..99
  @tn = "Town"
else
  @tn = "City"
end
@tn = " of #{aTOWN.town_name} - Houses: #{aTOWN.town_size} - Residents: #{aTOWN.town_residents}\n\n"
f += @tn

@t.length.times do |house|
	f += "##{house + 1}: #{@t[house][0]}\n"
	@t[house][1..-1].each do |r|
		f += "   #{r}\n"
	end
	f += "\n"
end
	
f += "###############################################################################\n\n"

tfile = "town.txt"
begin
	File.delete(tfile) if File.exists?(tfile)
	File.write(tfile, f, perm: 0644)
rescue
end
# End: From the CLI module

# Generate a relationship map
town_relations("town.txt")
town_dot2txt

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
