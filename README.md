# Snapdragon

**A Jasmine (JavaScript) test runner built with developer workflow in mind.**

## The Problem

If you have ever used Jasmine for your JavaScript BDD style testing framework
I am sure you have run into the following issues just as I have.

1. Having to manually add the dependency files and spec files to the
   SpecRunner.html is a pain in the ass.
2. Limiting a test run to a specific spec file is near impossible with the
   only solution being to comment out script tags in your SpecRunner.html.
3. Limiting a test run to a specific *describe* block or *it* block is near
   impossible because the only way to do it is with the spec query param that
   matches the full description of the *describe* or *it* block including all
   its parents. This can be very long and very prone to typos if you try to
   do this.
4. Getting up and running with Jasmine is quite a pain and the
   examples of how to setup your SpecRunner.html are sparse.
5. Oh, and did I mention that you have to do all of this in a browser with the
   SpecRunner.html loaded which is not where you actually write your code.

The above issues created a horrible development workflow. Especially
since I came from the world of RSpec where the above issues are non-existent
and it is easily run from the command line and integrated into most editors.

## The Solution

Snapdragon is of course my solution to the issues listed above. It eliminates
all of the above issues by providing a command-line tool that handles
dynamically building your the Spec Runner and running it in a PhantomJS
headless browser for you.

## Installation

Add this line to your application's Gemfile:

    gem 'snapdragon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snapdragon

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
