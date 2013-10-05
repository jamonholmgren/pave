require "pave/version"

module Pave
  class Concrete
    include Methadone::CLILogging
    include Methadone::SH

    attr_accessor :name

    def self.create(name)
      info ""
      info "Setting up Concrete5 in folder #{name}."
      new(name).setup
      0
    end

    def initialize(name)
      @name = name
    end

    def setup
      clone_concrete5
      set_up_app_folder
      initialize_git
      create_virtual_host
    end

    def clone_concrete5
      info "* Downloading Concrete5 version 5.6.2.1..."
      sh "curl http://www.concrete5.org/download_file/-/view/58379/8497 -o c5.zip > /dev/null"
      info "* Download complete. Unzipping..."
      sh "unzip c5.zip"
      sh "rm c5.zip"
      sh "mv concrete5.6.2.1 #{name}"
      info "* Concrete5 downloaded and unzipped into ./#{name}."
    end

    def set_up_app_folder
      info "* Setting up folders..."
      sh "mkdir #{name}/app"

      symlink_folders
      remove_extra_folders
    end

    def initialize_git
      info "* Setting up git..."
      sh "echo 'files/cache/*' > #{name}/.gitignore"
      sh "echo 'files/tmp/*' >> #{name}/.gitignore"
      sh "cd #{name} && git init && git add -A && git commit -m 'Initial'"
    end

    def create_virtual_host
      # /private/etc/apache2/extra/httpd-vhosts.conf
      # <VirtualHost *:80>
      #   ServerName "mywebsite.site"
      #   DocumentRoot "<pwd>/mywebsite.dev"
      # </VirtualHost>
    end

    def symlink_folders
      symlinked_folders.each do |folder|
        sh "mv #{name}/#{folder} #{name}/app/#{folder}"
        sh "ln -s app/#{folder} #{name}/#{folder}"
      end
    end

    def symlinked_folders
      [ 
        :blocks, 
        :elements, 
        :jobs,
        :page_types,
        :single_pages,
        :themes,
        :packages,
      ]
    end

    def remove_extra_folders
      sh "rmdir #{name}/" + removed_folders.join(" #{name}/")
    end

    def removed_folders
      [ 
        :tools,
        :libraries,
        :models,
        :css,
        :controllers,
        :helpers,
        :js,
        :languages,
        :mail,
      ]
    end
  end
end
