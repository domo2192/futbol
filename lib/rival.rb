class Rival
  attr_reader :team_id, :opponent_id, :result

  def initialize(team_id, opponent_id, result)
    @team_id = team_id
    @opponent_id = opponent_id
    @result = result
  end
end
