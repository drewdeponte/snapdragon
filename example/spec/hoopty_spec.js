// require_relative('../src/hoopty.js')

// This is just some example Jasmine spec code to test that everything would
// work assuming that I can find a way to get the spec code loaded in here
// like this.
describe("Hoopty", function() {
  it("exists", function() {
    var f = new Hoopty();
    expect(f).not.toBe(undefined);
  });

  it("handles pending", function() {
  });

  it("handles another pending", function() {
  });

  describe(".hello", function() {
    it("says hello there", function() {
      var f = new Hoopty();
      expect(f.hello()).toBe("Hello There aeuaeuo");
    });
  });

  describe(".goodbye", function() {
    it("says goodbye", function() {
      var f = new Hoopty();
      expect(f.goodbye()).toBe("goodbye");
    });
  });
});
