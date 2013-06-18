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

    def output_spec_dependencies
      require_content = ""
      @require_paths.each do |require_path|
        f = File.open(require_path, 'r')
        require_content << f.read
        f.close
      end
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
