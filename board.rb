require_relative 'piece.rb'

class Board
  def initialize(set = true)
   @grid  = Array.new(10) {Array.new(10, nil)}
   place_checkers if set
  end

  def place_checkers
    @grid.each_index do |row|
      next if row == 4 || row == 5
      color = (row < 4) ? :white : :black
      start = (row % 2 == 0) ? 0 : 1
      [0,2,4,6,8].each do |col|
        self[[row,col + start]] = Piece.new([row,col+ start],color, self)
      end
    end
  end

  def display
    @grid.each_with_index do |row, i|
      string = "#{i} |"
      row.each do |spot|
          string += spot.nil? ? " " : spot.print
          string += "|"
      end
      puts "  _____________________"
      puts string
    end
    puts "  _____________________"
  end

  def [](pos)
    raise "You have a [] error" unless valid_input?(pos)

    x,y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    raise "You have a []= error" unless valid_input?(pos)

    x,y = pos
    @grid[x][y] = piece
  end

  def valid_input?(pos) #FIX LATER
    # if pos.size == 2 && pos.all? {|c| c.is_a?(Integer) && c.between(0,9)}
      return true
  #   else
  #     return false
  #   end
  end

end
