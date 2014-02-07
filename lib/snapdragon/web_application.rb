require 'sinatra/base'
require 'erb'

module Snapdragon
  class WebApplication < Sinatra::Base
    set :static, false
    set :root, ::File.expand_path('.', ::File.dirname(__FILE__))

    def initialize(app = nil, suite)
      super()
      @suite = suite
    end

    get "/run" do
      erb :run
    end

    get "/jasmine_v1/*" do |path|
      send_file ::File.expand_path(::File.join('../jasmine_v1', path), ::File.dirname(__FILE__))
    end

    get "/resources/*" do |path|
      send_file ::File.expand_path(::File.join('resources', path), ::File.dirname(__FILE__))
    end

    get "/*" do |path|
      send_file ::File.expand_path(::File.join('.', path))
    end
  end
end
