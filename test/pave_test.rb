require "test/unit"

class PaveTest < Test::Unit::TestCase
  def test_is_module
    assert Pave.is_a?(Module)
  end
end
