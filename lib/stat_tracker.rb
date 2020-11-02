require 'CSV'
require_relative './games_repo'
require_relative './teams_repo'
require_relative './game_teams_repo'

class StatTracker
  attr_reader :games_repo, :teams_repo, :game_teams_repo

  def initialize(locations)
    @games_repo = GamesRepo.new(locations[:games], self)
    @teams_repo = TeamsRepo.new(locations[:teams], self)
    @game_teams_repo = GameTeamsRepo.new(locations[:game_teams], self)

  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def count_of_teams
    @teams_repo.count_of_teams
  end

  def best_offense
    id = @game_teams_repo.highest_average_goals
    @teams_repo.team_name(id)
  end

  def worst_offense
    id = @game_teams_repo.lowest_average_goals
    @teams_repo.team_name(id)
  end

  def highest_total_score
    @games_repo.highest_total_goals
  end

  def lowest_total_score
    @games_repo.lowest_total_goals
  end

  def count_of_games_by_season
    @games_repo.count_of_games_by_season
  end

  def average_goals_per_game
    @games_repo.average_goals_per_game
  end

  def average_goals_by_season
    @games_repo.average_goals_by_season
  end

  def percentage_home_wins
    @game_teams_repo.percentage_wins("home")
  end

  def percentage_visitor_wins
    @game_teams_repo.percentage_wins("away")
  end

  def percentage_ties
    @game_teams_repo.percentage_ties
  end

  def highest_scoring_visitor
    id = @game_teams_repo.highest_average_hoa_goals("away")
    @teams_repo.team_name(id)
  end

  def highest_scoring_home_team
    id = @game_teams_repo.highest_average_hoa_goals("home")
    @teams_repo.team_name(id)
  end

  def lowest_scoring_visitor
    id = @game_teams_repo.lowest_average_hoa_goals("away")
    @teams_repo.team_name(id)
  end

  def lowest_scoring_home_team
    id = @game_teams_repo.lowest_average_hoa_goals("home")
    @teams_repo.team_name(id)
  end

  def winningest_coach(season_id)
    game_ids = @games_repo.game_ids_by(season_id)
    @game_teams_repo.coach_win_percentage(:max_by, game_ids)
  end

  def worst_coach(season_id)
    game_ids = @games_repo.game_ids_by(season_id)
    @game_teams_repo.coach_win_percentage(:min_by, game_ids)
  end

  def most_accurate_team(season_id)
    game_ids = @games_repo.game_ids_by(season_id)
    id = @game_teams_repo.accurate_team(game_ids, :max_by)
    @teams_repo.team_name(id)
  end

  def least_accurate_team(season_id)
    game_ids = @games_repo.game_ids_by(season_id)
    id = @game_teams_repo.accurate_team(game_ids, :min_by)
    @teams_repo.team_name(id)
  end

  def most_tackles(season_id)
    game_ids = @games_repo.game_ids_by(season_id)
    id = @game_teams_repo.tackles_by_team(game_ids, :max_by)
    @teams_repo.team_name(id)
  end

  def fewest_tackles(season_id)
    game_ids = @games_repo.game_ids_by(season_id)
    id = @game_teams_repo.tackles_by_team(game_ids, :min_by)
    @teams_repo.team_name(id)
  end

  def best_season(team_id)
    team_id = team_id.to_i
    temp = @games_repo.all_games_by_season
    @game_teams_repo.win_percentage_season(team_id, :max_by, temp)
  end

  def worst_season(team_id)
    team_id = team_id.to_i
    temp = @games_repo.all_games_by_season
    @game_teams_repo.win_percentage_season(team_id, :min_by, temp)
  end

  def average_win_percentage(team_id)
    team_id = team_id.to_i
    games = @game_teams_repo.games_containing(:team_id, team_id)
    @game_teams_repo.win_percentage(games)
  end

  def most_goals_scored(team_id)
    team_id = team_id.to_i
    @game_teams_repo.highest_and_lowest_goals(team_id, :max_by)
  end
  
  def fewest_goals_scored(team_id)
    team_id = team_id.to_i
    @game_teams_repo.highest_and_lowest_goals(team_id, :min_by)
  end

  def favorite_opponent(team_id)
    team_id = team_id.to_i
    team_ids = @game_teams_repo.team_ids
    favorite = @games_repo.favorite_opponent(team_id, team_ids, :max_by)
    @teams_repo.team_name(favorite)
  end

  def rival(team_id)
    team_id = team_id.to_i
    team_ids = @game_teams_repo.team_ids
    rival = @games_repo.favorite_opponent(team_id, team_ids, :min_by)
    @teams_repo.team_name(rival)
  end

  def team_info(team_id)
    team_id = team_id.to_i
    @teams_repo.team_info(team_id)
  end
end
