# Snapdragon

**A command-line [Jasmine](http://pivotal.github.io/jasmine/) (JavaScript) test runner built with developer workflow in mind.**

## Installation

Add this line to your application's Gemfile:

    gem 'snapdragon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snapdragon

## Install PhantomJS

You need at least [PhantomJS](http://phantomjs.org) 1.8.1. There are no other
external dependencies (you don't need Qt, or a running X server, etc.)

### Mac OS X

I recommend installing [PhantomJS](http://phantomjs.org/) using
[Homebrew](http://mxcl.github.io/homebrew/) on Mac OS X. Using
[Homebrew](http://mxcl.github.io/homebrew/) it can be installed as easily as
running the following command:

    $ brew install phantomjs

## Quick Start Guide

If you are a visual learner Brian Miller and I have put together a Free
[Snapdragon](http://github.com/reachlocal/snapdragon) Screencast at [The Code
Breakdown](http://codebreakdown.com) ([direct
download](http://codebreakdown.com/screencasts/7/download)).

[![It in Action](http://media.codebreakdown.com/thumbnails/tcb-0007-thumbnail-400x225.png)](http://codebreakdown.com)

For those of you that like to jump right in and start playing with new tools
follow the steps below to get started.

1. Install [Snapdragon](http://github.com/reachlocal/snapdragon) and
   [PhantomJS](http://phantomjs.org/) as outlined above.

2. Create a simple [Jasmine](http://pivotal.github.io/jasmine/) spec file
   `example/spec/hoopty_spec.js` with the following content. Note: the
   `// require_relative()` directive at the top of the file. This tells
   [Snapdragon](http://github.com/reachlocal/snapdragon) what
   implementation file(s) it needs to run the specs in this file.

    ```javascript
    // require_relative('../src/hoopty.js')

    describe("Hoopty", function() {
      describe(".hello", function() {
        it("says hello there", function() {
          var f = new Hoopty();
          expect(f.hello()).toBe("Hello There");
        });
      });
    });
    ```

3. Create the implementation file for the spec file `example/src/hoopty.js`
   with the following content.

    ```javascript
    var Hoopty = function() {
      this.hello = function() {
        return "Hello There";
      }
    };
    ```

4. Run your spec file with the following command:

    ```text
    $ snapdragon example/spec/hoopty_spec.js
    ```

    You should see output that looks similar to the following.

    ```text
    Running examples...

    Finished in 0.001 seconds
    1 example, 0 failures
    ```

Thats it, you now have [Snapdragon](http://github.com/reachlocal/snapdragon)
running a [Jasmine](http://pivotal.github.io/jasmine/) spec.

## Usage (snapdragon)

The *snapdragon* command allows you to run your
[Jasmine](http://pivotal.github.io/jasmine/) specs from the command-line just
as you would with RSpec and other testing tools. The following are some usage
examples.

#### Run a specific describe/it block

The following runs the describe or it block that corresponds to line number
*23* in the *spec/javascript/foo_spec.js* file.

```
snapdragon spec/javascript/foo_spec.js:23
```

#### Run an entire spec file(s)

```
snapdragon spec/javascript/foo_spec.js spec/javascript/bar_spec.js
```

#### Run an entire directory of spec files

```
snapdragon spec/javascripts
```

#### Run combination of files and directories

```
snapdragon spec/javascript custom_js/tests/foo_spec.js custom_js/test/bar_spec.js
```

## Usage (snapdragon_server)

The *snapdragon_server* command allows you to run your
[Jasmine](http://pivotal.github.io/jasmine/) specs in your browser. When this
command is run it will launch the *snapdragon_server* and open your default
browser to the proper URL to run your specified test suite. This is especially
useful if you want to debug some JavaScript as your browser most likely has a
JavaScript debugger built into it. A few examples of this commands usage
follow.

#### Run specific spec files

```
snapdragon_server spec/javascript/foo_spec.js spec/javascript/bar_spec.js
```

#### Run all the specs in directories

```
snapdragon_server spec/javascript custom_js/specs
```

#### Combine files and directories

```
snapdragon_server spec/javascript custom_js/tests/foo_spec.js custom_js/test/bar_spec.js
```

## // require_relative() directive

Snapdragon also provides a `// require_relative()` directive that the
Snapdragon preprocessor looks for to identify the necessary implementation
files that need to be loaded for the spec files to run. This directive should
define the relative path to associated implementation files needed for a spec,
relative to that spec file. The following is an example spec and implemantion
file.

*example/src/hoopty.js*

```javascript
var Hoopty = function() {
  this.hello = function() {
    return "Hello There";
  }
};
```

*example/spec/hoopty_spec.js*

```javascript
// require_relative('../src/hoopty.js')

describe("Hoopty", function() {
  it("exists", function() {
    var f = new Hoopty();
    expect(f).not.toBe(undefined);
  });

  describe(".hello", function() {
    it("says hello there", function() {
      var f = new Hoopty();
      expect(f.hello()).toBe("Hello There");
    });
  });
});

```

## The ChangeLog

Information on notable changes in each release can be found in the
[ChangeLog](http://github.com/reachlocal/snapdragon/blob/master/ChangeLog.markdown).

## The Back Story

If you have ever used [Jasmine](http://pivotal.github.io/jasmine/) for your
JavaScript BDD style testing framework I am sure you have run into the
following issues just as I have.

1. Getting up and running with [Jasmine](http://pivotal.github.io/jasmine/) is
   quite a pain and the examples of how to setup your SpecRunner.html are
   sparse.
2. Having to manually add the dependency files and spec files to the
   SpecRunner.html is a huge pain in the ass.
3. Limiting a test run to a specific spec file is near impossible with the
   only solution being to comment out script tags in your SpecRunner.html.
4. Limiting a test run to a specific *describe* or *it* block is near
   impossible because the only way to do it is with the *spec* query param that
   matches the full description of the *describe* or *it* block including all
   its parents. This can be very long and very prone to typos if you try to
   do this.
5. Oh, and did I mention that you have to do all of this in a browser with the
   SpecRunner.html loaded which is not where you actually write your code.

The above issues created a horrible development workflow. Especially
since I came from the world of RSpec where the above issues are non-existent
and it is easily run from the command line and integrated into most editors.

Snapdragon is my preferred solution to the above listed issues.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests & dev your feature using BDD/TDD with RSpec.
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
