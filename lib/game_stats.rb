class GameStats

  def initialize
    @data_titles = []
  end

  def read_file(filename)
    lines = File.readlines(filename)
    require "pry"; binding.pry
  end

  def lines_split(lines)
    split_lines = lines.map do |line|
      line.line_split
    end
  end

  def line_split(line)
    line.split(",")
  end

end
