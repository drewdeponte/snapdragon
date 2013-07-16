# Capturing the stdout
# Need to rescue SystemExit
# https://github.com/cldwalker/hirb/blob/master/test/test_helper.rb
def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  rescue SystemExit
  ensure
    $stdout = original_stdout
  end
  fake.string
end
