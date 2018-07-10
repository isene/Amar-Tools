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

# Start: From the CLI module
f = "#################################<By NPCg 0.5>#################################\n\n"

@t.length.times do |house|
	f += "##{house + 1}: #{@t[house][0]}\n"
	@t[house][1..-1].each do |r|
		f += "   #{r}\n"
	end
	f += "\n"
end
	
f += "###############################################################################\n\n"

begin
	File.delete("town.txt")
	File.open("town.txt", File::CREAT|File::EXCL|File::RDWR, 0644) do |fl|
		fl.write f
	end
rescue
end
# End: From the CLI module

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
