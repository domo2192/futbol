require 'CSV'
require_relative './game_teams'
require_relative './mathable'

class GameTeamsRepo
  include Mathable
  attr_reader :parent,
              :game_teams

  def initialize(path, parent)
    @parent = parent
    @game_teams = create_game_teams(path)
  end

  def create_game_teams(path)
    rows = CSV.readlines(path, headers: :true , header_converters: :symbol)

    rows.map do |row|
      GameTeams.new(row, self)
    end
  end

  def average_goals_by(id)
    team_games = games_containing(:team_id, id, @game_teams)
    total_goals = team_games.sum do |team_game|
      team_game.goals
    end
    average(total_goals, team_games.count)
  end

  def average_hoa_goals_by_id(id, hoa, hoa_value)
    hoa_games = games_containing(hoa, hoa_value, @game_teams)
    team_games = games_containing(:team_id, id, hoa_games)
    total_goals = team_games.sum do |team_game|
      team_game.goals
    end
    average(total_goals, team_games.count)
  end

  def team_ids
    team_ids = []
    @game_teams.each do |game_team|
      team_ids << game_team.team_id
    end
    team_ids.uniq
  end

  def highest_average_goals
    ids = team_ids
    ids.max_by do |id|
      average_goals_by(id)
    end
  end

  def highest_average_hoa_goals(hoa_value)
    ids = team_ids
    ids.max_by do |id|
      average_hoa_goals_by_id(id, :hoa, hoa_value)
    end
  end

  def lowest_average_hoa_goals(hoa_value)
    ids = team_ids
    ids.min_by do |id|
      average_hoa_goals_by_id(id, :hoa, hoa_value)
    end
  end

  def lowest_average_goals
    ids = team_ids
    ids.min_by do |id|
      average_goals_by(id)
    end
  end

  def games_containing_array(values)
    games = []
    values.each do |id|
      result = @game_teams.find_all do |game_team|
        game_team.game_id == id
      end
      games << result
    end
    games.flatten
  end

  def percentage_wins(hoa)
    games = games_containing(:hoa, hoa, @game_teams)
    win_percentage(games)
  end

  def percentage_ties
    games = games_containing(:hoa, "home", @game_teams)
    ties = games_containing(:result, "TIE", games).count.to_f
    average(ties, games.count)
  end

  def coach_name(team_id)
    @game_teams.find do |game_team|
      game_team.team_id == team_id
    end.head_coach
  end

  def coaches(games)
    coach_list = []
    games.each do |game|
      coach_list << game.head_coach
    end
    coach_list.uniq
  end

  def coach_win_percentage(min_max_by, game_ids)
    games = games_containing_array(game_ids)
    coach_list = coaches(games)
    coach_list.send(min_max_by) do |coach|
      games1 = games_containing(:head_coach, coach, games)
      if games1 == []
        0.50
      else
        win_percentage(games1)
      end
    end
  end

  def goals_to_shots_ratio(games)
    goals = games.sum do |game|                                     ##
      game.goals
    end
    shots = games.sum do |game|
      game.shots
    end
    goals.to_f / shots
  end

  def accurate_team(game_ids, min_max_by)
    games = games_containing_array(game_ids)
    team_ids.send(min_max_by) do |id|
      games1 = games_containing(:team_id, id, games)
      if games1 == []
        0.29
      else
        goals_to_shots_ratio(games1)
      end
    end
  end

  def tackles(games)
    games.sum do |game|
      game.tackles
    end
  end

  def tackles_by_team(game_ids, min_max_by)
    games = games_containing_array(game_ids)
    team_ids.send(min_max_by) do |id|
      games1 = games_containing(:team_id, id, games)
      if games1 == []
        2500
      else
        tackles(games1)
      end
    end
  end

  def win_percentage_season(team_id, max_min_by, all_seasons_games)
    all_seasons_games.send(max_min_by) do |season, season_games|
       games = games_containing_array(season_games)
       games = games_containing(:team_id, team_id, games)
       win_percentage(games)
    end.first
  end

  def highest_and_lowest_goals(id, max_min_by)
    team_games = games_containing(:team_id, id, @game_teams)
    team_games.send(max_min_by) do |team_game|
      team_game.goals
    end.goals
  end
end