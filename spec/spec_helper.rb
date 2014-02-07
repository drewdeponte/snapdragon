# Capturing the stdout
# Need to rescue SystemExit
# https://github.com/cldwalker/hirb/blob/master/test/test_helper.rb
def capture_stdout(&block)
  original_stdout = $stdout
  fake_stdout = StringIO.new
  $stdout = fake_stdout
  begin
    yield
  rescue SystemExit
  ensure
    $stdout = original_stdout
  end
  return fake_stdout.string
end

# for hiding the stdout from tests
def hide_stdout(&block)
  original_stdout = $stdout
  fake_stdout = StringIO.new
  $stdout = fake_stdout
  begin
    yield
  ensure
    $stdout = original_stdout
  end
end

# Disable "should" syntax.
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end