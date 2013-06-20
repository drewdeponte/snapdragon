require_relative './path'

module Snapdragon
  class Suite
    def initialize(paths)
      @paths = paths
    end

    def spec_files
      spec_file_objs = []

      @paths.each do |raw_path|
        path = Snapdragon::Path.new(raw_path)
        spec_file_objs.concat(path.spec_files)
      end

      return spec_file_objs
    end

    def require_paths
      require_paths = Set.new

      spec_files.each do |foo|
        require_paths.merge(foo.require_paths)
      end

      return require_paths
    end

    def filtered?
      spec_files.each do |spec_file|
        return true if spec_file.filtered?
      end
      return false
    end

    def spec_query_param
      spec_files.each do |spec_file|
        return spec_file.spec_query_param if spec_file.filtered?
      end
      return ''
    end
  end
end
