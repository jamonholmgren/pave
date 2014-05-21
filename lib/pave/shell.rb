module Pave
  module Shell
    def Shell.included base
      base.extend Shell
    end

    def shell(command)
      output = `#{command}`
      Struct.new(:status, :output).new($?, output)
    end

    def sh(cmd)
      result = shell(cmd)
      puts result.output
      result.status
    end

    def file_insert(insert_file, insert_pattern, insert_lines)
      file_string = File.read(insert_file).sub(insert_pattern, "#{insert_pattern}\n#{insert_lines}")
      puts file_string
      puts insert_pattern
      puts insert_lines
      puts insert_file
      File.write(insert_file, file_string)
    end
  end
end
