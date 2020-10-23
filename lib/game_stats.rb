class GameStats

  def initialize
    @data_titles = []
    @data = []
  end

  def read_file(filename)
    lines = File.readlines(filename)
  end

  def lines_split(lines)
    split_lines = lines.map do |line|
      line.line_split
    end
  end

  def line_split(line)
    line.split(",")
  end

  def key_maker(first_line)
    @data_titles = first_line
  end

  def hash_maker(split_lines)
    key_maker(split_lines[0])
  end

  def hash_iterator(data_lines)
    
  end
end
