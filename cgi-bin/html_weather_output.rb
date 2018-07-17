#!/usr/bin/env ruby

require "cgi"
require "erb"
require "date"

load "../includes/includes.rb"
load "../cli_enc_output.rb"

cgi = CGI.new
tmpl = File.read("../enc_output.html")

$month_n = cgi["month"].to_i
$weather_n = cgi["weather"].to_i
$wind_n = cgi["twind"].to_i

w = Weather_month.new($month_n, $weather_n, $wind_n)

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
