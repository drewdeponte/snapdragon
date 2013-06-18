require_relative './spec_file'

module Snapdragon
  class SpecDirectory
    def initialize(path)
      @path = path
    end

    def spec_files
      spec_paths = []
      Dir.glob("#{@path}/**/*").each do |path|
        if path =~ /^[\w\/\-\d]+[s|S]pec\.js$/
          spec_paths << Snapdragon::SpecFile.new(path)
        end
      end
      return spec_paths
    end
  end
end
