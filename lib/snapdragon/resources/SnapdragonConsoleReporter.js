function getJasmineRequireObj() {
  if (typeof module !== "undefined" && module.exports) {
    return exports;
  } else {
    window.jasmineRequire = window.jasmineRequire || {};
    return window.jasmineRequire;
  }
}

getJasmineRequireObj().console = function(jRequire, j$) {
  j$.SnapdragonConsoleReporter = jRequire.SnapdragonConsoleReporter();
};

getJasmineRequireObj().SnapdragonConsoleReporter = function() {

  var noopTimer = {
    start: function(){},
    elapsed: function(){ return 0; }
  };

  return function(options) {
    var print = options.print || function(msg) {console.log(msg);},
      showColors = options.showColors || false,
      onComplete = options.onComplete || function() {},
      timer = options.timer || new jasmine.Timer() || noopTimer,
      specCount,
      failureCount,
      failedSpecs = [],
      pendingCount,
      pendingSpecs = [],
      passedCount,
      specStatus = [],
      ansi = {
        green: '\x1B[32m',
        red: '\x1B[31m',
        yellow: '\x1B[33m',
        none: '\x1B[0m',
        red_bold: '\x1B[31;1m'
      };

    this.jasmineStarted = function() {
      specCount = 0;
      failureCount = 0;
      pendingCount = 0;
      passedCount = 0;
      print("Running specs...");
      printNewline();
      timer.start();
    };

    this.jasmineDone = function() {
      print(specStatus.join(""));

      if (failedSpecs.length > 0) {
        printNewline();
        for (var i = 0; i < failedSpecs.length; i++) {
          specFailureDetails(failedSpecs[i], i + 1);
        }
      }

      printNewline();
      var specCounts = specCount + " " + plural("spec", specCount) + ", " +
        failureCount + " " + plural("failure", failureCount);

      if (pendingCount) {
        specCounts += ", " + pendingCount + " pending " + plural("spec", pendingCount);
      }

      if (failureCount > 0) {
        print(colored("red", specCounts));
      } else if (pendingCount > 0) {
        print(colored("yellow", specCounts));
      } else {
        print(colored("green", specCounts));
      }

      var seconds = timer.elapsed() / 1000;
      print("Finished in " + seconds + " " + plural("second", seconds));

      printNewline();

      onComplete(failureCount === 0);

      signalCapybaraTestsFinishedRunning();
    };

    this.specDone = function(result) {
      specCount++;

      if (result.status == "pending") {
        pendingCount++;
        pendingSpecs.push(result);
        specStatus.push(colored("yellow", "*"));
        return;
      }

      if (result.status == "passed") {
        passedCount++;
        specStatus.push(colored("green", "."));
        return;
      }

      if (result.status == "failed") {
        failureCount++;
        failedSpecs.push(result);
        specStatus.push(colored("red", "F"));
      }
    };

    return this;

    function printNewline() {
      print("");
    }

    function colored(color, str) {
      return showColors ? (ansi[color] + str + ansi.none) : str;
    }

    function plural(str, count) {
      return count == 1 ? str : str + "s";
    }

    function repeat(thing, times) {
      var arr = [];
      for (var i = 0; i < times; i++) {
        arr.push(thing);
      }
      return arr;
    }

    function indent(str, spaces) {
      var lines = (str || '').split("\n");
      var newArr = [];
      for (var i = 0; i < lines.length; i++) {
        newArr.push(repeat(" ", spaces).join("") + lines[i]);
      }
      return newArr.join("\n");
    }

    function specFailureDetails(result, index) {
      printNewline();
      print(colored("red_bold", indent(index + ") " + result.fullName, 2)));

      for (var i = 0; i < result.failedExpectations.length; i++) {
        var failedExpectation = result.failedExpectations[i];
        print(indent(trimStackTrace(failedExpectation.stack), 6));
      }

      printNewline();
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
