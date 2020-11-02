require 'CSV'
require_relative './game'
class GamesRepo
  attr_reader :parent, :games, :rival_games

  def initialize(path, parent)
    @parent = parent
    @games = create_games(path)
    @rival_games = []
  end

  def create_games(path)
    rows = CSV.readlines('./data/games.csv', headers: :true , header_converters: :symbol)

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
    seasons = @games.map do |game|
      game.season
    end.uniq
    hash = {}
    seasons.each do |season|
      hash[season]= count_of_games_in_season(season)
    end
    hash
  end

  def average_goals_per_game
    average_goals = @games.sum do |game|
      game.total_goals
    end.to_f / @games.count
    average_goals.round(2)
  end

  def average_goals_by_season
    hash = count_of_games_by_season
    hash.each_pair do |season, num_games|
      season_games = @games.select do |game|
        game.season == season
      end
      hash[season] = season_games.sum do |game|
        game.total_goals
      end.to_f / num_games
      hash[season] = hash[season].round(2)
    end
    hash
  end

  def games_containing(header, value, games = @games)
    games.select do |game|
      game.send(header) == value
    end
  end

  def game_ids_by(season_id)
    games = games_containing(:season, season_id)
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
    seasons = seasons.uniq
  end

  def all_games_by_season
    season_hash = {}
    season_collection.each do |season|
      season_hash[season] =  game_ids_by(season)
    end
    season_hash
  end

  def favorite_opponent(team_id, team_ids, min_max_by)
    away_games = games_containing(:away_team_id,team_id)
    home_games = games_containing(:home_team_id, team_id)
    other_teams = team_ids.delete(team_id)
    away_games_shoveler(away_games)
    home_games_shoveler(home_games)
    other_teams.send(min_max_by) do |opponent|
      games = games_containing(:opponent_id, opponent, @rival_games)
      win_percentage(games)
    end
  end

  def away_games_shoveler(away_games)
     away_games.each do |away_game|
      rival_games << Rival.new(away_game.away_team_id, away_game.home_team_id, result(away_game.away_goals,away_game.home_goals))
    end
  end

  def home_games_shoveler(home_games)
    home_games.each do |home_game|
     rival_games << Rival.new(home_game.home_team_id, home_game.away_team_id, result(home_game.home_goals,home_game.away_goals))
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

  def win_percentage(subset_game_teams)
    wins = games_containing(:result, "WIN", subset_game_teams)
    (wins.count.to_f / subset_game_teams.count).round(2)
  end
end
