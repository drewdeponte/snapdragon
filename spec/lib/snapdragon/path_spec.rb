require_relative '../../../lib/snapdragon/path'

describe Snapdragon::Path do
  describe "#initialize" do
    it "stores the raw path in an instance variable" do
      path = Snapdragon::Path.new('some/path:423')
      path.instance_variable_get(:@raw_path).should eq('some/path:423')
    end

    context "when given a path and line number" do
      it "stores the path in an instance variable" do
        path = Snapdragon::Path.new('some/path:423')
        path.instance_variable_get(:@path).should eq('some/path')
      end

      it "stores the line number in an instance variable" do
        path = Snapdragon::Path.new('some/path:423')
        path.instance_variable_get(:@line_number).should eq(423)
      end
    end

    context "when given a path" do
      it "stores teh path in an instance variable" do
        path = Snapdragon::Path.new('some/path')
        path.instance_variable_get(:@path).should eq('some/path')
      end
    end
  end

  describe "#spec_files" do
    let(:path) { Snapdragon::Path.new('some/path') }

    context "when does NOT exist" do
      before do
        path.stub(:exists?).and_return(false)
      end

      it "returns an empty array" do
        path.spec_files.should eq([])
      end
    end

    context "when does exist" do
      before do
        path.stub(:exists?).and_return(true)
      end

      context "when is a directory" do
        before do
          path.stub(:is_a_directory?).and_return(true)
        end

        it "constructs a spec directory" do
          Snapdragon::SpecDirectory.should_receive(:new).and_return(stub.as_null_object)
          path.spec_files
        end

        it "returns the spec files recursively found in the spec directory" do
          spec_files = stub
          spec_dir = stub(spec_files: spec_files)
          Snapdragon::SpecDirectory.should_receive(:new).and_return(spec_dir)
          path.spec_files.should eq(spec_files)
        end
      end

      context "when is NOT a directory" do
        before do
          path.stub(:is_a_directory?).and_return(false)
        end

        it "constructs a spec file" do
          Snapdragon::SpecFile.should_receive(:new)
          path.spec_files
        end

        it "returns an array containing a newly constructed spec file" do
          spec_file = stub
          Snapdragon::SpecFile.stub(:new).and_return(spec_file)
          path.spec_files.should eq([spec_file])
        end
      end
    end
  end

  describe "#has_line_number?" do
    context "when the given raw path has a line number" do
      it "returns true" do
        path = Snapdragon::Path.new('some/path:234')
        path.has_line_number?.should be_true
      end
    end

    context "when the given raw path does NOT have a line number" do
      it "returns false" do
        path = Snapdragon::Path.new('some/path')
        path.has_line_number?.should be_false
      end
    end
  end
end
