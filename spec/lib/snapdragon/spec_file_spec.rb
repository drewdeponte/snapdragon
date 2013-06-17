require_relative "../../../lib/snapdragon/spec_file"

describe Snapdragon::SpecFile do
  describe "#initialize" do
    it "assigns the given path" do
      spec_file = Snapdragon::SpecFile.new('some/path/to_some_spec.js')
      spec_file.instance_variable_get(:@path).should eq('some/path/to_some_spec.js')
    end
  end
end
