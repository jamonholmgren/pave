module Pave
  class Theme
    include Pave::Shell

    attr_reader :name

    def self.create(name)
      new(name).setup
    end

    def watch(browser)
      processes = []
      processes << Process.spawn("pave livereload #{browser}", out: $stdout, err: $stderr)
      processes << Process.spawn("sass --watch ./themes/ --style compressed", out: $stdout, err: $stderr)
      processes << Process.spawn("coffee -wcj ./themes/#{name}/js/app.js ./themes/#{name}/js/", out: $stdout, err: $stderr)

      Signal.trap("INT") do
        processes.map do |pid|
          Process.kill("INT", pid)
        end

        exit!
      end

      Process.wait processes.sample # Just wait on a random process
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
      say "Installing Bitters..."
      sh "gem install bitters"
      sh "cd themes/#{self.name}/css/ && bitters install && cd -"
    end

    def copy_theme
      sh "cp -a #{Pave.template_folder}/themes/blank #{Dir.pwd}/themes/#{self.name}"
    end

    def create_project_css_folders
      sh "cd themes/#{self.name}/css/ && mkdir -p #{self.name}/{components,layouts}"
      sh "cd themes/#{self.name}/css/#{self.name} && touch ./components/_components.scss && touch ./layouts/_layouts.scss"
      sh "cd themes/#{self.name}/css/ && echo \"@import '#{self.name}/components/components';\" >> ./styles.scss && echo \"@import '#{self.name}/layouts/layouts';\" >> ./styles.scss"
    end

    def setup
      say "Creating theme..."
      copy_theme
      install_sass
      install_bourbon
      install_neat
      install_bitters
      create_project_css_folders
      say "Docs for Bourbon: http://bourbon.io/docs/"
      say "Docs for Neat: http://neat.bourbon.io/"
      say "Docs for Bitters: http://bitters.bourbon.io/"
      say ""
      say "Theme installed. Run `pave watch` to generate css from your sass files."
    end

  end
end
