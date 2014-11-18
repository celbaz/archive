require_relative 'board.rb'

class Game

  def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
      @board = Board.new
  end

  def run
    until @board.check_mate?('white') || @board.check_mate?('black')
      @board.display
      spot = @player1.play_turn
      @board.move(spot[0],spot[1])
      @board.display
      spot = @player2.play_turn
      @board.move(spot[0],spot[1])

      #add player 2 turn
      #user chooses a piece
      #we return all valid moves
      #picks a move
      #else choose a new piece
    end
    # rescue e
    #   retry play_turn
    # end
  end

end



class Player
    def play_turn
    end
end

class HumanPlayer < Player

    def play_turn
        puts "Please Select a piece to move."
        input =  gets.chomp.split("")
        #input.map { |e|  e.to_i }
        puts "Select destination."
        dest =  gets.chomp.split("")
        #dest.map { |e|  e.to_i }
        return [input, dest]
    end


end
