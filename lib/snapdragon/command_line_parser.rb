require 'optparse'
require 'ostruct'
require_relative './version'

module Snapdragon
  class CommandLineParser
    def self.parse(args)
      options = OpenStruct.new
      options.format = "console" 
      options.color = true
      options.pattern = "spec/**/*_spec.js"

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: snapdragon [options] [files or directories]"
        opts.on('-v', '--version', "Show the current version of this gem") do
          puts "#{Snapdragon::VERSION}"; exit
        end
        opts.on('-h', '--help', "show usage") do
          puts opts; exit
        end
        opts.on('-f', '--format [FORMAT]', "set output format") do |format|
          options.format = format
        end
        opts.on('-c', '--[no-]color', '--[no-]colour', 'Enable color in the output.') do |o|
          options.color = o
        end
        opts.on('-P', '--pattern PATTERN', 'Load files matching pattern (default: "spec/**/*_spec.js").') do |pattern|
          options.pattern = pattern
        end
      end
      opts.parse!(args)
      options
    end
  end
end
