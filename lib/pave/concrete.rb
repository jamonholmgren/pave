module Pave
  class Concrete
    include Pave::Shell

    attr_accessor :name

    def self.create(name)
      say ""
      return say "Options should be given after the application name. For details run: `pave help`" unless name.size > 0
      say "Setting up Concrete5 in folder #{name}."
      new(name).setup
    end

    def initialize(name)
      @name = name
    end

    def setup
      set_up_pave
      clone_concrete5
      set_up_folders
      set_up_git
      create_virtual_host
      self
    end

    def set_up_pave
      sh "mkdir ~/.pave" unless File.exists?(File.join(Dir.home, ".pave/"))
    end

    def clone_concrete5
      c5 = "concrete5.6.2.1"
      c5_link = "http://www.concrete5.org/download_file/-/view/58379/8497"
      unless File.exists?(File.join(Dir.home, ".pave/#{c5}.zip"))
        say "* Downloading #{c5}..."
        sh "curl #{c5_link} > ~/.pave/#{c5}.zip"
      end
      say "* Copying Concrete5 into #{name}..."
      sh "unzip -qq ~/.pave/#{c5}.zip && mv #{c5} #{name}"
    end

    def set_up_folders
      say "* Setting up folders..."
      remove_extra_folders
      modify_folder_permissions
    end

    def set_up_git
      say "* Setting up git..."
      sh "touch #{name}/.gitignore"
      gitignored_folders.each{ |folder| sh "echo '#{folder}' >> #{name}/.gitignore" }
      gitkeep_folders.each{ |folder| sh "touch #{name}/#{folder}/.keep" }
      sh "touch #{name}/files/.keep"
      sh "touch #{name}/updates/.keep"
    end

    def gitignored_folders
      [
        "files/avatars/*",
        "files/cache/*",
        "files/incoming/*",
        "files/thumbnails/*",
        "files/tmp/*",
        "files/trash/*",
        ".sass-cache",
        "stylesheets"
      ]
    end

    def create_virtual_host
      say "* Setting up virtual host..."
      if Pave::VirtualHost.new("#{name}.site").create_vhost
        say "Successfully setup virtual host #{name}.site."
      else
        say "Virtual host not set up. Run `pave vh:create #{name}.site` to create it."
      end
    end

    def in_project_dir?
      File.basename(Dir.pwd) == name
    end

    def modify_folder_permissions
      say "* Modifying folder permissions..."

      successful = world_writable_folders.map do |folder|
        sh "sudo chmod -R 777 #{in_project_dir? ? folder.to_s : name + '/' + folder.to_s}"
      end.count{ |x| x != 0 } == 0

      if successful
        say "Successfully modified folder permissions."
      else
        say "Folder permissions not set up. Run `pave setup:permissions` to set them."
      end
    end

    def world_writable_folders
      %w{ blocks config packages files }
    end

    def gitkeep_folders
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
