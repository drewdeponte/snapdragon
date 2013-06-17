module Snapdragon
  class Suite
    def initialize
      @specs = []
      @require_paths = []
    end

    def add_spec_file(spec_file)
      @specs << spec_file
      @require_paths.concat(spec_file.require_paths)
    end

    def add_spec_files(spec_files)
      spec_files.each do |spec|
        add_spec_file(spec)
      end
    end

    def spec_files
      @specs
    end
  end
end
