class Piece
  def initialize(type, board, color)
    @board = board
    @coord = nil
    @color = color
    @type = type
  end
  attr_reader :type

  def coord=(coord)
      @coord = coord
  end

  def move
  end

  def opponent_color?

  end


end

class SlidingPiece < Piece
  DIAG = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  UPDOWN = [[0, 1], [0, -1], [1, 0], [-1, 0]]
    def initialize(type, board, color)
        super(type, board, color)
        @type = type
    end

    def move
      positions = []
      if type == "R"
        positions = slide_move(DIAG)
      elsif type =="B"
        postions = slide_move(UPDOWN)
      else
        postions = slide_move(UPDOWN) + slide_move(DIAG)
      end
      positions
    end

    def slide_move(const)
      result = []
      count = 0
      new_move = coord
      while count < 4
        new_move[0] +=  const[count][0]
        new_move[1] +=  const[count][1]
        if new_move[0].between?(0,7) && new_move[1].between?(0,7)
          result << new_move
          if board[coord].occupied? # we need to take into account color
            count += 1
            new_move = coord
            result.pop if board[coord].color == result.last.color
          end
        else
          new_move = coord
          count += 1
        end
      end
      result
    end
end

class SteppingPiece < Piece
    KNIGHT = [[-2,-1],[-1,-2],[-2,1], [2,-1],[-1,2],[2,1],[1,2],[1,-2]]
    KING = [[0,1] ,[0,-1], [1,0],[-1,0], [1,-1],[-1,1], [1,1], [-1,-1]]
    def initialize(type, board, color)
        super(type, board, color)
        @type = type
    end


    def move
      type == "K" ? slide_move(KING) : slide_move(KNIGHT)
    end

    def slide_move(const)
      result = []
      count = 0
      CONST.each do |shift|
        new_move[0] = shift[0] + coord[0]
        new_move[1] = shift[1] + coord[1]
        if new_move[0].between?(0,7) && new_move[1].between?(0,7)
          result << new_move unless board[coord].color == result.last.color
        end
      end
      result
    end

end

class Pawn < Piece
  def initialize(type, color, board)
    super(type, board, color)
    @first_move = true
    @type = type
  end

  def move
    move_dia = [[-1, 1], [1, 1]]
    move_up = [[0, 2], [0, 1]]


    result = []

    (0..1).each do |i|
      new_move = [coord[0] + move_up[i][0], coord[1] + move_up[i][1]]
      result << new_move if board[coord] == nil
    end

    move_up.shift  if @first_move
    @first_move = false

    (0..1).each do |i|
      new_move = [coord[0] + move_dia[i][0], coord[1] + move_dia[i][1]]
      result << new_move if opponent_color?
    end

  end
end
