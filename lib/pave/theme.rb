require "pave/shell"

module Pave
  class Theme
    include Pave::Shell

    attr_reader :name

    def self.create(name)
      new(name).setup
    end

    def self.watch
      `sass --watch ./themes/`
    end

    def initialize(name)
      @name = name
    end

    def install_sass
      sh "gem install sass"
    end

    def install_bourbon
      sh "gem install bourbon"
      sh "cd themes/#{self.name}/css/ && bourbon install && cd -"
    end

    def copy_theme
      sh "cp -a #{Pave.template_folder}/themes/blank #{Dir.pwd}/themes/#{self.name}"
    end

    def setup
      say "Creating theme..."
      copy_theme
      install_sass
      install_bourbon
      say "Theme installed. Run `pave watch` to generate css from your sass files."
    end

  end
end