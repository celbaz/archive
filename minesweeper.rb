class Tile
   def initialize
      @value = "*"
   end

   def set(value)
     @value = value
   end

   attr_reader :value
end

class Board
    def initialize(size, bombs)
        @board = Array.new(size)  {Array.new(size){Tile.new}}
        @size = size
        @bomb_positions = spawn_bombs(bombs)
        @remaining_tiles = size*size
        @checked_tiles = []
    end

    def display
        puts "-"*(@size*2 + 1)
        @board.each do |line|
          string = "|"
          line.each do |tile|
            string += "#{tile.value}" + "|"
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

    def reveal_tile(coords)
      return nil if bomb_here?(coords)
      queue = [coords]
      until queue.empty?
        curr_coord = queue.pop
        next if @checked_tiles.include?(curr_coord)
        @checked_tiles << curr_coord
        @remaining_tiles -= 1
        current_neighbors = neighbors(curr_coord)
        current_bomb_count = bomb_count(current_neighbors)
        if current_bomb_count == 0
          queue += current_neighbors
          self[curr_coord].set("X")
        else
          # puts "#{current_bomb_count} BC"
          self[curr_coord].set(current_bomb_count)
        end
      end
      true
    end

    MOVES =[
      [0,1],
      [0,-1],
      [1,0],
      [-1,0],
      [1,1],
      [-1,-1],
      [-1,1],
      [1,-1]
    ]
    def neighbors(current_tile)
        result = []
        MOVES.each do |coords|
          x = coords.first + current_tile.first
          y = coords.last + current_tile.last
          if x.between?(0,@size-1) && y.between?(0,@size-1)
            result << [x,y]
          end
        end
        result
    end

    def bomb_count(neighbor_arr)
      result = 0
      neighbor_arr.each do |neighbor|
        result += 1 if bomb_here?(neighbor)
      end
      result
    end

    def bomb_here?(coords)
      @bomb_positions.include?(coords)
    end
    attr_reader :bomb_positions

    def [](co)
      @board[co.first][co.last]
    end

    def win?
      @remaining_tiles == @bomb_positions.count
    end

end

class Game
    def initialize(size= 9, bombs= 3)
      @gameboard = Board.new(size,bombs)
      @size = size
    end

    attr_reader :gameboard

    def run
        until @gameboard.win?
          @gameboard.display
          puts "Please select a tile in the format [0..#{@size-1},0..#{@size-1}]"
          input = get_move
          puts "Reveal or flag?(r/f)"
          type = gets.chomp
          break if @gameboard.reveal_tile(input).nil?
        end
        return "YOU WIN!!!" if @gameboard.win?
        return "YOU LOSE!!"
    end

    def get_move
        input = gets.chomp.split(",")
        [input[0].to_i,input[1].to_i]
    end

end
