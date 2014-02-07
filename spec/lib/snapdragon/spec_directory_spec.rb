require 'spec_helper'
require_relative '../../../lib/snapdragon/spec_directory'

describe Snapdragon::SpecDirectory do
  describe "#initialize" do
    it "assigns the given directory path" do
      spec_dir = Snapdragon::SpecDirectory.new('some/directory/path')
      expect(spec_dir.instance_variable_get(:@path)).to eq('some/directory/path')
    end
  end

  describe "#spec_files" do
    it "needs to be tested"
  end
end
