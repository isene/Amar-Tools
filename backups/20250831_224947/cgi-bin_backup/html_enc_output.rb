#!/usr/bin/env ruby
#encoding: utf-8

require "cgi"
require "erb"
require "date"

# Include all core files via includes.rb
load "../includes/includes.rb"
# ...and include the cli output file to write the downloadable encounter file
load "../cli_enc_output.rb"

cgi = CGI.new
tmpl = File.read("../enc_output.html")

# Set global variables to the inputted values from cgi
$Day = cgi["day"].to_i
$Day == 0 ? @day = "Night" : @day = "Day"
$Terrain = cgi["terrain"].to_i
case $Terrain
	when 0
		@terrain ="City"
	when 1
		@terrain ="Rural"
	when 2
		@terrain ="Road"
	when 3
		@terrain ="Plains"
	when 4
		@terrain ="Hills"
	when 5
		@terrain ="Mountains"
	when 6
		@terrain ="Woods"
	when 7
		@terrain ="Wilderness"
end

$Terraintype = $Terrain + (8 * $Day)

$Level = cgi["level"].to_s.to_i

@type = cgi["type"].to_s
@type = "" if @type == "(Type)"
@enc_number = cgi["enc_number"].to_i

# Create encounter for output
anENC = Enc.new(@type, @enc_number)
@e = anENC.encounter
@enc_number = anENC.enc_number
@enc_attitude = anENC.enc_attitude
@no_encounter = true if @e[0]["string"] =~ /NO ENCOUNTER/
@event = true if @e[0]["string"] =~ /Event:/

# Use cli output function to write the encounter text file
enc_output(anENC, "web")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
