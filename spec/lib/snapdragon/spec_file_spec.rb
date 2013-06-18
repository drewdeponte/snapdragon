require_relative "../../../lib/snapdragon/spec_file"

describe Snapdragon::SpecFile do
  describe "#initialize" do
    it "assigns the given path" do
      spec_file = Snapdragon::SpecFile.new('some/path/to_some_spec.js')
      spec_file.instance_variable_get(:@path).should eq('some/path/to_some_spec.js')
    end

    it "assigns the given line number" do
      spec_file = Snapdragon::SpecFile.new('some/path/to_some_spec.js', 54)
      spec_file.instance_variable_get(:@line_number).should eq(54)
    end

    it "line number defaults to nil when not assigned" do
      spec_file = Snapdragon::SpecFile.new('some/path/to_some_spec.js')
      spec_file.instance_variable_get(:@line_number).should eq(nil)
    end
  end
end
