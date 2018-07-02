#!/usr/bin/env ruby

require "cgi"
require "erb"

cgi = CGI.new
tmpl = File.read("../names_output.html")
p = File.expand_path(File.dirname(__FILE__)) + "/../"

c = $Name_type.to_i
@names = ""

n = ["Human male", "Human female", "Dwarven male", "Dwarven female", "Elven male", "Elven female", "Lizardfolk", "Troll", "Araxi"]
f = ["human_male_first.txt", "human_female_first.txt", "dwarven_male.txt", "dwarven_female.txt", "elven_male.txt", "elven_female.txt", "lizardfolk.txt", "troll.txt", "araxi.txt"]

@header = n[c] + " names"

10.times do
  @names +=  `#{p}name_generator/name_generator_main.rb -d #{f[c]}`.chomp + " "
  if /human/ =~ f[c]
	@names += `#{p}name_generator/name_generator_main.rb -d human_last.txt`.chomp
  else
	@names += `#{p}name_generator/name_generator_main.rb -d #{f[c]}`.chomp
  end
  @names += "\n"
end

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
