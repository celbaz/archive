class Piece
  def initialize(board,coord)
    @board = board
    @coord = coord
  end

  def move
  end
end

class SlidingPiece < Piece
    def initialize(type, board)
        super(board)
        @type = type
        init_move(type)
    end

    def move
      positions = []
      if type == "R"
        positions = r_move
      elsif type =="B"
        postions = b_move
      else
        postions = r_move + b_move
      end
      positions
    end

    def b_move

    end

    def r_move

    end
end

class SteppingPiece < Piece

end

class Pawn < Piece

end
