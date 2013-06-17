module Snapdragon
  class Suite
    def initialize
      @specs = []
      @require_paths = Set.new
    end

    def add_spec_file(spec_file)
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
  end
end
