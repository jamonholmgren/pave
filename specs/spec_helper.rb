require 'rubygems'
require 'stringio'

# Unshift so that local files load instead of something in gems
$:.unshift File.dirname(__FILE__) + '/../lib'

require 'pave'

# Mock terminal IO streams so we can spec against them

def mock_terminal
  @input = StringIO.new
  @output = StringIO.new
  $terminal = HighLine.new @input, @output
end

