class Piece
  attr_reader :print, :pos
  def initialize(pos, color, board)
    @board = board
    @promoted = false
    @pos = pos
    @color = color
    @print = (color == :white) ? '♙' : '♟'
  end

  BLACK_DIR = [[-1,-1], [1, -1]]
  WHITE_DIR = [[1,1], [-1,1]]


  def perform_slide
    if moves_possible_s.include?(end_pos)
      @board[@pos] = nil
      @pos = end_pos
      @board[end_pos] = self
      promote?
      return true
    else
      return false
    end
  end

  def directions
    if @promoted
      options = BLACK_DIR + WHITE_DIR
    else
      options = (color == :white) ? WHITE_DIR : BLACK_DIR
    end
  end

  def moves_possible_s
    result = []
    directions.each do |direc|
      temp = @pos.dup
      temp[0] += direc[0]
      temp[1] += direc[1]
      result << temp if @board[temp].nil?
    end
    result
  end

  def moves_possible_j
    result = []
    directions.each do |direc|
      temp = @pos.dup
      temp[0] += direc[0]
      temp[1] += direc[1]
      if @board[temp].color != @color
        result << temp.dup
        temp[0] += direc[0]
        temp[1] += direc[1]
        unless @board[temp].nil?
          result.pop
        else
          result << temp.dup
        end
      end
    end
    result
  end

  def perform_jump(end_pos)
    if moves_possible_j.include?(end_pos)
      shift = []
      shift[0] = (end_pos[0] - @pos[0]) /2
      shift[1] = (end_pos[1] - @pos[1]) /2
      @board[[ @pos[0] + shift[0], @pos[1] + shift[1] ]] = nil
      @board[@pos] = nil
      @pos = end_pos
      @board[end_pos] = self
      promote?
    else
      raise "Move is not possible."
    end
  end

  def perform_moves!(move_sequence)
    if valid_move_seq?
      if move_sequence.size == 1
        unless perform_slide(move_sequence.first)
          perform_jump(move_sequence.first)
        end
      elsif move_sequence.size > 1
        move_sequence.each do |m|
          perform_jump(m)
      end
    end
  end

  def valid_move_seq?(move_sequence)
    begin
      new_board = @board.dup

      if move_sequence.size == 1
        unless new_board[@pos].perform_slide(move_sequence.first)
          new_board[@pos].perform_jump(move_sequence.first)
        end
      elsif move_sequence.size > 1
        new_board[@pos].move_sequence.each do |m|
          new_board[@pos].perform_jump(m)
        end
      end
    rescue
      return false
    end
    return true
  end

  def promote?
    return nil if @promoted
    if (@color == :black && pos[1] == 0) ||
       (@color == :white && pos[1] == 9)
      @print = (@color == :white) ? '♔' : '♚'
      @promoted = true
    end
  end

  def dup(board)
    self.class.new(@pos.dup, @color, board)
  end
end
