require 'spec_helper'
require_relative '../../../lib/snapdragon/cli_application'

describe Snapdragon::CliApplication do
  describe "#initialize" do
    let(:options) { double(driver: {}) }
    it "creates an empty Suite" do
      expect(Snapdragon::Suite).to receive(:new)
      Snapdragon::CliApplication.new(options, double)
    end

    it "assigns the new Suite to an instance variable" do
      suite = double('suite')
      allow(Snapdragon::Suite).to receive(:new).and_return(suite)
      app = Snapdragon::CliApplication.new(options, double)
      expect(app.instance_variable_get(:@suite)).to be(suite)
    end

    it "registers the driver" do
      driver_options = double
      options = double(driver: driver_options)
      expect_any_instance_of(Snapdragon::CliApplication).to receive(:register_driver).with(driver_options)
      Snapdragon::CliApplication.new(options, double)
    end
  end

  describe "#register_driver" do
    let(:paths) { double('paths') }
    let(:driver_options) { double('driver_options') }
    let(:options) { double(driver: driver_options) }
    subject { Snapdragon::CliApplication.new(options, paths) }

    it "registers a poltergeist driver" do
      expect(Capybara).to receive(:register_driver).twice
      subject.register_driver(double)
    end
    
    it "creates a new driver with the passed options" do
      app = double('app')
      options = double('options')
      allow(Capybara).to receive(:register_driver).and_yield(app)
      expect(Capybara::Poltergeist::Driver).to receive(:new).twice.with(app, driver_options)
      subject.register_driver(driver_options)
    end
  end

  describe "#run" do
    let(:paths) { double('paths') }
    let(:options) { double('options').as_null_object }
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
