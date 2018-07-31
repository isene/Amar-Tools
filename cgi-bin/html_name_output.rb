#!/usr/bin/env ruby
#encoding: utf-8

require "cgi"
require "erb"

cgi = CGI.new
tmpl = File.read("../name_output.html")

c = cgi["name_type"].to_i
@names = "<br />"

# Set arrays for races and corresponding name files
n = ["Human male", "Human female", "Dwarven male", "Dwarven female", "Elven male", "Elven female", "Lizardfolk", "Troll", "Araxi", "Generic male", "Generic female"]
f = ["human_male_first.txt", "human_female_first.txt", "dwarven_male.txt", "dwarven_female.txt", "elven_male.txt", "elven_female.txt", "lizardfolk.txt", "troll.txt", "araxi.txt", "fantasy_male.txt", "fantasy_female.txt" ]

@header = "<b>#{n[c]} names:</b>"

# Generate the names
10.times do
  @names +=  `../name_generator/name_generator_main.rb -d #{f[c]}`.chomp + " "
  if /human/ =~ f[c]
	@names += `../name_generator/name_generator_main.rb -d human_last.txt`.chomp
	elsif /fantasy/ =~ f[c]
  else
	@names += `../name_generator/name_generator_main.rb -d #{f[c]}`.chomp
  end
  @names += "<br /><br />"
end

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
