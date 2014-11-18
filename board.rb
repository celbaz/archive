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
          @board[0][j] = SlidingPiece.new(type[i], self, 'black', [0, j])
          @board[0][-1 - j] = SlidingPiece.new(type[i], self, 'black', [0, -1 - j])
          @board[7][j] = SlidingPiece.new(type[i], self, 'white', [7, j])
          @board[7][-1 -j] = SlidingPiece.new(type[i], self, 'white', [7, -1 - j])
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

  def in_check?(color)
    king_pos = find_king(color)
    queue = []
    i, j = king_pos
    neighbor_king = @board[i][j].move
    neighbor_king.each do |neighbor|
      row, col = neighbor
      current_piece = @board[row][col]
      if current_piece.nil?
         queue << current_piece
      elsif current_piece.color != color
         return true if move_possible?([row, col],king_pos)
      end
    end

    until queue.empty?
        dir = queue.shift
        dir[0], dir[1] = dir[0] - king_pos[0], dir[1] - king_pos[1]
        next_tile = king_pos
        begin
          next_tile[0] += dir[0]
          next_tile[1] += dir[1]
          unless @board[next_tile[0]][next_tile[1]].nil?
              if @board[next_tile[0]][next_tile[1]].color != color
                return true if move_possible?(next_tile, king_pos)
              end
                break
          end
        #if next_tile not my color then check if move possible else break
        end until next_tile[0].between?(0,7) && next_tile[1].between?(0,7)


    end
    false
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
    if possible.include?(end_pos)
      board[end_pos[0]][end_pos[1]] = piece
      board[i][j] = nil
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
