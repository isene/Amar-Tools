#!/usr/bin/env ruby

require "erb"

$mn         = 0 if $mn         == nil
$weather_n  = 0 if $weather_n  == nil
$wind_dir_n = 0 if $wind_dir_n == nil
$wind_str_n = 0 if $wind_str_n == nil

load "../includes/includes.rb"

tmpl = File.read("../weather_input.html")

out = ERB.new(tmpl)

print "Content-type: text/html\n\n"
print out.result()
