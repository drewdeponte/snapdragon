require_relative '../../../lib/snapdragon/cli_application'

describe Snapdragon::CliApplication do
  describe "#initialize" do
    it "stores a copy of the given command line arguments" do
      cmd_line_args = stub('command_line_args')
      cli_app = Snapdragon::CliApplication.new(cmd_line_args)
      cli_app.instance_variable_get(:@args).should eq(cmd_line_args)
    end

    it "creates an empty Suite" do
      Snapdragon::Suite.should_receive(:new)
      Snapdragon::CliApplication.new(stub)
    end

    it "assigns the new Suite to an instance variable" do
      suite = stub('suite')
      Snapdragon::Suite.stub(:new).and_return(suite)
      app = Snapdragon::CliApplication.new(stub)
      app.instance_variable_get(:@suite).should eq(suite)
    end
  end

  describe "#run" do
    it "parses the given command line arguements" do
      arguements = stub
      app = Snapdragon::CliApplication.new(arguements)
      app.should_receive(:parse_arguements).with(arguements)
      app.stub(:run_suite)
      app.run
    end

    it "runs the Jasmine suite" do
      app = Snapdragon::CliApplication.new(['/some/path/to_some_spec.js'])
      app.stub(:parse_arguements)
      app.should_receive(:run_suite)
      app.run
    end
  end

  describe "#parse_arguements" do
    let(:arguements) { ['some/path/to/some_spec.js:23', 'some/path/to/some_other_spec.js'] }
    subject { Snapdragon::CliApplication.new(arguements) }

    it "iterates over each of the arguments parsing each one" do
      subject.should_receive(:parse_arguement).with('some/path/to/some_spec.js:23')
      subject.should_receive(:parse_arguement).with('some/path/to/some_other_spec.js')
      subject.send(:parse_arguements, arguements)
    end
  end

  describe "#parse_arguement" do
    subject { Snapdragon::CliApplication.new(stub) }

    context "when the arg represents a file + line number" do
      before do
        subject.stub(:is_a_file_path_and_line_number?).and_return(true)
      end

      it "creates a SpecFile with the specified path and line number" do
        Snapdragon::SpecFile.should_receive(:new).with('some/path/to/some_spec.js', 45).and_return(stub.as_null_object)
        subject.send(:parse_arguement, 'some/path/to/some_spec.js:45')
      end

      it "appends the created SpecFile to the applications Suite" do
        spec_file = stub('spec_file')
        suite = mock('suite')
        subject.instance_variable_set(:@suite, suite)
        Snapdragon::SpecFile.stub(:new).and_return(spec_file)
        suite.should_receive(:add_spec_file).with(spec_file)
        subject.send(:parse_arguement, 'some/path/to/some_spec.js:45')
      end
    end

    context "when the arg represents a file without a line number" do
      before do
        subject.stub(:is_a_file_path_and_line_number?).and_return(false)
        subject.stub(:is_a_file_path?).and_return(true)
      end

      it "creates a SpecFile object with the specified path" do
        Snapdragon::SpecFile.should_receive(:new).with('some/path/to/some_spec.js').and_return(stub.as_null_object)
        subject.send(:parse_arguement, 'some/path/to/some_spec.js')
      end

      it "appends the created SpecFile to the application Suite" do
        spec_file = stub('spec_file')
        suite = mock('suite')
        subject.instance_variable_set(:@suite, suite)
        Snapdragon::SpecFile.stub(:new).and_return(spec_file)
        suite.should_receive(:add_spec_file).with(spec_file)
        subject.send(:parse_arguement, 'some/path/to/some_spec.js')
      end
    end

    context "when the arg respesents a directory" do
      before do
        subject.stub(:is_a_file_path_and_line_number?).and_return(false)
        subject.stub(:is_a_file_path?).and_return(false)
        subject.stub(:is_a_directory?).and_return(true)
      end

      it "creates a SpecDirectory with the given directory path" do
        Snapdragon::SpecDirectory.should_receive(:new).with('some/path/to/some_directory').and_return(stub(:spec_files => []))
        subject.send(:parse_arguement, 'some/path/to/some_directory')
      end

      it "gets all of the SpecFiles recursively identified in the SpecDirectory path" do
        spec_dir = mock
        Snapdragon::SpecDirectory.stub(:new).and_return(spec_dir)
        spec_dir.should_receive(:spec_files).and_return([])
        subject.send(:parse_arguement, 'some/path/to/some_directory')
      end

      it "appends the SpecFiles to the application Suite" do
        spec_dir = stub('spec_dir')
        spec_files = stub('spec_files')
        suite = mock('suite')
        subject.instance_variable_set(:@suite, suite)
        Snapdragon::SpecDirectory.stub(:new).and_return(spec_dir)
        spec_dir.stub(:spec_files).and_return(spec_files)
        suite.should_receive(:add_spec_files).with(spec_files)
        subject.send(:parse_arguement, 'some/path/to/some_directory')
      end
    end
  end

  describe "#is_a_file_path_and_line_number?" do
    let(:arguements) { stub('arguments') }
    subject { Snapdragon::CliApplication.new(arguements) }

    context "when it matches the pattern of a file path and line number" do
      it "returns true" do
        subject.send(:is_a_file_path_and_line_number?, 'some/path/to/some_spec.js:534').should be_true
      end
    end
    
    context "when it does NOT match the pattern of a file path and line number" do
      it "returns false" do
        subject.send(:is_a_file_path_and_line_number?, 'some/path/to/some_spec.js').should be_false
      end
    end
  end

  describe "#is_a_file_path?" do
    let(:arguements) { stub('arguments') }
    subject { Snapdragon::CliApplication.new(arguements) }

    context "when it matches the pattern of a file path" do
      it "returns true" do
        subject.send(:is_a_file_path?, 'some/path/to/some_spec.js').should be_true
      end
    end

    context "when it does NOT match the pattern of a file path" do
      it "returns false" do
        subject.send(:is_a_file_path?, 'some/path/to/some.js').should be_false
      end
    end
  end

  describe "#is_a_directory?" do
    let(:arguements) { stub('arguments') }
    subject { Snapdragon::CliApplication.new(arguements) }

    context "when it matches the pattern of a directory path" do
      it "returns true" do
        subject.send(:is_a_directory?, 'some/path/to/some_directory').should be_true
      end
    end

    context "when it does NOT match the pattern of a directory path" do
      it "returns false" do
        subject.send(:is_a_directory?, 'some/path/to/some_spec.js').should be_false
      end
    end
  end

  describe "#run_suite" do
    let(:arguements) { stub('arguments') }
    subject { Snapdragon::CliApplication.new(arguements) }

    it "creates a capybara session" do
      Capybara::Session.should_receive(:new).and_return(stub.as_null_object)
      subject.send(:run_suite)
    end

    context "when suite is filtered" do
      before do
        subject.instance_variable_set(:@suite, stub(:filtered? => true, :spec_query_param => 'some_query_param_spec_filter'))
      end

      it "visits /run with the spec query param in the capybara session" do
        session = mock
        Capybara::Session.stub(:new).and_return(session)
        session.should_receive(:visit).with("/run?spec=some_query_param_spec_filter")
        subject.send(:run_suite)
      end
    end

    context "when suite is NOT filtered" do
      before do
        subject.instance_variable_set(:@suite, stub(:filtered? => false))
      end

      it "visits /run in that capybara session" do
        session = mock
        Capybara::Session.stub(:new).and_return(session)
        session.should_receive(:visit).with('/run')
        subject.send(:run_suite)
      end
    end
  end
end
