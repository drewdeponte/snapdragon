module Snapdragon
  class Suite
    def initialize
      @specs = []
      @require_paths = Set.new
      @filtered = false
      @spec_query_param = ''
    end

    def add_spec_file(spec_file)
      if spec_file.filtered?
        @filtered = true
        @spec_query_param = spec_file.spec_query_param
      end
      @specs << spec_file
      @require_paths.merge(spec_file.require_paths)
    end

    def add_spec_files(spec_files)
      spec_files.each do |spec|
        add_spec_file(spec)
      end
    end

    def spec_files
      @specs
    end

    def require_paths
      @require_paths
    end

    def output_spec_dependencies
      require_content = "// output spec dependencies begin here\n\n"
      @require_paths.each do |require_path|
        require_content << "\n\n// #{require_path} begins here\n"
        f = File.open(require_path, 'r')
        require_content << f.read
        require_content << "\n// #{require_path} ends here\n\n"
        f.close
      end
      require_content << "\n// output spec dependencies end here\n"
      return require_content
    end

    def spec_query_param
      @spec_query_param
    end

    def filtered?
      @filtered
    end
  end
end
