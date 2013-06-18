require_relative '../../../lib/snapdragon/suite'

describe Snapdragon::Suite do
  describe "#initialize" do
    it "assigns an empty array to hold all the spec files" do
      suite = Snapdragon::Suite.new
      suite.instance_variable_get(:@specs).should eq([])
    end

    it "assigns an empty set to hold all the require files" do
      suite = Snapdragon::Suite.new
      suite.instance_variable_get(:@require_paths).should be_kind_of(Set)
    end

    it "assigns @filtered to an initial state of false" do
      suite = Snapdragon::Suite.new
      suite.instance_variable_get(:@filtered).should be_false
    end

    it "assigns @spec_query_param to an initial state of empty string" do
      suite = Snapdragon::Suite.new
      suite.instance_variable_get(:@spec_query_param).should eq('')
    end
  end

  describe "#spec_files" do
    it "returns the array of specs which the suite contains" do
      spec_file = stub(:require_paths => [])
      subject.instance_variable_set(:@specs, [spec_file])
      subject.spec_files.should eq([spec_file])
    end
  end

  describe "#add_spec_file" do
    it "appends the given SpecFile to the suite of specs" do
      spec_file = stub(:require_paths => [], :filtered? => false)
      specs = mock
      subject.instance_variable_set(:@specs, specs)
      specs.should_receive(:<<).with(spec_file)
      subject.add_spec_file(spec_file)
    end

    it "gets the require paths outlined in the spec" do
      spec_file = mock(:filtered? => false)
      spec_file.should_receive(:require_paths).and_return([])
      subject.add_spec_file(spec_file)
    end

    it "contactinates the specs require paths to the suites require paths collection" do
      spec_file = stub(:filtered? => false)
      require_paths = stub
      suite_require_paths = mock
      subject.instance_variable_set(:@require_paths, suite_require_paths)
      spec_file.stub(:require_paths).and_return(require_paths)
      suite_require_paths.should_receive(:merge).with(require_paths)
      subject.add_spec_file(spec_file)
    end

    context "when spec is filtered" do
      it "assigns @filtered to true" do
        spec_file = stub(:require_paths => [], :filtered? => true, :spec_query_param => '')
        subject.add_spec_file(spec_file)
        subject.instance_variable_get(:@filtered).should be_true
      end

      it "assigns @spec_query_parm to the spec_files spec_query_parma" do
        spec_file = stub(:require_paths => [], :filtered? => true, :spec_query_param => 'some_spec_query_param')
        subject.add_spec_file(spec_file)
        subject.instance_variable_get(:@spec_query_param).should eq('some_spec_query_param')
      end
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

  describe "#spec_files" do
    it "returns the internal collection of spec files" do
      specs = stub
      subject.instance_variable_set(:@specs, specs)
      subject.spec_files.should eq(specs)
    end
  end

  describe "#output_spec_dependencies" do
    it "needs to be tested"
  end

  describe "#spec_query_param" do
    it "returns the suites spec_query_param" do
      spec_query_param = stub
      subject.instance_variable_set(:@spec_query_param, spec_query_param)
      subject.spec_query_param.should eq(spec_query_param)
    end
  end

  describe "#filtered?" do
    it "returns the filtered state of the suite" do
      filtered = stub
      subject.instance_variable_set(:@filtered, filtered)
      subject.filtered?.should eq(filtered)
    end
  end
end
