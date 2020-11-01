require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
require './lib/teams_repo'
require 'mocha/minitest'
require './lib/team'

class TeamsRepoTest < Minitest::Test
  def setup
    teams_path = './data/teams.csv'

    locations = {
      teams: teams_path
    }
    @parent = mock()
    @teams_repo = TeamsRepo.new(locations[:teams], @parent)
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Array, @teams_repo.teams
    assert mock(), @parent
  end

  def test_create_team
    assert_instance_of Team, @teams_repo.teams[0]
  end

  def test_count_of_teams
    assert_equal 32, @teams_repo.count_of_teams
  end

  def test_team_name
    assert_equal "Reign FC", @teams_repo.team_name(54)
  end

  def test_team_info
    expected = {
        :team_id=>1,
        :franchise_id=>23,
        :team_name=>"Atlanta United",
        :abbreviation=>"ATL",
        :link=>"/api/v1/teams/1"
    }
    assert_equal expected, @teams_repo.team_info(1)
  end
end
