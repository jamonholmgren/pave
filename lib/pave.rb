require "pave/version"

module Pave
  class Concrete
    include Methadone::CLILogging
    include Methadone::SH

    attr_accessor :name

    def self.create(name)
      info "Creating #{name}!"
      new(name).setup
    end

    def initialize(name)
      @name = name
    end

    def setup
      make_folder
      clone_concrete5
    end

    def make_folder
      sh "mkdir #{name}"
    end

    def clone_concrete5
      info "Downloading Concrete5 version 5.6.2.1..."
      sh "curl http://www.concrete5.org/download_file/-/view/58379/8497 -o c5.zip"
      sh "unzip c5.zip -d ./#{name}"
    end
  end
end
