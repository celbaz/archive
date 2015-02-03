require_relative 'board.rb'

class Game
  attr_accessor :board
  def initialize(p1 = HumanPlayer.new, p2 = HumanPlayer.new(:black))
      @player1 = p1
      @player2 = p2
      @board = Board.new
      @currentplayer = @player1
  end

  def run
      begin
        @board.display
        piece = @currentplayer.make_choice
        @board[piece].turn?(@currentplayer.color)
        puts "you can move this piece to these spots:"
        p @board[piece].moves_possible_s + @board[piece].moves_possible_j
        dest = @currentplayer.make_choice #doesn't handle multiple moves
        @board[piece].perform_moves!([dest])
        @currentplayer = (@currentplayer == @player1) ? @player2 : @player1
      rescue PieceError => e
          puts e.message
        retry
      rescue BoardError => e
        puts e.message
        retry
      end until lose?(@currentplayer.color)
      puts "GAME OVER"
  end

  def lose?(color)
      @board.pieces_left(color) == 0
  end
end


class Player
    attr_reader :color
    def initialize(color = :white)
        @color = color
    end
    def make_choice

    end
end


class HumanPlayer < Player
    def make_choice
        puts "Please choose a position (i.e. 20)"
        input = gets.chomp
        [input[0].to_i,input[1].to_i]
    end

end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.run

end
