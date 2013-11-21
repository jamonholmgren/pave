module Pave
  class Concrete
    include Pave::Shell

    attr_accessor :name

    def self.create(name, options)
      say ""
      return say "Options should be given after the application name. For details run: `pave help`" unless name.size > 0
      say "Setting up Concrete5 in folder #{name}."
      new(name).setup
    end

    def initialize(name)
      @name = name
    end

    def setup
      clone_concrete5
      set_up_app_folder
      initialize_git
      create_virtual_host
      self
    end

    def clone_concrete5
      say "* Downloading Concrete5 version 5.6.2.1..."
      sh "curl http://www.concrete5.org/download_file/-/view/58379/8497 -o c5.zip > /dev/null"
      say ""
      say "* Unzipping..."
      sh "unzip c5.zip"
      sh "rm c5.zip"
      sh "mv concrete5.6.2.1 #{name}"
      say "* Concrete5 downloaded and unzipped into ./#{name}."
    end

    def set_up_app_folder
      say "* Setting up folders..."
      sh "mkdir #{name}/app"

      symlink_folders
      remove_extra_folders
      modify_folder_permissions
    end

    def initialize_git
      say "* Setting up git..."
      sh "echo 'files/cache/*' > #{name}/.gitignore"
      sh "echo 'files/tmp/*' >> #{name}/.gitignore"
      sh "cd #{name} && git init && git add -A && git commit -m 'Initial'"
    end

    def sudo?
      `whoami` == "root"
    end

    def create_virtual_host
      if sudo?
        Pave::VirtualHost.new("#{name}.site").create_vhost
      else
        say "Virtual host not set up. Run `sudo pave vh:create #{name}.site` to create it."
      end
    end

    def modify_folder_permissions
      world_writable_folders.each do |folder|
        sh "chmod -R 777 #{folder}"
      end
    end

    def world_writable_folders
      [
        :config,
        :packages,
        :files
      ]
    end

    def symlink_folders
      symlinked_folders.each do |folder|
        sh "ln -s #{name}/#{folder} app/#{folder}"
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
