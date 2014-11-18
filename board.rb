require_relative 'pieces.rb'

class Board
  def initialize
      @board = Array.new(8) {Array.new(8,nil)}
      fill_board
  end

  attr_accessor :board
  def fill_board
    [0, 2].each do |i|
        type = "RNB"
      [0, 2].each do |j|
          @board[0][j] = SlidingPiece.new(type[i], self, 'black')
          @board[0][-1 - j] = SlidingPiece.new(type[i], self, 'black')
          @board[7][j] = SlidingPiece.new(type[i], self, 'white')
          @board[7][-1 -j] = SlidingPiece.new(type[i], self, 'white')
      end
    end

    @board[0][1] = SteppingPiece.new("N", self, 'black')
    @board[0][6] = SteppingPiece.new("N", self, 'black')
    @board[7][1] = SteppingPiece.new("N", self, 'white')
    @board[7][6] = SteppingPiece.new("N", self, 'white')

    @board[0][3] = SlidingPiece.new("Q", self, 'black')
    @board[0][4] = SteppingPiece.new("K", self, 'black')
    @board[7][3] = SlidingPiece.new("Q", self, 'white')
    @board[7][4] = SteppingPiece.new("K", self, 'white')

    (0...8).each do |j|
        @board[1][j] = Pawn.new('P', 'black', self)
        @board[6][j] = Pawn.new('P', 'white', self)
    end
  end

  def display
    count = 0
        puts "  --------"
      @board.each do |row|
        string ="#{count}|"
        row.each do |el|
          if el.nil?
            string += ' '
          else
            string += el.type.to_s
          end

        end
          puts string + "|"
          count +=1
      end
      puts "  --------"
      puts "  01234567"
  end

  def in_check?(color)

  end

  def move(start,end_pos)

  end
end
