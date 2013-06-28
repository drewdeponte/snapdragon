# ChangeLog

The following are lists of the notable changes included with each release.
This is inteded to help keep people informed about notable changes between
versions as well as provide a rough history.

#### Next Release

#### v0.1.8

* removed debug puts statements that were left in
* added the Jasmine license info to LICENSE since we package Jasmine

#### v0.1.7

* made require_relative directives work inside of required files
  ([\#15](http://github.com/reachlocal/snapdragon/issues/15))

#### v0.1.6

* snapdragon_server when given `some/spec.js:344` now opens the browser to the
  correctly filtered URL
  ([\#3](http://github.com/reachlocal/snapdragon/issues/3))
* snapdragon_server now finds new files/specs on browser refresh
  ([\#1](http://github.com/reachlocal/snapdragon/issues/1))
* Stack traces are now exclude jasmine.js lines
  ([\#10](http://github.com/reachlocal/snapdragon/issues/10))
* Added stack traces to the output of failed expectations
  ([\#14](http://github.com/reachlocal/snapdragon/issues/14))
* Moved from inline code loading to external script tag sources
  ([\#13](http://github.com/reachlocal/snapdragon/issues/13))

#### v0.1.5

* Jasmine runner now hosts files in CWD under `/:path`
  ([\#12](http://github.com/reachlocal/snapdragon/issues/12))

#### v0.1.4

* Resolved some path expansion issues

#### v0.1.3

* Made Capybara wait for test output to finish before killing session

#### v0.1.2

* Reworked styled and colored output to work with Jasmine v1.3.1
* Switch to include latest stable Jasmine v1.3.1

#### v0.1.1

* Added jasmine-core to gemspec to resolve epic failure when running
  `snapdragon` or `snapdragon_server`

#### v0.1.0

* Provided initial README.md for documentation
  ([\#2](http://github.com/reachlocal/snapdragon/issues/2))
* Added styled and colored output matching RSpec style output.
* Added latest master branch of Jasmine as the included test framework
* Added support for spec.js file arguements to `snapdragon` &
  `snapdragon_server`
* Added support for spec directory arguements to `snapdragon` &
  `snapdragon_server`
* Added support for spec.js:line_number arguements to `snapdragon` &
  `snapdragon_server`
* Added `// require_relative()` directive to load required dependencies
* Added the basic `snapdragon` command line tool
* Added the basic `snapdragon_server` command line tool

