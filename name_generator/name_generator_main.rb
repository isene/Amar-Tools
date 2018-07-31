#!/usr/bin/ruby
#encoding: utf-8

# This is the name generator created by Alan Skorkin
# (https://www.skorks.com/2009/07/how-to-write-a-name-generator-in-ruby/)

# Ensure correct path
if File::symlink?($0)
    $pgmdir = File::dirname(File::expand_path(File::readlink($0), \
    File::dirname(File::expand_path($0))))
else
    $pgmdir = File::dirname(File::expand_path($0))
end

Dir.chdir($pgmdir)

require "./argument_parser.rb"
require "./data_handler.rb"
require "./name_generator.rb"

argument_parser = ArgumentParser.new
argument_parser.parse_arguments
data_handler = DataHandler.new
data_handler.read_data_file(argument_parser.data_file)
name_generator = NameGenerator.new(data_handler.follower_letters)
begin
  names = name_generator.generate_names(data_handler.start_pairs, argument_parser.words_to_generate)
  names.each {|name| puts name}
rescue
end

