require "commander/import"
require "pave/version"
require "pave/shell"
require "pave/concrete"
require "pave/database"
require "pave/files"
require "pave/virtual_host"
require "pave/remote"
require "pave/theme"
require "pave/reload"

module Pave
  def update
    say "Updating pave..."
    `gem update pave`
    ($? == 0) ? (say "Updated") : (say "Update failed. Run `gem update pave` manually.")
    say `pave --version`
  end
  module_function :update

  def clean
    say "Cleaning up cached files..."
    `rm -rf ~/.pave`
    ($? == 0) ? (say "Done") : (say "Failed")
  end
  module_function :clean

  def template_folder
    script = File.join(File.expand_path("../", File.dirname(__FILE__)), "templates")
  end
  module_function :template_folder
end
