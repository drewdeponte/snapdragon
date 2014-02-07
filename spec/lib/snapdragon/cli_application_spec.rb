require 'spec_helper'
require_relative '../../../lib/snapdragon/cli_application'

describe Snapdragon::CliApplication do
  describe "#initialize" do
    it "creates an empty Suite" do
      expect(Snapdragon::Suite).to receive(:new)
      Snapdragon::CliApplication.new(double, double)
    end

    it "assigns the new Suite to an instance variable" do
      suite = double('suite')
      allow(Snapdragon::Suite).to receive(:new).and_return(suite)
      app = Snapdragon::CliApplication.new(double, double)
      expect(app.instance_variable_get(:@suite)).to be(suite)
    end
  end

  describe "#run" do
    let(:paths) { double('paths') }
    let(:options) { double('options') }
    subject { Snapdragon::CliApplication.new(options, paths) }

    it "creates a capybara session" do
      suite = double(filtered?: false)
      allow(Snapdragon::Suite).to receive(:new).and_return(suite)
      expect(Capybara::Session).to receive(:new).and_return(double.as_null_object)
      subject.run
    end

    context "when suite is filtered" do
      before do
        subject.instance_variable_set(:@suite, double(:filtered? => true, :spec_query_param => 'some_query_param_spec_filter'))
      end

      it "visits /run with the spec query param in the capybara session" do
        session = double(find: nil)
        allow(Capybara::Session).to receive(:new).and_return(session)
        expect(session).to receive(:visit).with("/run?spec=some_query_param_spec_filter")
        subject.run
      end
    end

    context "when suite is NOT filtered" do
      before do
        subject.instance_variable_set(:@suite, double(:filtered? => false))
      end

      it "visits /run in that capybara session" do
        session = double(find: nil)
        allow(Capybara::Session).to receive(:new).and_return(session)
        expect(session).to receive(:visit).with('/run')
        subject.run
      end
    end
  end
end
