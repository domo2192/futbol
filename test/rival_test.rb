require 'minitest/autorun'
require 'minitest/pride'
require './lib/rival'

class RivalTest < Minitest::Test
  def test_it_exists_and_has_attributes
    rival = Rival.new(7, 3, "WIN")

    assert_equal 7, rival.team_id
    assert_equal 3, rival.opponent_id
    assert_equal "WIN", rival.result
  end
end