class Tile
   def initialize(board)
      @board
      @value = "*"
   end


   def set(value)
     @value = value
   end

   def reveal(coords)
     if @board.bomb_positions

   end

   def neighbors(coords)

   end

   def neighbor_bomb_count(coords)

   attr_reader :value
end

class Board
    def initialize(size, bombs)
        @board = Array.new(size)  {Array.new(size,Tile.new(self))}
        @size = size
        @bomb_positions = spawn_bombs(bombs)
    end

    def display
        puts "-"*(@size*2 + 1)
        @board.each do |line|
          string = "|"
          line.each do |tile|
            string += tile.value + "|"
          end
          puts string
          puts "-"*(@size*2 + 1)
        end
    end

    def spawn_bombs(number)
      bombs = []
      until bombs.size == number
        b = [rand(0..@size - 1), rand(0..@size - 1)]
        bombs << b unless bombs.include?(b)
      end
      bombs
    end

    attr_reader :bomb_positions


end

class Game
    def initialize(size= 9, bombs= 3)
      @gameboard = Board.new(size,bombs)
      @size = size
    end

    def run
        until bomb_exploded? || win?
          @gameboard.display
          puts "Please select a tile in the format [0..#{@size-1},0..#{@size-1}]"
          input = gets.chomp.split(",")

        end
    end
    def get_move
        input = gets.chomp.split(",")
        [input[0],input[1]]
    end
end
