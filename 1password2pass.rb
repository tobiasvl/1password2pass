#!/usr/bin/env ruby

# Copyright (C) 2014 Tobias V. Langhoff <tobias@langhoff.no>. All Rights Reserved.
# This file is licensed under GPLv2+. Please see COPYING for more information.
#
# 1Password Importer
#
# Reads files exported from 1Password and imports them into pass. Supports comma
# and tab delimited text files, as well as passwords (but not other data)
# stored in the 1Password Interchange File (1PIF) format.

require 'optparse'
require 'ostruct'
require 'csv'

accepted_formats = ['.txt', '.1pif']

options = OpenStruct.new
options.force = false
options.title = "title"
options.notes = true

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{opts.program_name}.rb [options] filename"

  opts.on("-f", "--force", "Overwrite existing records") { options.force = true }
  opts.on("-d", "--default [GROUP]", "Place uncategorised records into GROUP") { |group| options.group = group }
  opts.on("-n", "--name [PASS-NAME]", [:title, :location], "Select field to use as pass-name: title (default) or location (URL)") { |title| options.title = title }
  opts.on("-u", "--username", "Import username and add it below the password") { options.username = true }
  opts.on("-l", "--location", "Import location (URL) and add it below the password") { options.location = true }
  opts.on("-i", "--ignore-notes", "Do not import notes (default behavior is to add notes below the password)") { options.notes = false }
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
unless filename and accepted_formats.include? File.extname(filename)
  puts optparse
  exit 1
end

# comma or tab delimited text
if File.extname(filename) =~ /.txt/i
  delimiter = ''
  File.open(filename, "r") do |file|
    first_line = file.readline

    # Very simple way to guess the delimiter
    if first_line =~ /,/
      delimiter = ","
    elsif first_line =~ /\t/
      delimiter = "\t"
    else
      puts "File is neither comma nor tab delimited. Aborting."
      exit 1
    end
  end

  # Import the data
  CSV.foreach(filename, {:col_sep => delimiter, :headers => true}) do |pass|
    IO.popen("pass insert -m '#{(options.group + "/") if options.group}#{pass[options.title]}'", 'w') do |io|
      io.puts pass['password']
      io.puts "Username: #{pass['username']}" if options.username and pass['username'] != ""
      io.puts "Location: #{pass['location']}" if options.location and pass['location'] != ""
      io.puts pass['notes'] if options.notes
    end
  end
# 1PIF format
elsif File.extname(filename) =~ /.1pif/i
  # XXX
end
puts `PASSWORD_STORE_DIR=~/.pass-test; pass ls`
