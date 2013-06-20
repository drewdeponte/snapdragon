jasmine.SnapdragonConsoleReporter = function(options) {
  var print = function(msg) { console.log(msg); },
    showColors = options.showColors || true,
    onComplete = options.onComplete || function() {},
    specCount,
    failureCount,
    passedCount,
    failedSpecs = [],
    pendingSpecs = [],
    pendingCount,
    startTimestamp,
    endTimestamp
    ansi = {
      green: '\033[32m',
      red: '\033[31m',
      yellow: '\033[33m',
      none: '\033[0m'
    };

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

  function specFailureDetails(spec, failure_number) {
    print(indent(failure_number + ") " + spec.getFullName(), 2));

    var resultItems = spec.results().getItems();
    for (var i = 0; i < resultItems.length; i++) {
      var result = resultItems[i];
      if (result.trace.stack) {
        print(indent(colored("red", trimStackTrace(result.trace.stack)), 6));
      } else {
        print(indent(colored("red", result.message), 6));
      }
    }
    printNewline();
  }

  function specPendingDetails(spec) {
    print(indent(colored("yellow", spec.getFullName()), 2));
    printNewline();
  }

  function signalCapybaraTestsFinishedRunning() {
    var div = document.createElement('div');
    div.id = 'testscomplete';
    document.body.appendChild(div);
  }

  function trimStackTrace(stackTraceString) {
    return stackTraceString.replace(/\s*at\s*http:\/\/127.0.0.1:\d+\/jasmine-core\/jasmine\.js:\d+\s*/g, "");
  }

  // Jasmine Hooks

  this.log = function() {
  };

  this.reportRunnerStarting = function() {
    startTimestamp = new Date().getTime();
    specCount = 0;
    failureCount = 0;
    passedCount = 0;
    pendingCount = 0;
    print("Running examples...");
    printNewline();
  };

  this.reportSuiteResults = function(suite) {
  };

  this.reportSpecStarting = function() {
  };

  this.reportSpecResults = function(spec) {
    var results = spec.results();

    if (!results.skipped) { // not pending
      specCount++;
    }

    if (results.skipped) { // when you filter out tests with spec query param
      pendingCount++;
      pendingSpecs.push(spec);
    } else if (results.passed()) { // passed
      passedCount++;
    } else { // failed
      failureCount++;
      failedSpecs.push(spec);
    }
  };

  this.reportRunnerResults = function(options) {
    endTimestamp = new Date().getTime();

    // I have commented out the pending section below because v1.3.1 of
    // jasmine doesn't have a concept of pending. It has a concept of
    // skipped when you filter tests using the spec query param.

    // if (pendingCount > 0) {
    //   print("Pending:");
    // }

    // for (var i = 0; i < pendingSpecs.length; i++) {
    //   specPendingDetails(pendingSpecs[i]);
    // }

    if (failureCount > 0) {
      print("Failures:");
      printNewline();
    }

    for (var i = 0; i < failedSpecs.length; i++) {
      specFailureDetails(failedSpecs[i], i + 1);
    }

    var specCounts = specCount + " " + plural("example", specCount) + ", " + failureCount + " " + plural("failure", failureCount);

    if (pendingCount) {
      specCounts += ", " + pendingCount + " skipped";
    }
    
    var seconds = (endTimestamp - startTimestamp) / 1000.0;
    print("Finished in " + seconds + " " + plural("second", seconds));

    if (failureCount > 0) { // have any failures
      print(colored("red", specCounts));
    // } else if (pendingCount > 0) {
    //   print(colored("yellow", specCounts));
    } else {
      print(colored("green", specCounts));
    }

    onComplete();
    signalCapybaraTestsFinishedRunning();
  };
};
