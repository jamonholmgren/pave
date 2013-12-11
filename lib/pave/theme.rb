require "pave/shell"

module Pave
  class Theme
    include Pave::Shell

    attr_accessor :name

    def self.create(name)
      new(name).setup
    end

    def initialize(name)
      @name = name
    end

    def setup
      say "Creating theme..."
      sh "cp -a #{TEMPLATES_HOME}/themes/blank #{Dir.pwd}/themes/#{name}/"
    end


  end
end