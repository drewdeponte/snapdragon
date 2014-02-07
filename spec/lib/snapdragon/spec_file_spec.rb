require 'spec_helper'
require_relative "../../../lib/snapdragon/spec_file"

describe Snapdragon::SpecFile do
  describe "#initialize" do
    it "assigns the given path" do
      spec_file = Snapdragon::SpecFile.new('some/path/to_some_spec.js')
      expect(spec_file.instance_variable_get(:@path)).to eq('some/path/to_some_spec.js')
    end
  end

  describe "#read" do
    it "needs to be tested"
  end

  describe "#require_paths" do
    it "needs to be tested"
  end

  describe "#filtered?" do
    it "needs to be tested"
  end

  describe "#spec_query_param" do
    it "needs to be tested"
  end
end
