require 'spec_helper'
require_relative '../../../lib/snapdragon/command_line_parser'

describe Snapdragon::CommandLineParser do
  describe "#parse" do
    subject { Snapdragon::CommandLineParser }

    it "display version information" do
      output = capture_stdout { subject.parse(["-v"]) }
      expect(output).to match(/\d+\.\d+\.\d+/)
    end

    it "exit once version information is displayed" do
      expect { hide_stdout { subject.parse(["-v"]) } }.to raise_error(SystemExit)
    end

    it "display usage information" do
      output = capture_stdout { subject.parse(["-h"]) }
      expect(output).to match(/Usage/)
    end

    it "exit once usage information is displayed" do
      expect { hide_stdout { subject.parse(["-h"]) } }.to raise_error(SystemExit)
    end

    context "no args supplied" do
      it "exit" do
        expect { hide_stdout { subject.parse([]) } }.not_to raise_error()
      end
    end

    context "args supplied" do
      it "continue execution" do
        expect { subject.parse(["spec/hello_spec.rb"]) }.not_to raise_error()
      end
    end

    context "when format is provided" do
      it "sets the format value" do
        expect(subject.parse(["--format", "junit", "spec/hello_spec.rb"]).format).to eq "junit"
      end
    end

    context "when format is not provided" do
      it "defaults to console" do
        expect(subject.parse(["spec/hello_spec.rb"]).format).to eq "console"
      end
    end

    context "when color option is not provided" do
      it "defaults to true" do
        expect(subject.parse(["spec/hello_spec.rb"]).color).to eq true
      end
    end

    context "when no-color option is provided" do
      it "sets the color option" do
        expect(subject.parse(["-N", "spec/hello_spec.rb"]).color).to eq false
      end

      it "sets the color option" do
        expect(subject.parse(["--nocolor", "spec/hello_spec.rb"]).color).to eq false
      end

      it "sets the color option" do
        expect(subject.parse(["--nocolour", "spec/hello_spec.rb"]).color).to eq false
      end
    end

    context "when pattern is provided" do
      it "sets the pattern value" do
        expect(subject.parse(["--pattern", "spec/*/*_test.js"]).pattern).to eq "spec/*/*_test.js"
      end
    end

    context "when pattern is not provided" do
      it "defaults to 'spec/**/*_spec.js'" do
        expect(subject.parse([]).pattern).to eq "spec/**/*_spec.js"
      end
    end

    context "when Jasmine version is not provided" do
      it "defaults to '2'" do
        expect(subject.parse([]).jasmine_ver).to eq '2'
      end
    end

    context "when Jasmine version is provided" do
      it "defaults to '1'" do
        expect(subject.parse(['-J1', 'spec/hello_spec.rb']).jasmine_ver).to eq '1'
      end

      it "defaults to '1'" do
        expect(subject.parse(['--jasminev1', 'spec/hello_spec.rb']).jasmine_ver).to eq '1'
      end
    end
    
    context "when debug is provided" do
      it "sets the phantom debug flag to true" do
        expect(subject.parse(['-d', 'spec/hello_spec.rb']).phantom).to eq({debug: true})
      end

      it "sets the phantom debug flag to true" do
        expect(subject.parse(['--debug', 'spec/hello_spec.rb']).phantom).to eq({debug: true})
      end
    end

    context "when debug is not provided" do
      it "sets the phantom config to an empty hash" do
        expect(subject.parse([]).phantom).to eq({}) 
      end
    end
  end
end
