require_relative '../../../lib/snapdragon/suite'

describe Snapdragon::Suite do
  describe "#initialize" do
    it "constucts an instance of a Suite given an array of paths" do
      options = stub
      paths = [stub, stub, stub]
      Snapdragon::Suite.new(options, paths)
    end

    it "stores the paths in an instance variable" do
      options = stub
      paths = [stub, stub, stub]
      suite = Snapdragon::Suite.new(options, paths)
      suite.instance_variable_get(:@paths).should eq(paths)
    end

    it 'stores the options in an instance variable' do
      options = stub
      paths = [stub, stub, stub]
      suite = Snapdragon::Suite.new(options, paths)
      suite.instance_variable_get(:@options).should eq(options)
    end
  end

  describe "#formatter" do
    it "returns the configured formatter to use" do
      formatter = stub
      options = stub(format: formatter)
      suite = Snapdragon::Suite.new(options, stub)
      suite.formatter.should eq (formatter)
    end
  end

  describe "#use_color?" do
    it "returns the configured color setting" do
      color = stub
      options = stub(color: color)
      suite = Snapdragon::Suite.new(options, stub)
      suite.use_color?.should eq color
    end
  end

  describe "#pattern" do
    it "returns the configured pattern setting" do
      pattern = stub
      options = stub(pattern: pattern)
      suite = Snapdragon::Suite.new(options, stub)
      suite.pattern.should eq pattern
    end
  end
  
  describe "#spec_files" do
    context "when paths are provided" do
      it "does not read pattern from options" do
        pattern = stub
        options = stub(pattern: pattern)
        paths = ['path_a_str', 'path_b_str']
        suite = Snapdragon::Suite.new(options, paths)
        suite.should_not_receive(:pattern)
        suite.spec_files
      end
      
      it "creates a path object to represent the path" do
        options = stub
        paths = ['path_a_str', 'path_b_str']
        suite = Snapdragon::Suite.new(options, paths)
        Snapdragon::Path.should_receive(:new).with('path_a_str').and_return(stub(spec_files: []))
        Snapdragon::Path.should_receive(:new).with('path_b_str').and_return(stub(spec_files: []))
        suite.spec_files
      end

      it "returns the collection of the spec files of all of the paths" do
        options = stub
        paths = ['path_a_str', 'path_b_str']
        suite = Snapdragon::Suite.new(options, paths)
        spec_file_a = stub('spec_file_a'), spec_file_b = stub('spec_file_b')
        Snapdragon::Path.stub(:new).with('path_a_str').and_return(stub(spec_files: [spec_file_a]))
        Snapdragon::Path.stub(:new).with('path_b_str').and_return(stub(spec_files: [spec_file_b]))
        suite.spec_files.should eq([spec_file_a, spec_file_b])
      end
    end
    
    context "when paths are empty" do
      it "reads the pattern from the options" do
        pattern = stub
        options = stub(pattern: pattern)
        suite = Snapdragon::Suite.new(options, [])
        suite.should_receive(:pattern).and_return(pattern)
        suite.spec_files
      end
      
      it "returns the collection of spec files matching the pattern" do
        pattern = stub
        options = stub(pattern: pattern)
        Dir.stub!(:[]) { ['path_c_str'] }
        suite = Snapdragon::Suite.new(options, [])
        spec_file_c = stub('spec_file_c')
        Snapdragon::Path.stub(:new).with('path_c_str').and_return(stub(spec_files: [spec_file_c]))
        suite.spec_files.should eq([spec_file_c])
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
