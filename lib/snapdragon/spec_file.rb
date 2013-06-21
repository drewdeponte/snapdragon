require_relative './file_base'
require_relative './path'

module Snapdragon
  class SpecFile < Snapdragon::FileBase
    def filtered?
      return @path.has_line_number?
    end

    def spec_query_param
      return '' if !filtered?

      # Work our way from the line number up to build the spec query param
      # description
      initial_line_number = @path.line_number
      initial_line_index = initial_line_number - 1

      f = open(File.expand_path(@path.path), 'r')
      lines = f.readlines
      f.close

      desc_components = []

      already_been_inside_an_it = false
      already_been_inside_a_describe = false
      last_describe_indent_spaces = 1232131312

      cur_line_index = initial_line_index
      while cur_line_index >= 0 
        if lines[cur_line_index] =~ /it\s*\(\s*"(.+)"\s*,/ && !already_been_inside_an_it && !already_been_inside_a_describe # line matches it statement
          desc_components.push($1)
          already_been_inside_an_it = true
        elsif lines[cur_line_index] =~ /(\s*)describe\s*\(\s*"(.+)"\s*,/ # line matches a describe block
          if $1.length < last_describe_indent_spaces # use indent depth to identify parent
            desc_components.push($2)
            last_describe_indent_spaces = $1.length
          end
          already_been_inside_a_describe = true
        end
        cur_line_index -= 1
      end

      return desc_components.reverse.join(" ")
    end
  end
end
