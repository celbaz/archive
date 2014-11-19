require_relative 'board.rb'

class Game

  def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
      @board = Board.new
  end

  def run
    begin
      break if @board.check_mate?(:white)
      @board.display
      begin
        input = @player1.play_input

        p @board[input].dup(@board).move

        dest = @player1.play_dest
        @board.move(input,dest)

      rescue ArgumentError => e
        puts "ERROR: #{e.message}"
        puts "re-select start point and destination point, player 1"
        retry
      end

      break if @board.check_mate?(:black)

      @board.display
      begin
        input = @player2.play_input
        p @board[input].dup(@board).move
        dest = @player2.play_dest
        @board.move(input,dest)
      rescue ArgumentError => e
        puts "ERROR: #{e.message}"
        puts "re-select start point and destination point, player 2"
        retry
      end
    end while true
    if @board.check_mate?(:white)
      puts "WHITE LOSES!"
    else
      puts "BLACK LOSES!"
    end
  end


end



class Player
    def play_turn
    end
end

class HumanPlayer < Player

    def play_input
      puts "Please Select a piece to move.(format: 12)"
      input = gets.chomp
      pos_start = []
      input.split('').each do |i|
        pos_start << Integer(i)
      end

      pos_start
    end

    def play_dest
      puts "Select destination. (format: 12)"

      input = gets.chomp
      pos_dest = []
      input.split('').each do |i|
        pos_dest << Integer(i)
      end
      pos_dest
    end


end


if __FILE__ == $PROGRAM_NAME
  p1 = HumanPlayer.new
  p2 = HumanPlayer.new
  g  = Game.new(p1,p2)
  g.run

end
