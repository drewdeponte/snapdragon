function getJasmineRequireObj() {
  if (typeof module !== "undefined" && module.exports) {
    return exports;
  } else {
    window.jasmineRequire = window.jasmineRequire || {};
    return window.jasmineRequire;
  }
}

getJasmineRequireObj().console = function(jRequire, j$) {
  j$.SnapdragonJUnitReporter = jRequire.SnapdragonJUnitReporter();
};

getJasmineRequireObj().SnapdragonJUnitReporter = function() {

  var noopTimer = {
    start: function(){},
    elapsed: function(){ return 0; }
  };

  return function(options) {
    var print = options.print || function(msg) {console.log(msg);},
      onComplete = options.onComplete || function() {},
      timer = options.timer || new jasmine.Timer() || noopTimer,
      suites = {},
      specs = [],
      specStartTime;

    this.jasmineStarted = function() {
      timer.start();
    };

    this.jasmineDone = function() {
      outputToXml();
      signalCapybaraTestsFinishedRunning();
    };

    this.suiteStarted = function(result) {
      specs = [];
      suites[result.id] = {suite: result, timestamp: new Date(), duration: 0, specs: specs};

    };

    this.suiteDone = function(result) {
      suites[result.id].duration = (new Date() - suites[result.id].timestamp) / 1000;
    };

    this.specStarted = function(result) {
      specStartTime = new Date();
    };

    this.specDone = function(result) {
      var elapsedTime = (new Date() - specStartTime) / 1000;
      specs.push({spec: result, duration: elapsedTime});
    };

    return this;

    function outputToXml() {
      var output = [];

      output.push("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
      output.push("<testsuites>");

      for (var suiteId in suites) {
        output.push(getOutputForEachSuite(suites[suiteId]));
      }

      output.push("</testsuites>");

      print(output.join(getNewLine()));
    }

    function getOutputForEachSuite(data) {
      var suite = data.suite,
          specs = data.specs,
          failedSpecsCount = 0,
          newLineChar = "",
          output = [];

      if (specs.length > 0) {
        failedSpecsCount = getFailedSpecsCount(specs);
        newLineChar = getNewLine();

        for (var i = 0, length = specs.length; i < length; i++) {
          output.push(getOutputForEachSpec(specs[i]));
        }
      }

      output.unshift(["<testsuite name=\"", escapeInvalidXmlChars(suite.fullName), "\" errors=\"0\" tests=\"", specs.length, "\" failures=\"", failedSpecsCount, "\" time=\"", data.duration, "\" timestamp=\"", dateToISOString(data.timestamp), "\">"].join(""));
      output.push("</testsuite>");

      return output.join(newLineChar);
    }

    function getOutputForEachSpec(data) {
      var spec = data.spec,
          newLineChar = "",
          output = [];

      if (spec.status === "pending") {
        output.push("<skipped />");
        newLineChar = getNewLine();
      } else if (spec.status === "failed") {
        var failures = spec.failedExpectations;

        for (var i = 0, length = failures.length; i < length; i++) {
          var failure = failures[i];

          output.push(["<failure type=\"expect\" message=\"", escapeInvalidXmlChars(failure.message), "\">"].join(""));
          output.push(escapeInvalidXmlChars(trimStackTrace(failure.stack)));
          output.push("</failure>");
        }

        newLineChar = getNewLine();
      }

      output.unshift(["<testcase classname=\"", escapeInvalidXmlChars(spec.fullName), "\" name=\"", escapeInvalidXmlChars(spec.description), "\" time=\"", data.duration, "\">"].join(""));
      output.push("</testcase>");

      return output.join(newLineChar);
    }

    function getNewLine() {
      return "\n";
    }

    function getFailedSpecsCount(specs) {
      var counter = 0;

      for (var i = 0, length = specs.length; i < length; i++) {
        if (specs[i].spec.status === "failed") {
          counter++;
        }
      }

      return counter;
    }

    function dateToISOString(d) {
      function pad(n) {return n < 10 ? "0"+n : n;}

      return d.getFullYear() + "-" +
        pad(d.getMonth()+1) + "-" +
        pad(d.getDate()) + "T" +
        pad(d.getHours()) + ":" +
        pad(d.getMinutes()) + ":" +
        pad(d.getSeconds());
    }

    function escapeInvalidXmlChars(str) {
      return str.replace(/\&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/\>/g, "&gt;")
        .replace(/\"/g, "&quot;")
        .replace(/\"/g, "&apos;");
    }

    function trimStackTrace(stackTraceString) {
      return stackTraceString.replace(/\s*at\s(?:\w+\s)?\(?http:\/\/127.0.0.1:\d+\/jasmine\/(?:jasmine|boot)\.js:\d+\)?/g, "");
    }

    function signalCapybaraTestsFinishedRunning() {
      var div = document.createElement('div');
      div.id = 'testscomplete';
      document.body.appendChild(div);
    }
  }
};
