class Piece
  def initialize(type, board, color, coord)#coord
    @coord = coord
    @color = color
    @type = type
    @board = board
  end
  attr_accessor :type, :color, :coord, :board

  def move
  end

  def opponent_color?

  end

  def dup(board = nil) # split into classes , use symbols instead of strings get rid of type
      dupped_piece = self.class.new(type, board, color, coord.dup)
  end

end

class SlidingPiece < Piece
  DIAG = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  UPDOWN = [[0, 1], [0, -1], [1, 0], [-1, 0]]
    def initialize(type, board, color, coord)
        super(type, board, color, coord)
        @type = type
    end

    def move
      positions = []
      if type == "R"
        return slide_move(UPDOWN)
      elsif type =="B"
        return slide_move(DIAG)
      else
        r_move = slide_move(UPDOWN)
        b_move = slide_move(DIAG)
        return r_move.concat(b_move)
      end
    end

    def slide_move(const)
      result = []
      count = 0
      tmp_coord = coord.dup
      tmp_color = @board.board[tmp_coord[0]][tmp_coord[1]].color
      while count < 4
        new_move = coord.dup
        # p "new_move #{new_move}"
        new_move[0] = new_move[0] + const[count][0]
        new_move[1] = new_move[1] + const[count][1]
        # p "count #{count} new_move #{new_move} const #{const[count]}"
        while new_move[0].between?(0,7) && new_move[1].between?(0,7)
          if @board.board[new_move[0]][new_move[1]].nil?
            result << new_move.dup
            # p result
            new_move[0] += const[count][0]
            new_move[1] += const[count][1]
          else
            result << new_move.dup if tmp_color != @board.board[new_move[0]][new_move[1]].color
            break
          end
        end
        count += 1
      end
      result
    end
end

class SteppingPiece < Piece
    KNIGHT = [[-2,-1],[-1,-2],[-2,1], [2,-1],[-1,2],[2,1],[1,2],[1,-2]]
    KING = [[0,1] ,[0,-1], [1,0],[-1,0], [1,-1],[-1,1], [1,1], [-1,-1]]
    def initialize(type, board, color, coord)
        super(type, board, color, coord)
        @type = type
    end


    def move
      type == "K" ? slide_move(KING) : slide_move(KNIGHT)
    end

    def slide_move(const)
      result = []
      count = 0
      new_move = []
      const.each do |shift|
        new_move[0] = shift[0] + coord[0]
        new_move[1] = shift[1] + coord[1]
        if new_move[0].between?(0,7) && new_move[1].between?(0,7)

          if @board.board[new_move[0]][new_move[1]].nil?
              result << new_move
          elsif @board.board[new_move[0]][new_move[1]].color != self.color
            result << new_move
          end
        end
      end
      result
    end

    def valid_moves(coord) #check again upon implemetning game
        result = move
        result.each do |el|
          result.delete(el) if @board.in_check?(self.color,coord)
        end
        result
    end

end

class Pawn < Piece
  def initialize(type, board, color, coord)
    super(type, board, color, coord)
    @first_move = true
    @type = type
  end

  def move
    result = []

    move_dia_w = [[-1, -1], [1, -1]]
    move_up_w = [[ -2,0], [-1, 0]]
    move_dia_b = [[1, -1], [1, 1]]
    move_up_b = [[2,0], [1,0]]


     @color == 'white' ? move_up = move_up_w : move_up = move_up_b
     move_up.shift  unless @first_move
     @first_move = false
      move_up.size.times do |i|
        #p "#{i} #{@coord}"
        new_move = [@coord[0] + move_up[i][0], @coord[1] + move_up[i][1]]
        #p new_move
        result << new_move if @board[new_move].nil?
      end
      p "UPMOVES: #{result}"

      @color == 'white' ? move_dia = move_dia_w : move_dia = move_dia_b
      (0..1).each do |i|
        new_move = [@coord[0] + move_dia[i][0], @coord[1] + move_dia[i][1]]
        unless @board.board[new_move[0]][new_move[1]].nil?
          result << new_move if @color != @board.board[new_move[0]][new_move[1]].color
        end
      end
    result
  end
end
