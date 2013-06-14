$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')
require 'jasmine_cl_runner/web_application'

run Rack::URLMap.new("/" => JasmineClRunner::WebApplication.new)
