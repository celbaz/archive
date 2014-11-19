require_relative 'board.rb'

class Game

  def initialize(player1, player2)
      @player1 = player1
      @player2 = player2
      @board = Board.new
  end

  def run
    begin
      break if @board.check_mate?('black')
      @board.display
      begin
        spot = @player1.play_turn
        @board.move(spot[0],spot[1])

      rescue ArgumentError => e
        puts "ERROR: #{e.message}"
        puts "re-select start point and destination point, player 1"
        retry
      end

      break if @board.check_mate?('white')

      @board.display
      begin
        spot = @player2.play_turn
        @board.move(spot[0],spot[1])
      rescue ArgumentError => e
        puts "ERROR: #{e.message}"
        puts "re-select start point and destination point, player 2"
        retry
      end
    end while true
    puts "BROKE"
  end


end



class Player
    def play_turn
    end
end

class HumanPlayer < Player

    def play_turn
        puts "Please Select a piece to move.(format: 12)"
        #input =  gets.chomp.split("")

        input = gets.chomp
        pos_start = []
        input.split('').each do |i|
          pos_start << Integer(i)
        end

        #input.map { |e|  e.to_i }
        puts "Select destination. (format: 12)"
        # dest =  gets.chomp.split("")

        input = gets.chomp
        pos_dest = []
        input.split('').each do |i|
          pos_dest << Integer(i)
        end
        #dest.map { |e|  e.to_i }
        return [pos_start, pos_dest]
    end


end


if __FILE__ == $PROGRAM_NAME
  p1 = HumanPlayer.new
  p2 = HumanPlayer.new
  g  = Game.new(p1,p2)
  g.run

end
