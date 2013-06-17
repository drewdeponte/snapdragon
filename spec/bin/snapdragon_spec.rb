describe "snapdragon cli" do
  context "when user runs command with specific relative_spec_path:line_number" do
  end

  context "when user runs command with specific relative_spec_path" do
    output = IO.popen(File.expand_path('../../../bin/snapdragon', __FILE__) + " aoeuaeoauaoeuaoe")
    puts output.readlines
  end

  context "when user runs command with specific relative_path_to_directory" do
  end
end
