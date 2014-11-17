class Tile
   def initialize(board)
      @board
      @value = "*"
   end
   attr_reader :value
   def set(value)
     @value = value
   end
end

class Board
    def initialize(size = 9)
        @board = Array.new(size)  {Array.new(size,Tile.new(self))}
        @size = size
    end

    def display
        puts "-"*(@size*2 + 2)
        @board.each do |line|
          string = "|"
          line.each do |tile|
            string += tile.value + "|"
          end
          puts string
          puts "-"*(@size*2 + 2)
        end
    end
end

class Game

end
