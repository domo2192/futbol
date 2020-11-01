
require 'CSV'
require_relative './team'

class TeamsRepo
  attr_reader :parent, :teams

  def initialize(path, parent)
    @parent = parent
    @teams = create_teams(path)
  end

  def create_teams(path)1
    rows = CSV.readlines('./data/teams.csv', headers: :true , header_converters: :symbol)

    rows.map do |row|
      Team.new(row, self)
    end
  end

  def count_of_teams
    @teams.count
  end

  def team_name(id)
   @teams.find do |team|
     team.team_id == id
    end.team_name
  end

  def team_info(id)
    team = @teams.find do |team|
      id == team.team_id
    end
      team_information = {team_id: team.team_id,
      franchise_id: team.franchise_id,
      team_name: team.team_name,
      abbreviation: team.abbreviation,
      link: team.link}
  end
end
