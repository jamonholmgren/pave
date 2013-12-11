TEMPLATES_HOME = File.realpath("./templates")

require "commander/import"
require "pave/version"
require "pave/shell"
require "pave/concrete"
require "pave/database"
require "pave/virtual_host"
require "pave/theme"

module Pave
  def update
    say "Updating pave..."
    `gem update pave`
    ($? == 0) ? (say "Updated") : (say "Update failed. Run `gem update pave` manually.")
  end
  module_function :update

end
