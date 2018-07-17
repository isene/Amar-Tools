#!/usr/bin/env ruby

require "cgi"
require "erb"

load "../includes/includes.rb"

cgi = CGI.new
tmpl = File.read("../weather_output.html")

$month_n = cgi["month"].to_i
$weather_n = cgi["weather"].to_i
$wind_n = cgi["wind"].to_i
$bgc = "#ffffff"
case $month_n
	when 1
		$bgc = "#ffffff"
	when 2
		$bgc = "#ffffff"
	when 3
		$bgc = "#80d55b"
	when 4
		$bgc = "#eab8f5"
	when 5
		$bgc = "#bd98f3"
	when 6
		$bgc = "#98e3f3"
	when 7
		$bgc = "#afafaf"
	when 8
		$bgc = "#dcb796"
	when 9
		$bgc = "#ad9d8f"
	when 10
		$bgc = "#e9e4b0"
	when 11
		$bgc = "#ffc37d"
	when 12
		$bgc = "#6f6f6f"
	when 13
		$bgc = "#525252"
end

w = Weather_month.new($month_n, $weather_n, $wind_n)

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
