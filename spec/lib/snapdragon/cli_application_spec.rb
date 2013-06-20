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
    let(:arguements) { stub('arguments') }
    subject { Snapdragon::CliApplication.new(arguements) }

    it "creates a capybara session" do
      suite = stub(filtered?: false)
      Snapdragon::Suite.stub(:new).and_return(suite)
      Capybara::Session.should_receive(:new).and_return(stub.as_null_object)
      subject.run
    end

    context "when suite is filtered" do
      before do
        subject.instance_variable_set(:@suite, stub(:filtered? => true, :spec_query_param => 'some_query_param_spec_filter'))
      end

      it "visits /run with the spec query param in the capybara session" do
        session = mock(find: nil)
        Capybara::Session.stub(:new).and_return(session)
        session.should_receive(:visit).with("/run?spec=some_query_param_spec_filter")
        subject.run
      end
    end

    context "when suite is NOT filtered" do
      before do
        subject.instance_variable_set(:@suite, stub(:filtered? => false))
      end

      it "visits /run in that capybara session" do
        session = mock(find: nil)
        Capybara::Session.stub(:new).and_return(session)
        session.should_receive(:visit).with('/run')
        subject.run
      end
    end
  end
end
