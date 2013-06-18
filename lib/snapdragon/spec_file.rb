module Snapdragon
  class SpecFile
    def initialize(path, line_number = nil)
      @path = path
      @line_number = line_number
    end

    def read
      f = File.open(File.expand_path(@path), 'r')
      content = f.read
      f.close
      return content
    end

    def require_paths
      f = File.open(File.expand_path(@path), 'r')
      lines = f.readlines
      f.close

      require_paths = []

      lines.each do |line|
        if line =~ /\/\/+\s+require_relative\(['"](.+)['"]\)\s+$/
          require_paths << File.expand_path(File.join(File.dirname(@path), $1))
        end
      end

      return require_paths
    end

    def filtered?
      return true if @line_number
      return false
    end

    def spec_query_param
      return '' if !filtered?

      # Work our way from the line number up to build the spec query param
      # description
      initial_line_number = @line_number
      initial_line_index = initial_line_number - 1

      f = open(File.expand_path(@path), 'r')
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
