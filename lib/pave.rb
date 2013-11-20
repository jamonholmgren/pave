require "commander/import"
require "pave/version"
require "pave/shell"
require "pave/concrete"

module Pave
  def update
    say "Updating pave..."
    `gem update pave`
    $? == 0 ? say "Updated" : say "Update failed. Run `gem update pave` manually."
  end
  module_function :update
end
