require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
require './lib/games_repo'
require 'mocha/minitest'
require './lib/game'
require './lib/rival'

class GamesRepoTest < Minitest::Test
  def setup
    game_path = './data/games.csv'

    locations = {
      games: game_path
    }
    @parent = mock()

    @games_repo = GamesRepo.new(locations[:games], @parent)
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Array, @games_repo.games
    assert mock(), @parent
  end

  def test_create_game
    assert_instance_of Game, @games_repo.games[0]
  end

  def test_it_can_select_highest_total_goals
    assert_equal 11, @games_repo.highest_total_goals
  end

  def test_it_can_select_lowest_total_goals
    assert_equal 0, @games_repo.lowest_total_goals
  end

  def test_it_can_count_games_in_season
    assert_equal 806, @games_repo.count_of_games_in_season("20122013")
  end

  def test_average
    assert_equal 0.50, @games_repo.average(2, 4)
  end

  def test_rival_games_filler
    team_id = 3
    @games_repo.rival_games_filler(team_id)

    assert_equal 6, @games_repo.rival_games[0].opponent_id
  end

  def test_it_can_return_hash_games_by_season
    expected = {"20122013"=>806,
                "20162017"=>1317,
                "20142015"=>1319,
                "20152016"=>1321,
                "20132014"=>1323,
                "20172018"=>1355}
    assert_equal expected ,@games_repo.count_of_games_by_season
  end

  def test_it_can_average_goals_per_game
    assert_equal 4.22, @games_repo.average_goals_per_game
  end

  def test_it_can_average_goals_by_season
    expected = {"20122013"=>4.12,
                "20162017"=>4.23,
                "20142015"=>4.14,
                "20152016"=>4.16,
                "20132014"=>4.19,
                "20172018"=>4.44}
    assert_equal expected, @games_repo.average_goals_by_season
  end

  def test_games_containing
    assert_equal 1, @games_repo.games_containing(:game_id, "2012030221",@games_repo.games).length
  end

  def test_game_ids_by
    assert_equal 806, @games_repo.game_ids_by("20122013").length
  end

  def test_season_collection
    assert_instance_of Array, @games_repo.season_collection
  end

  def test_all_games_by_season
    assert_instance_of Hash, @games_repo.all_games_by_season
  end

  def test_home_game_and_away_game_shovelers
    away_games = @games_repo.games_containing(:away_team_id,7, @games_repo.games)
    home_games = @games_repo.games_containing(:home_team_id, 7,@games_repo.games)
    assert_instance_of Array, @games_repo.away_games_shoveler(away_games)
    assert_instance_of Array, @games_repo.home_games_shoveler(home_games)
  end

  def test_favorite_opponent
    team_ids = [7,14,18]
    assert_equal 14, @games_repo.favorite_opponent(18,team_ids,:max_by)
  end

  def test_result
    assert_equal "WIN", @games_repo.result(10, 2)
    assert_equal "LOSS", @games_repo.result(2, 10)
    assert_equal "TIE", @games_repo.result(5,5)
  end

  def test_win_percentage
    games = @games_repo.games_containing(:home_team_id, 3, @games_repo.games)
    @games_repo.away_games_shoveler(games)
    assert_equal 0.38, @games_repo.win_percentage(@games_repo.rival_games)
  end
end
