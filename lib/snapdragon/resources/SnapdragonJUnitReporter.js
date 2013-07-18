/*
 * This is the junit reporter provided in the jasmine-reporters project
 * available at https://github.com/larrymyers/jasmine-reporters
 */
(function() {

  if (typeof jasmine == 'undefined') {
    throw new Error("jasmine library does not exist in global namespace!");
  }

  function elapsed(startTime, endTime) {
    return (endTime - startTime)/1000;
  }

  function ISODateString(d) {
    function pad(n) { return n < 10 ? '0'+n : n; }

    return d.getFullYear() + '-' +
      pad(d.getMonth()+1) + '-' +
      pad(d.getDate()) + 'T' +
      pad(d.getHours()) + ':' +
      pad(d.getMinutes()) + ':' +
      pad(d.getSeconds());
  }

  function trim(str) {
    return str.replace(/^\s+/, "" ).replace(/\s+$/, "" );
  }

  function escapeInvalidXmlChars(str) {
    return str.replace(/\&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/\>/g, "&gt;")
      .replace(/\"/g, "&quot;")
      .replace(/\'/g, "&apos;");
  }

  var JUnitXmlReporter = function() {
    this.useDotNotation = true;
  };

  JUnitXmlReporter.prototype = {
    reportSpecStarting: function(spec) {
      spec.startTime = new Date();

      if (!spec.suite.startTime) {
        spec.suite.startTime = spec.startTime;
      }
    },

    reportSpecResults: function(spec) {
      var results = spec.results();
      spec.didFail = !results.passed();
      spec.duration = elapsed(spec.startTime, new Date());
      spec.output = '<testcase classname="' + this.getFullName(spec.suite) +
        '" name="' + escapeInvalidXmlChars(spec.description) + '" time="' + spec.duration + '">';
      if(results.skipped) {
        spec.output = spec.output + "<skipped />";
      }

      var failure = "";
      var failures = 0;
      var resultItems = results.getItems();
      for (var i = 0; i < resultItems.length; i++) {
        var result = resultItems[i];

        if (result.type == 'expect' && result.passed && !result.passed()) {
          failures += 1;
          failure += '<failure type="' + result.type + '" message="' + trim(escapeInvalidXmlChars(result.message)) + '">';
          failure += escapeInvalidXmlChars(result.trace.stack || result.message);
          failure += "</failure>";
        }
      }
      if (failure) {
        spec.output += failure;
      }
      spec.output += "</testcase>";
    },

    reportSuiteResults: function(suite) {
      var results = suite.results();
      var specs = suite.specs();
      var specOutput = "";
      // for JUnit results, let's only include directly failed tests (not nested suites')
      var failedCount = 0;

      suite.status = results.passed() ? 'Passed.' : 'Failed.';
      if (results.totalCount === 0) { // todo: change this to check results.skipped
        suite.status = 'Skipped.';
      }

      // if a suite has no (active?) specs, reportSpecStarting is never called
      // and thus the suite has no startTime -- account for that here
      suite.startTime = suite.startTime || new Date();
      suite.duration = elapsed(suite.startTime, new Date());

      for (var i = 0; i < specs.length; i++) {
        failedCount += specs[i].didFail ? 1 : 0;
        specOutput += "\n  " + specs[i].output;
      }
      suite.output = '\n<testsuite name="' + this.getFullName(suite) +
        '" errors="0" tests="' + specs.length + '" failures="' + failedCount +
        '" time="' + suite.duration + '" timestamp="' + ISODateString(suite.startTime) + '">';
      suite.output += specOutput;
      suite.output += "\n</testsuite>";
    },

    reportRunnerResults: function(runner) {
      var suites = runner.suites();
      for (var i = 0; i < suites.length; i++) {
        var suite = suites[i];
        var output = '<?xml version="1.0" encoding="UTF-8" ?>';
        // if we are consolidating, only write out top-level suites
        if (suite.parentSuite) {
          continue;
        }
        else {
          output += "\n<testsuites>";
          output += this.getNestedOutput(suite);
          output += "\n</testsuites>";
          this.print(output);
        }
      }
      this.signalCapybaraTestsFinishedRunning();
    },

    signalCapybaraTestsFinishedRunning:  function() {
      var div = document.createElement('div');
      div.id = 'testscomplete';
      document.body.appendChild(div);
    },

    getNestedOutput: function(suite) {
      var output = suite.output;
      for (var i = 0; i < suite.suites().length; i++) {
        output += this.getNestedOutput(suite.suites()[i]);
      }
      return output;
    },

    getFullName: function(suite, isFilename) {
      var fullName;
      if (this.useDotNotation) {
        fullName = suite.description;
        for (var parentSuite = suite.parentSuite; parentSuite; parentSuite = parentSuite.parentSuite) {
          fullName = parentSuite.description + '.' + fullName;
        }
      }
      else {
        fullName = suite.getFullName();
      }

      // Either remove or escape invalid XML characters
      if (isFilename) {
        return fullName.replace(/[^\w]/g, "");
      }
      return escapeInvalidXmlChars(fullName);
    },

    print: function(str) {
      var console = jasmine.getGlobal().console;

      if (console && console.log) {
        console.log(str);
      }
    }
  };

  // export public
  jasmine.SnapdragonJUnitReporter = JUnitXmlReporter;
})();
