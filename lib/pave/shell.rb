module Pave
  module Shell
    def shell(command)
      output = `#{command}`
      Struct.new(:status, :output).new($?, output)
    end

    def sh(command)
      result = shell(command)
      puts result.output
      result.status
    end
  end
end
