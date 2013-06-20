require_relative './spec_file'

module Snapdragon
  class SpecDirectory
    def initialize(path)
      @path = path
    end

    def spec_files
      spec_file_objs = []
      Dir.glob("#{@path.path}/**/*").each do |raw_path|
        if raw_path =~ /^[\w\/\-\d]+[s|S]pec\.js$/
          spec_file_objs << Snapdragon::SpecFile.new(Snapdragon::Path.new(raw_path))
        end
      end
      return spec_file_objs
    end
  end
end
