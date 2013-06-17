module Snapdragon
  class Suite
    def initialize
      @specs = []
    end

    def add_spec_file(spec_file)
      @specs << spec_file
    end

    def add_spec_files(spec_files)
      @specs.concat(spec_files)
    end

    def spec_files
      @specs
    end
  end
end
