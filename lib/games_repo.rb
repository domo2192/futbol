require 'CSV'
require_relative './game'
require_relative './rival'
require_relative './mathable'

class GamesRepo
  include Mathable
  attr_reader :parent, :games, :rival_games

  def initialize(path, parent)
    @parent = parent
    @games = create_games(path)
    @rival_games = []
  end

  def create_games(path)
    rows = CSV.readlines(path, headers: :true , header_converters: :symbol)

    rows.map do |row|
      Game.new(row, self)
    end
  end

  def highest_total_goals
    @games.max_by do |game|
      game.total_goals
    end.total_goals
  end

  def lowest_total_goals
    @games.min_by do |game|
      game.total_goals
    end.total_goals
  end

  def count_of_games_in_season(season)
    @games.select do |game|
      game.season == season
    end.count
  end

  def count_of_games_by_season
    games_by_season = {}
    season_collection.each do |season|
      games_by_season[season] = count_of_games_in_season(season)
    end
    games_by_season
  end

  def average_goals_per_game
    all_goals = @games.sum do |game|
      game.total_goals
    end
    average(all_goals, @games.count)
  end

  def average_goals_by_season
    games_by_season = count_of_games_by_season
    games_by_season.each_pair do |season, num_games|
      season_games = games_containing(:season, season, @games)
      all_goals = season_games.sum do |game|
        game.total_goals
      end
      games_by_season[season] = average(all_goals, num_games)
    end
    games_by_season
  end

  def game_ids_by(season_id)
    games = games_containing(:season, season_id, @games)
    game_ids = []
    games.each do |game|
      game_ids << game.game_id
    end
    game_ids
  end

  def season_collection
    seasons = []
    games.each do |game|
      seasons << game.season
    end
    seasons.uniq
  end

  def all_games_by_season
    games_by_season = {}
    season_collection.each do |season|
      games_by_season[season] =  game_ids_by(season)
    end
    games_by_season
  end

  def favorite_opponent(team_id, team_ids, min_max_by)
    rival_games_filler(team_id)
    team_ids.delete(team_id)
    other_teams = team_ids
    other_teams.send(min_max_by) do |opponent|
      games = games_containing(:opponent_id, opponent, @rival_games)
      win_percentage(games)
    end
  end

  def rival_games_filler(team_id)
    away_games = games_containing(:away_team_id,team_id, @games)
    home_games = games_containing(:home_team_id, team_id, @games)
    away_games_shoveler(away_games)
    home_games_shoveler(home_games)
  end

  def away_games_shoveler(away_games)
    away_games.each do |away_game|
      rival_games << Rival.new(away_game.away_team_id, away_game.home_team_id, result(away_game.away_goals,away_game.home_goals))
    end
  end

  def home_games_shoveler(home_games)
    home_games.each do |home_game|
      rival_games << Rival.new(home_game.home_team_id, home_game.away_team_id, result(home_game.home_goals, home_game.away_goals))
    end
  end

  def result(our_goals, opponents_goals)
    if our_goals > opponents_goals
      "WIN"
    elsif our_goals == opponents_goals
      "TIE"
    else
      "LOSS"
    end
  end
end
