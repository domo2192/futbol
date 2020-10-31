require 'CSV'
require_relative './game_teams'
class GameTeamsRepo
  attr_reader :parent,
              :game_teams

  def initialize(path, parent)
    @parent = parent
    @game_teams = create_game_teams(path)
  end

  def create_game_teams(path)
    rows = CSV.readlines('./data/game_teams.csv', headers: :true , header_converters: :symbol)

    rows.map do |row|
      GameTeams.new(row, self)
    end
  end

  def find_team_by(id)
    @game_teams.find_all do |game_team|
      game_team.team_id == id
    end
  end

  def average_goals_by(id)
    team_games = find_team_by(id)
    total_goals = team_games.sum do |team_game|
      team_game.goals
    end
    (total_goals.to_f / team_games.count).round(2)
  end

  def average_hoa_goals_by_id(id, hoa, hoa_value)
    hoa_games = games_containing(hoa, hoa_value)
    team_games = games_containing(:team_id, id, hoa_games)
    total_goals = team_games.sum do |team_game|
      team_game.goals
    end
    (total_goals.to_f / team_games.count).round(2)
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

  def games_containing(header, value, games = @game_teams)
    games.select do |game|
      game.send(header) == value
    end
  end

  def percentage_wins(hoa)
    games = games_containing(:hoa, hoa)
    wins = games_containing(:result, "WIN", games).count.to_f
    (wins / games.count).round(2)
  end

  def percentage_ties
    games = games_containing(:hoa, "home")
    ties = games_containing(:result, "TIE", games).count.to_f
    (ties / games.count).round(2)
  end

  def coach_name(team_id)
    @game_teams.find do |game_team|
      game_team.team_id == team_id
    end.head_coach
  end

  def win_percentage(subset_game_teams)
    wins = games_containing(:result, "WIN", subset_game_teams)
    (wins.count.to_f / subset_game_teams.count).round(2)
  end

  def coach_win_percentage(min_max_by)
    team = team_ids.send(min_max_by) do |id|
      games = games_containing(:team_id, id)
      win_percentage(games)
    end
    coach_name(team)
  end
end
