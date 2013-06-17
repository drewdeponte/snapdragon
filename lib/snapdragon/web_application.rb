require 'sinatra/base'
require 'erb'

module Snapdragon
  class WebApplication < Sinatra::Base
    set :static, false
    set :root, File.expand_path('.', File.dirname(__FILE__))

    def initialize(app = nil, suite)
      super()
      @suite = suite
    end

    helpers do
      def render_spec(spec_path)
        File.read(spec_path)
      end
    end

    get "/run" do
      erb :run
    end

    get "/jasmine-core/*" do |path|
      send_file File.expand_path(File.join('../jasmine/lib/jasmine-core', path), File.dirname(__FILE__))
    end

    get "/resources/*" do |path|
      send_file File.expand_path(File.join('resources', path), File.dirname(__FILE__))
    end
  end
end
