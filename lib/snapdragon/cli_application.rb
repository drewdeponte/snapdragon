module Snapdragon
  class CliApplication
    def initialize(arguements)
      @args = arguements
      @suite = Snapdragon::Suite.new
    end

    def run
      parse_arguements(@args)
    end

    private

    def parse_arguements(arguements)
      arguements.each do |arguement|
        parse_arguement(arguement)
      end
    end

    def parse_arguement(arguement)
      if is_a_file_path_and_line_number?(arguement)
        path, line_num_str = arguement.split(':')
        @suite.add_spec_file(SpecFile.new(path, line_num_str.to_i))
      elsif is_a_file_path?(arguement)
        @suite.add_spec_file(SpecFile.new(arguement))
      elsif is_a_directory?(arguement)
        spec_dir = Snapdragon::SpecDirectory.new(arguement)
        @suite.add_spec_files(spec_dir.spec_files)
      end
    end
  end
end
