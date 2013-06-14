$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')
require 'snapdragon/web_application'

run Rack::URLMap.new("/" => Snapdragon::WebApplication.new)
