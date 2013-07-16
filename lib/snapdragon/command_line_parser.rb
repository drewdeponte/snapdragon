require 'optparse'
require_relative './version'

module Snapdragon
  class CommandLineParser
    def self.parse(args)
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: snapdragon [options] [files or directories]"
        opts.on('-v', '--version', "Show the current version of this gem") do
          puts "#{Snapdragon::VERSION}"; exit
        end
        opts.on('-h', '--help', "show usage") do
          puts opts; exit
        end
        if args.empty?
          puts opts; exit
        end
      end
    opts.parse!(args)
    end
  end
end
