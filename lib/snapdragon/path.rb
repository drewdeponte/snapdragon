require_relative './spec_directory'
require_relative './spec_file'

module Snapdragon
  class Path
    attr_reader :path, :line_number

    def initialize(raw_path)
      @raw_path = raw_path
      if has_line_number?
        @path, @line_number = raw_path.split(':')
        @line_number = @line_number.to_i
      else
        @path = raw_path
      end
    end

    def spec_files
      if exists?
        if is_a_directory?
          spec_dir = Snapdragon::SpecDirectory.new(self)
          return spec_dir.spec_files
        else
          return [SpecFile.new(self)]
        end
      end
      return []
    end

    def has_line_number?
      return true if @raw_path =~ /^.*:\d+$/
      return false
    end

    private

    def is_a_directory?
      return File.directory?(@path)
    end

    def exists?
      return File.exists?(@path)
    end
  end
end
