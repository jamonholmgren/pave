require "pave/shell"

module Pave
  class Theme
    include Pave::Shell

    attr_reader :name

    def self.create(name)
      new(name).setup
    end

    def self.watch
      `sass --watch ./themes/ --style compressed`
    end

    def initialize(name)
      @name = name
    end

    def install_sass
      say "Installing SASS..."
      sh "gem install sass"
    end

    def install_bourbon
      say "Installing Bourbon..."
      sh "gem install bourbon"
      sh "cd themes/#{self.name}/css/ && bourbon install && cd -"
    end

    def install_neat
      say "Installing Neat..."
      sh "gem install neat"
      sh "cd themes/#{self.name}/css/ && neat install && cd -"
    end

    def install_bitters
      say "Installing Bitters"
      sh "gem install bitters"
      sh "cd themes/#{self.name}/css/ && bitters install && cd -"
    end    

    def copy_theme
      sh "cp -a #{Pave.template_folder}/themes/blank #{Dir.pwd}/themes/#{self.name}"
    end

    def setup
      say "Creating theme..."
      copy_theme
      install_sass
      install_bourbon
      install_neat
      install_bitters
      say "Docs for Neat: http://neat.bourbon.io/"
      say "Docs for Bitters: https://github.com/thoughtbot/bitters"
      say ""
      say "Theme installed. Run `pave watch` to generate css from your sass files."
    end

  end
end