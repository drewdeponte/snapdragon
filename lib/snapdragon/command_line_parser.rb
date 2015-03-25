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
      options.jasmine_ver = "2"
      options.phantom = {}

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
        opts.on('-N', "--nocolor", '--nocolour', 'Enable color in the output.') do
          options.color = false
        end
        opts.on('-P', '--pattern PATTERN', 'Load files matching pattern (default: "spec/**/*_spec.js").') do |pattern|
          options.pattern = pattern
        end
        opts.on('-J1', '--jasminev1', 'Use Jasmine v1.3.1 instead of the default v2.x.') do
          options.jasmine_ver = "1"
        end
        opts.on('-d', '--debug', 'Put phantomjs into debug mode') do
          options.phantom[:debug] = true 
        end
      end
      opts.parse!(args)
      options
    end
  end
end
