module Snapdragon
  class SpecFile
    def initialize(path)
      @path = path
    end

    def read
      f = File.open(@path, 'r')
      content = f.read
      f.close
      return content
    end

    def requires
      f = File.open(@path, 'r')
      lines = f.readlines
      f.close

      requires_content = ""

      lines.each do |line|
        if line =~ /\/\/+\s+require_relative\(['"](.+)['"]\)\s+$/
          req_path = File.dirname(@path) + '/' + $1
          f = File.open(req_path, 'r')
          requires_content << f.read
          f.close
        end
      end

      return requires_content
    end
  end
end
