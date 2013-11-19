require "commander/import"
require "pave/version"
require "pave/shell"
require "pave/concrete"

module Pave
  def update
    say "Updating pave..."
    `gem update pave`
    say "Updated."
  end
  module_function :update
end
