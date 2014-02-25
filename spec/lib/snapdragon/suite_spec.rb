require 'spec_helper'
require_relative '../../../lib/snapdragon/suite'

describe Snapdragon::Suite do
  describe "#initialize" do
    it "constucts an instance of a Suite given an array of paths" do
      options = double
      paths = [double, double, double]
      Snapdragon::Suite.new(options, paths)
    end

    it "stores the paths in an instance variable" do
      options = double
      paths = [double, double, double]
      suite = Snapdragon::Suite.new(options, paths)
      expect(suite.instance_variable_get(:@paths)).to eq(paths)
    end

    it 'stores the options in an instance variable' do
      options = double
      paths = [double, double, double]
      suite = Snapdragon::Suite.new(options, paths)
      expect(suite.instance_variable_get(:@options)).to eq(options)
    end
  end

  describe "#formatter" do
    it "returns the configured formatter to use" do
      formatter = double
      options = double(format: formatter)
      suite = Snapdragon::Suite.new(options, double)
      expect(suite.formatter).to be(formatter)
    end
  end

  describe "#use_color?" do
    it "returns the configured color setting" do
      color = double
      options = double(color: color)
      suite = Snapdragon::Suite.new(options, double)
      expect(suite.use_color?).to be(color)
    end
  end

  describe "#pattern" do
    it "returns the configured pattern setting" do
      pattern = double
      options = double(pattern: pattern)
      suite = Snapdragon::Suite.new(options, double)
      expect(suite.pattern).to be(pattern)
    end
  end

  describe "#jasmine_ver" do
    it "returns the Jasmine version being used" do
      jasmine_ver = double('Jasmine version')
      options = double(jasmine_ver: jasmine_ver)
      suite = Snapdragon::Suite.new(options, double)
      expect(suite.jasmine_ver).to be(jasmine_ver)
    end
  end

  describe "#spec_files" do
    context "when paths are provided" do
      it "does not read pattern from options" do
        pattern = double
        options = double(pattern: pattern)
        paths = ['path_a_str', 'path_b_str']
        suite = Snapdragon::Suite.new(options, paths)
        expect(suite).not_to receive(:pattern)
        suite.spec_files
      end

      it "creates a path object to represent the path" do
        options = double
        paths = ['path_a_str', 'path_b_str']
        suite = Snapdragon::Suite.new(options, paths)
        expect(Snapdragon::Path).to receive(:new).with('path_a_str').and_return(double(spec_files: []))
        expect(Snapdragon::Path).to receive(:new).with('path_b_str').and_return(double(spec_files: []))
        suite.spec_files
      end

      it "returns the collection of the spec files of all of the paths" do
        options = double
        paths = ['path_a_str', 'path_b_str']
        suite = Snapdragon::Suite.new(options, paths)
        spec_file_a = double('spec_file_a'), spec_file_b = double('spec_file_b')
        allow(Snapdragon::Path).to receive(:new).with('path_a_str').and_return(double(spec_files: [spec_file_a]))
        allow(Snapdragon::Path).to receive(:new).with('path_b_str').and_return(double(spec_files: [spec_file_b]))
        expect(suite.spec_files).to eq([spec_file_a, spec_file_b])
      end
    end

    context "when paths are empty" do
      it "reads the pattern from the options" do
        pattern = double
        options = double(pattern: pattern)
        suite = Snapdragon::Suite.new(options, [])
        expect(suite).to receive(:pattern).and_return(pattern)
        suite.spec_files
      end

      it "returns the collection of spec files matching the pattern" do
        pattern = double
        options = double(pattern: pattern)
        allow(Dir).to receive(:[]).and_return(['path_c_str'])
        suite = Snapdragon::Suite.new(options, [])
        spec_file_c = double('spec_file_c')
        allow(Snapdragon::Path).to receive(:new).with('path_c_str').and_return(double(spec_files: [spec_file_c]))
        expect(suite.spec_files).to eq([spec_file_c])
      end
    end
  end

  describe "#require_paths" do
    it "returns the merged set of the require paths of each spec file" do
      pending
    end
  end

  describe "#require_files" do
    it "needs to be tested"
  end
end
