require 'capybara'
require 'capybara/poltergeist'
require 'launchy'

require_relative './web_application'
require_relative './suite'
require_relative './spec_file'
require_relative './spec_directory'

module Snapdragon
  class CliApplication
    def initialize(arguements)
      @args = arguements
      @suite = Snapdragon::Suite.new
    end

    def run
      parse_arguements(@args)
      run_suite
    end

    def serve
      parse_arguements(@args)
      server = Capybara::Server.new(Snapdragon::WebApplication.new(nil, @suite), 9292)
      server.boot
      Launchy.open('http://localhost:9292/run')
      trap('SIGINT') { puts "Shutting down..."; exit 0 }
      sleep
    end

    private

    def parse_arguements(arguements)
      arguements.each do |arguement|
        parse_arguement(arguement)
      end
    end

    def parse_arguement(arguement)
      if is_a_file_path_and_line_number?(arguement)
        path, line_num_str = arguement.split(':')
        @suite.add_spec_file(SpecFile.new(path, line_num_str.to_i))
      elsif is_a_file_path?(arguement)
        @suite.add_spec_file(SpecFile.new(arguement))
      elsif is_a_directory?(arguement)
        spec_dir = Snapdragon::SpecDirectory.new(arguement)
        @suite.add_spec_files(spec_dir.spec_files)
      end
    end

    def is_a_file_path_and_line_number?(arguement)
      arguement =~ /^[\w\/\-\d]+[s|S]pec\.js:\d+$/
    end

    def is_a_file_path?(arguement)
      arguement =~ /^[\w\/\-\d]+[s|S]pec\.js$/
    end

    def is_a_directory?(arguement)
      arguement =~ /^[\w\/\-\d]+$/
    end

    def run_suite
      session = Capybara::Session.new(:poltergeist, Snapdragon::WebApplication.new(nil, @suite))
      if @suite.filtered?
        session.visit("/run?spec=#{@suite.spec_query_param}")
      else
        session.visit("/run")
      end
    end
  end
end
