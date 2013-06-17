require_relative '../../../lib/snapdragon/suite'

describe Snapdragon::Suite do
  describe "#initialize" do
    it "assigns an empty array to hold all the spec files" do
      suite = Snapdragon::Suite.new
      suite.instance_variable_get(:@specs).should eq([])
    end

    it "assigns an empty arary to hold all the require files" do
      suite = Snapdragon::Suite.new
      suite.instance_variable_get(:@require_paths).should eq([])
    end
  end

  describe "#spec_files" do
    it "returns the array of specs which the suite contains" do
      spec_file = stub(:require_paths => [])
      subject.add_spec_file(spec_file)
      subject.spec_files.should eq([spec_file])
    end
  end

  describe "#add_spec_file" do
    it "appends the given SpecFile to the suite of specs" do
      spec_file = stub(:require_paths => [])
      specs = mock
      subject.instance_variable_set(:@specs, specs)
      specs.should_receive(:<<).with(spec_file)
      subject.add_spec_file(spec_file)
    end

    it "gets the require paths outlined in the spec" do
      spec_file = mock
      spec_file.should_receive(:require_paths).and_return([])
      subject.add_spec_file(spec_file)
    end

    it "contactinates the specs require paths to the suites require paths collection" do
      spec_file = stub
      require_paths = stub
      suite_require_paths = mock
      subject.instance_variable_set(:@require_paths, suite_require_paths)
      spec_file.stub(:require_paths).and_return(require_paths)
      suite_require_paths.should_receive(:concat).with(require_paths)
      subject.add_spec_file(spec_file)
    end
  end

  describe "#add_spec_files" do
    it "adds each of the spec files" do
      spec_file_one = stub('spec_file_one')
      spec_file_two = stub('spec_file_two')
      subject.should_receive(:add_spec_file).with(spec_file_one)
      subject.should_receive(:add_spec_file).with(spec_file_two)
      subject.add_spec_files([spec_file_one, spec_file_two])
    end
  end
end
