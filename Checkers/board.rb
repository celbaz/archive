require_relative 'piece.rb'
require 'colorize'

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

  def display # add colorized board
    i = 9
    until i < 0
      row = @grid[i]
      string = "#{i} "
      shift = (i % 2 == 0) ? 0 : 1
      row.each_with_index do |spot, j|
          string += spot.nil? ? "   " : spot.print
          colour  = (j % 2 == shift) ? :red : :light_blue
          string[-3..-1] = string[-3..-1].colorize( :background => colour)
      end
      i -=1
      puts string
    end
    puts "   0  1  2  3  4  5  6  7  8  9"
  end

  def [](pos)
    raise BoardError.new "You have a [] error" unless valid_input?(pos)

    x,y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    raise BoardError.new "You have a []= error" unless valid_input?(pos)

    x,y = pos
    @grid[x][y] = piece
  end

  def valid_input?(pos)
    if pos.size == 2 && pos.all? { |c| c.is_a?(Fixnum) && c.between?(0,9)}
      return true
    else
      return false
    end
  end

  def dup
    result = self.class.new(false)
    @grid.flatten.compact.each do |piece|
        result[piece.pos] = piece.dup(result)
    end
    result
  end

  def pieces_left(color)
    @grid.flatten.compact.select.count { |piece| piece.color == color }
  end
end

class BoardError < StandardError

end
