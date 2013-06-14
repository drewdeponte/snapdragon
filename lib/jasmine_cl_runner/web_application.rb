require 'sinatra/base'
require 'erb'

module JasmineClRunner
  class WebApplication < Sinatra::Base
    set :static, false
    set :root, File.expand_path('.', File.dirname(__FILE__))

    helpers do
      def render_spec(spec_path)
        File.read(spec_path)
      end
    end

    get "/hello" do
      "Hello World!"
    end

    get "/run/*" do |path|
      @spec_path = path
      erb :run
    end

    get "/jasmine-core/*" do |path|
      send_file File.expand_path(File.join('../jasmine/lib/jasmine-core', path), File.dirname(__FILE__))
    end

    get "/jasmine/*" do |path|
      send_file File.expand_path(File.join('../jasmine/src', path), File.dirname(__FILE__))
    end

    get "/resources/*" do |path|
      send_file File.expand_path(File.join('resources', path), File.dirname(__FILE__))
    end
  end
end
