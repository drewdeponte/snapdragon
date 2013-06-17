require_relative '../../../lib/snapdragon/suite'

describe Snapdragon::Suite do
  describe "#initialize" do
    it "assigns an empty array to hold all the spec files" do
      suite = Snapdragon::Suite.new
      suite.instance_variable_get(:@specs).should eq([])
    end
  end

  describe "#add_spec_file" do
    it "appends the given SpecFile to the suite of specs" do
      spec_file = stub
      specs = mock
      subject.instance_variable_set(:@specs, specs)
      specs.should_receive(:<<).with(spec_file)
      subject.add_spec_file(spec_file)
    end
  end

  describe "#add_spec_files" do
    it "concatinates the given array of SpecFiles to the suite of specs" do
      spec_files = stub
      specs = mock
      subject.instance_variable_set(:@specs, specs)
      specs.should_receive(:concat).with(spec_files)
      subject.add_spec_files(spec_files)
    end
  end
end
