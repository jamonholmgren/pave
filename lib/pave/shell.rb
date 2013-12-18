module Pave
  module Shell
    def Shell.included klass
      klass.extend Shell
    end

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
