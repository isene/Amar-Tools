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

@c = []
w.day.each_with_index do |d,i|
	@c[i] = "<p style=\"text-align:left\"><b>#{i+1}</b>"
	if d.special != ""
		g = d.special.delete(' ').downcase
		@c[i] += "<img src=\"/images/gods/#{g}.png\" alt=\"#{d.special}\" align=\"right\" style=\"vertical-align:top;\"/>"
	end
	@c[i] += "<img src=\"/images/moon/0.png\" alt=\"New moon\" align=\"right\" style=\"vertical-align:top;\"/>" if i == 0
	@c[i] += "<img src=\"/images/moon/1.png\" alt=\"Half moon vaxing\" align=\"right\" style=\"vertical-align:top;\"/>" if i == 7
	@c[i] += "<img src=\"/images/moon/2.png\" alt=\"Full moon\" align=\"right\" style=\"vertical-align:top;\"/>" if i == 14
	@c[i] += "<img src=\"/images/moon/3.png\" alt=\"Half moon waning\" align=\"right\" style=\"vertical-align:top;\"/>" if i == 21
	@c[i] += "</p>"
	@c[i] += "<img src=\"/images/weather/weather#{d.weather}.gif\" alt=\"#{$Weather[d.weather]}\" />"
	@c[i] += "<img src=\"/images/weather/wind#{d.wind}.gif\" alt=\"#{$Wind_str[d.wind_str]} (#{$Wind_dir[d.wind_dir]})\" />"
end

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
