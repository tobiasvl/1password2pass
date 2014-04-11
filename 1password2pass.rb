#!/usr/bin/env ruby

# Copyright (C) 2014 Tobias V. Langhoff <tobias@langhoff.no>. All Rights Reserved.
# This file is licensed under GPLv2+. Please see COPYING for more information.
#
# Imports passwords from 1Password. Supports comma and tab delimited text files,
# as well as passwords (but not other data) stored in the 1Password Interchange File
# (1PIF) format.

#title,notes,username,password,url
#"login2","note2
#note2
#note2","username2","password2","location2"
#"title1","note1","username1","password1","location1"

require 'optparse'
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{opts.program_name} [options] filename"

  opts.on("-f", "--force", "Overwrite existing records") { options[:force] = true }
  opts.on("-d", "--default GROUP", "Place uncategorised records into GROUP") { |group| options[:group] = group }
  opts.on_tail("-h", "--help", "Display this screen") { puts opts; exit }

  begin 
    opts.parse!
  rescue OptionParser::InvalidOption
    puts optparse
    exit
  end
end

# Check for a filename
filename = ARGV.pop
unless filename
  puts optparse
  exit 1
end

puts "Reading '#{filename}'..."
