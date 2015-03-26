require 'capybara'
require 'capybara/poltergeist'
require 'launchy'

require_relative './web_application'
require_relative './suite'

# Set the default_wait_time to something reasonable for the entire length of
# the test suite to run. This should probably eventually be something
# configurable because these could break for people with long running test
# suites.
Capybara.default_wait_time = 120 # 2 mins

module Snapdragon
  class CliApplication
    def initialize(options, paths)
      @suite = Snapdragon::Suite.new(options, paths)
      register_driver(options.driver)
    end

    def register_driver(options)
      Capybara.register_driver :snapdragon do |app|
        Capybara::Poltergeist::Driver.new(app, options)
      end
    end

    def run
      session = Capybara::Session.new(:snapdragon, Snapdragon::WebApplication.new(nil, @suite))
      if @suite.filtered?
        session.visit("/run?spec=#{@suite.spec_query_param}")
      else
        session.visit("/run")
      end
      session.find("#testscomplete")
      return 0
    end

    def serve
      server = Capybara::Server.new(Snapdragon::WebApplication.new(nil, @suite), 9292)
      server.boot
      if @suite.filtered?
        Launchy.open("http://localhost:9292/run?spec=#{@suite.spec_query_param}")
      else
        Launchy.open('http://localhost:9292/run')
      end
      trap('SIGINT') { puts "Shutting down..."; exit 0 }
      sleep
    end
  end
end
