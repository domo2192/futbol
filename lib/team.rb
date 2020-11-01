class Team
  attr_reader :parent,
              :team_id,
              :franchise_id,
              :team_name,
              :abbreviation,
              :stadium,
              :link 

  def initialize(row, parent)
    @parent       = parent
    @team_id      = row[:team_id].to_i
    @franchise_id = row[:franchiseid].to_i
    @team_name    = row[:teamname]
    @abbreviation = row[:abbreviation].upcase
    @stadium      = row[:stadium]
    @link         = row[:link]
  end
end
