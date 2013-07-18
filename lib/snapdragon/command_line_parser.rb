require 'optparse'
require 'ostruct'
require_relative './version'

module Snapdragon
  class CommandLineParser
    def self.parse(args)
      options = OpenStruct.new
      options.format = "console" 

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
        if args.empty?
          puts opts; exit
        end
      end
      opts.parse!(args)
      options
    end
  end
end
