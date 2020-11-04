# mathablemike
module Mathable

  def games_containing(header, value, games)
    games.select do |game|
      game.send(header) == value
    end
  end

  def win_percentage(games)
    wins = games_containing(:result, "WIN", games)
    average(wins.count, games.count)
  end

  def average(amount, total)
    average_number = amount.to_f / total
    average_number.round(2)
  end
end