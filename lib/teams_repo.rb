
require 'CSV'
require_relative './team'

class TeamsRepo
  attr_reader :parent, :teams

  def initialize(path, parent)
    @parent = parent
    @teams = create_teams(path)
  end

  def create_teams(path)
    rows = CSV.readlines(path, headers: :true , header_converters: :symbol)

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
    team = @teams.find do |the_team|
      id == the_team.team_id
    end
    {
      "team_id" => team.team_id.to_s,
      "franchise_id" => team.franchise_id.to_s,
      "team_name" => team.team_name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end
end