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
          @board[0][j] = SlidingPiece.new(type[j], self, 'black', [0, j])
          @board[0][-1 - j] = SlidingPiece.new(type[j], self, 'black', [0, -1 - j])
          @board[7][j] = SlidingPiece.new(type[j], self, 'white', [7, j])
          @board[7][-1 -j] = SlidingPiece.new(type[j], self, 'white', [7, -1 - j])
      end
    end

    @board[0][1] = SteppingPiece.new("N", self, 'black', [0, 1])
    @board[0][6] = SteppingPiece.new("N", self, 'black', [0,6])
    @board[7][1] = SteppingPiece.new("N", self, 'white', [7,1])
    @board[7][6] = SteppingPiece.new("N", self, 'white', [7,6])

    @board[0][3] = SlidingPiece.new("Q", self, 'black', [0,3])
    @board[0][4] = SteppingPiece.new("K", self, 'black', [0,4])
    @board[7][3] = SlidingPiece.new("Q", self, 'white', [7,3])
    @board[7][4] = SteppingPiece.new("K", self, 'white', [7,4])

    (0...8).each do |j|
        @board[1][j] = Pawn.new('P', 'black', self, [1,j])
        @board[6][j] = Pawn.new('P', 'white', self, [6,j])
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

  def in_check?(color, coord = find_king(color))
    king_pos = coord
    queue = []
    i, j = king_pos
    neighbor_king = @board[i][j].move
    neighbor_king.each do |neighbor|
      row, col = neighbor
      current_piece = @board[row][col]
      if current_piece.nil?
        #check a spot in advance
        @tmp_board = @board.deep_dup
        @tmp_board[row][col] = @tmp_board[king_pos[0]][king_pos[1]]
        curr_neighbors = @tmp_board[row][col].move
        curr_neighbors.delete(@tmp_board[king_pos[0]][king_pos[1]])
        return false if curr_neighbors.any? {|v| v.nil?}
      elsif current_piece.color != color
         return true if current_piece.move_possible?([row, col],king_pos)
      end
    end
    false
  end

  def check_mate?(color)
      puts "Hello!"
      k = find_king(color)
      return @board[k[0]][k[1]].valid_moves(k).empty? && in_check?(color,k)
  end

  def find_king(color)
    (0...8).each do |i|
      (0...8).each do |j|
        next if @board[i][j].nil?
        return [i, j] if @board[i][j].type == 'K' && @board[i][j].color == color
      end
    end
    raise ArgumentError.new("really big problem!")
  end

  def move(start,end_pos)
    i,j = start
    piece = board[i][j]
    raise ArgumentError.new "wrong start coord" if piece.nil?
    possible = piece.move
    # p possible
    k,l = end_pos

    if possible.include?([k,l])
      @board[k][l] = piece
      @board[k][l].coord = [k, l]
      @board[i][j] = nil
    else
      raise ArgumentError.new "can't reach the end_pos"
    end
  end

  def possible_move?(start,end_pos)
    i,j = start
    piece = board[i][j]
    possible = piece.move
    possible.include?(end_pos)
  end
end

class Array
  def deep_dup
    # Argh! Mario and Kriti beat me with a one line version?? Must
    # have used `inject`...

    [].tap do |new_array|
      self.each do |el|
        new_array << (el.is_a?(Array) ? el.deep_dup : el)
      end
    end
  end
end
