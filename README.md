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

```
brew install phantomjs
```

## Usage

Snapdragon provides two commands, **snapdragon** and **snapdragon_server**
which allow you to run your [Jasmine](http://pivotal.github.io/jasmine/)
tests.

### snapdragon

The first is focused around allowing you to run your
[Jasmine](http://pivotal.github.io/jasmine/) specs purely from the
command-line and see the output of your tests justs as you would if using
RSpec out of the box. The follownig are a few different examples of how this
can be used.

### snapdragon_server

The second is focused around allowing you to run your
[Jasmine](http://pivotal.github.io/jasmine/) specs in your browser. When this
command is run it will launch the **snapdragon_server** and open your default
browser to the proper URL to run your specified test suite.  This is
especially useful if you want to debug some JavaScript as your browser most
likely has a JavaScript debugger built into it. A few examples of this command
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
   impossible because the only way to do it is with the **spec** query param that
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
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
