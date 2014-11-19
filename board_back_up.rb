# encoding: utf-8
require_relative 'pieces.rb'
require 'colorize'
class Board
  def initialize(fill = true)
    @board = Array.new(8) {Array.new(8,nil)}
    fill_board if fill
  end

  attr_accessor :board
  def fill_board
    # [0, 2].each do |i|
    #     type = "RNB"
    #   [0, 2].each do |j|
    #       @board[0][j] = SlidingPiece.new(type[j], self, 'black', [0, j])
    #       @board[0][-1 - j] = SlidingPiece.new(type[j], self, 'black', [0, -1 - j])
    #       @board[7][j] = SlidingPiece.new(type[j], self, 'white', [7, j])
    #       @board[7][-1 -j] = SlidingPiece.new(type[j], self, 'white', [7, -1 - j])
    #   end
    # end
    #
    # @board[0][1] = SteppingPiece.new("N", self, 'black', [0, 1])
    # @board[0][6] = SteppingPiece.new("N", self, 'black', [0,6])
    # @board[7][1] = SteppingPiece.new("N", self, 'white', [7,1])
    # @board[7][6] = SteppingPiece.new("N", self, 'white', [7,6])
    #
    # @board[0][3] = SlidingPiece.new("Q", self, 'black', [0,3])
    # @board[0][4] = SteppingPiece.new("K", self, 'black', [0,4])
    # @board[7][3] = SlidingPiece.new("Q", self, 'white', [7,3])
    # @board[7][4] = SteppingPiece.new("K", self, 'white', [7,4])
    #
    # (0...8).each do |j|
    #     @board[1][j] = Pawn.new('P', 'black', self, [1,j])
    #     @board[6][j] = Pawn.new('P', 'white', self, [6,j])
    # end
    [0, 2].each do |i|
        type = "RNB"
      [0, 2].each do |j|
          self[[0,j]] = SlidingPiece.new(type[j], self, 'black', [0, j])
          self[[0, -1 - j]] = SlidingPiece.new(type[j], self, 'black', [0, -1 - j])
          self[[7, j]] = SlidingPiece.new(type[j], self, 'white', [7, j])
          self[[7, -1 -j]] = SlidingPiece.new(type[j], self, 'white', [7, -1 - j])
      end
    end

    self[[0, 1]] = SteppingPiece.new("N", self, 'black', [0, 1])
    self[[0, 6]] = SteppingPiece.new("N", self, 'black', [0,6])
    self[[7, 1]] = SteppingPiece.new("N", self, 'white', [7,1])
    self[[7, 6]] = SteppingPiece.new("N", self, 'white', [7,6])

    self[[0, 3]] = SlidingPiece.new("Q", self, 'black', [0,3])
    self[[0, 4]] = SteppingPiece.new("K", self, 'black', [0,4])
    self[[7, 3]] = SlidingPiece.new("Q", self, 'white', [7,3])
    self[[7, 4]] = SteppingPiece.new("K", self, 'white', [7,4])

    (0...8).each do |j|
        self[[1, j]] = Pawn.new('P', 'black', self, [1,j])
        self[[6, j]] = Pawn.new('P', 'white', self, [6,j])
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
            string += el.type.to_s.colorize(el.color.to_sym)
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
    neighbors = self[king_pos].move
    #neighbors = board[king_pos[0]][king_pos[1]].move
    neighbors.each do |v|
      unless @board[v[0]][v[1]].nil?
        if @board[v[0]][v[1]].color == color
          neighbors.delete(v)
        else
          return true if possible_move?(v,king_pos)
        end
      end
    end
    neighbors.each do |v|
        dir = []
        new_move = king_pos.dup
        dir[0] = v[0] - king_pos[0]
        dir[1] = v[1] - king_pos[1]
        new_move[0] += dir[0]
        new_move[1] += dir[1]
        while new_move[0].between?(0,7) && new_move[1].between?(0,7)
          if @board.board[new_move[0]][new_move[1]].nil?
            new_move[0] += dir[0]
            new_move[1] += dir[1]
          else
            if tmp_color != @board.board[new_move[0]][new_move[1]].color
               return true if possible_move?(new_move, king_pos)
            end
            break
          end
        end
    end
    return false
  end

  def check_mate?(color)
      king_pos = find_king(color)
      neighbors = board[king_pos[0]][king_pos[1]].move
      res = []
      neighbors.each do |v|
        next if @board[v[0]][v[1]].color == color
        temp_board = self.deep_dup
        p "#{king_pos} #{v}"
        temp_board.move(king_pos.dup,v)
        res << temp_board[v].board.in_check?(color)
      end
      return true if !res.empty? && res.all? {|d| d == true}
      return false
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
    piece = @board[i][j]
    raise ArgumentError.new "wrong start coord" if piece.nil?
    possible = piece.move
     p possible
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

  def deep_dup
    result = Board.new(false)

    pieces.each do |piece|
      result[piece.coord] = piece.dup(result)
    end

    result
  end

  def pieces
    @board.flatten.compact
  end

  def [](pos)
    x, y = pos
    self.board[x][y]
  end

  def []=(pos, value)
    x,y = pos
    self.board[x][y] = value
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
