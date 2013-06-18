getJasmineRequireObj().ConsoleReporter = function() {
  function ConsoleReporter(options) {
    var print = function(msg) { console.log(msg); },
      showColors = options.showColors || true,
      onComplete = options.onComplete || function() {},
      specCount,
      failureCount,
      passedCount,
      failedSpecs = [],
      pendingSpecs = [],
      pendingCount,
      ansi = {
        green: '\033[32m',
        red: '\033[31m',
        yellow: '\033[33m',
        none: '\033[0m'
      };

    this.jasmineStarted = function() {
      specCount = 0;
      failureCount = 0;
      passedCount = 0;
      pendingCount = 0;
      print("Running examples...");
      printNewline();
    };

    this.jasmineDone = function(options) {
      if (pendingCount > 0) {
        print("Pending:");
      }

      for (var i = 0; i < pendingSpecs.length; i++) {
        specPendingDetails(pendingSpecs[i]);
      }

      if (failureCount > 0) {
        print("Failures:");
        printNewline();
      }

      for (var i = 0; i < failedSpecs.length; i++) {
        specFailureDetails(failedSpecs[i], i + 1);
      }

      var specCounts = specCount + " " + plural("example", specCount) + ", " + failureCount + " " + plural("failure", failureCount);

      if (pendingCount) {
        specCounts += ", " + pendingCount + " pending";
      }
      
      var seconds = options.executionTime / 1000;
      print("Finished in " + seconds + " " + plural("second", seconds));

      if (failureCount > 0) { // have any failures
        print(colored("red", specCounts));
      } else if (pendingCount > 0) {
        print(colored("yellow", specCounts));
      } else {
        print(colored("green", specCounts));
      }

      onComplete();
    };

    this.specDone = function(result) {
      if (result.status !== "disabled") {
        specCount++;
      }

      if (result.status == "pending") {
        pendingCount++;
        pendingSpecs.push(result);
        return;
      }

      if (result.status == "passed") {
        passedCount++;
        return;
      }

      if (result.status == "failed") {
        failureCount++;
        failedSpecs.push(result);
        return;
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

    function specFailureDetails(result, failure_number) {
      print(indent(failure_number + ") " + result.fullName, 2));

      for (var i = 0; i < result.failedExpectations.length; i++) {
        var failedExpectation = result.failedExpectations[i];
        print(colored("red", indent(failedExpectation.message, 6)));
      }
      printNewline();
    }

    function specPendingDetails(result) {
      print(indent(colored("yellow", result.fullName), 2));
      printNewline();
    }
  }

  return ConsoleReporter;
};
