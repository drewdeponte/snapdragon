require_relative '../../../lib/snapdragon/suite'

describe Snapdragon::Suite do
  describe "#initialize" do
    it "constucts an instance of a Suite given an array of paths" do
      paths = [stub, stub, stub]
      Snapdragon::Suite.new(paths)
    end

    it "stores the paths in an instance variable" do
      paths = [stub, stub, stub]
      suite = Snapdragon::Suite.new(paths)
      suite.instance_variable_get(:@paths).should eq(paths)
    end
  end

  describe "#spec_files" do
    it "creates a path object to represent the path" do
      paths = ['path_a_str', 'path_b_str']
      suite = Snapdragon::Suite.new(paths)
      Snapdragon::Path.should_receive(:new).with('path_a_str').and_return(stub(spec_files: []))
      Snapdragon::Path.should_receive(:new).with('path_b_str').and_return(stub(spec_files: []))
      suite.spec_files
    end

    it "returns the collection of the spec files of all of the paths" do
      paths = ['path_a_str', 'path_b_str']
      suite = Snapdragon::Suite.new(paths)
      spec_file_a = stub('spec_file_a'), spec_file_b = stub('spec_file_b')
      Snapdragon::Path.stub(:new).with('path_a_str').and_return(stub(spec_files: [spec_file_a]))
      Snapdragon::Path.stub(:new).with('path_b_str').and_return(stub(spec_files: [spec_file_b]))
      suite.spec_files.should eq([spec_file_a, spec_file_b])
    end
  end

  describe "#require_paths" do
    it "returns the merged set of the require paths of each spec file" do
      pending
    end
  end
end
