require_relative './path'

module Snapdragon
  class FileBase
    def initialize(path)
      @path = path
    end

    def relative_url_path
      ::File.join('/', @path.path)
    end

    def require_paths
      f = ::File.open(::File.expand_path(@path.path), 'r')
      lines = f.readlines
      f.close

      require_paths = []

      lines.each do |line|
        if line =~ /\/\/+\s+require_relative\(['"](.+)['"]\)\s+$/
          require_paths << ::File.join(::File.dirname(@path.path), $1)
        end
      end

      return require_paths
    end

    def require_files
      files = []
      require_paths.each do |require_path|
        files << Snapdragon::RequireFile.new(Snapdragon::Path.new(require_path))
      end
      return files
    end
  end
end

# I was getting some weirdness I think because of Cyclic Requires between
# require_file.rb and file_base.rb so I simply moved require_file.rb content
# into file_base.rb and it seemed to resolve it.
module Snapdragon
  class RequireFile < Snapdragon::FileBase
  end
end
