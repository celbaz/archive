require_relative 'board.rb'

class Game

  def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
      @board = Board.new
  end

  def run
    play_turn
    rescue e
      retry play_turn
    end
  end

end



class Player
    def play_turn
    end
end

class HumanPlayer < Player

    def play_turn
        #gets
        #error-checks

    end

end
