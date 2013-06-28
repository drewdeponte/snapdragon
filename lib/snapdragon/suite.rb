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

    def require_files
      return get_require_files_from_files(spec_files)
    end

    def require_file_relative_url_paths
      paths = Set.new
      require_files.each do |file|
        paths << file.relative_url_path
      end
      return paths
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

    private

    def get_require_files_from_files(files)
      req_files = []
      files.each do |file|
        req_files.concat(get_require_files_from_files(file.require_files))
        req_files.concat(file.require_files)
      end
      return req_files
    end
  end
end
