require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
require 'mocha/minitest'
require './lib/game_teams_repo'

class GameTeamsRepoTest < Minitest::Test
  def setup
    game_teams_path = './data/game_teams.csv'

    locations = {
      game_teams: game_teams_path
    }
    @parent = mock("Stat_tracker")
    @game_teams_repo = GameTeamsRepo.new(locations[:game_teams_path], @parent)
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Array, @game_teams_repo.game_teams
  end
end