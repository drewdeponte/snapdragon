require_relative '../../../lib/snapdragon/spec_directory'

describe Snapdragon::SpecDirectory do
  describe "#initialize" do
    it "assigns the given directory path" do
      spec_dir = Snapdragon::SpecDirectory.new('some/directory/path')
      spec_dir.instance_variable_get(:@path).should eq('some/directory/path')
    end
  end

  describe "#spec_files" do
    it "recursively explores the directory and its subdirectories building an array of spec files"
  end
end
