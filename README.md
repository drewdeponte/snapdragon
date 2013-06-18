# Snapdragon

**A command-line Jasmine (JavaScript) test runner built with developer workflow in mind.**

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

TODO: Write usage instructions here

## The Back Story

If you have ever used Jasmine for your JavaScript BDD style testing framework
I am sure you have run into the following issues just as I have.

1. Getting up and running with Jasmine is quite a pain and the
   examples of how to setup your SpecRunner.html are sparse.
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
