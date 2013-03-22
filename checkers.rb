class Checkers
  # interacts with the user
  # asks each user to make a move until someone wins
  # print out the board after each move
end

class Piece
  # know the valid squares where it can jump to 
  # know the boundaries of the board
end

class Board
  # build the board
  # populate the board with pieces
  # show the board
  # check after each move if all pieces have been removed; aka someone wins
  attr_accessor :board

  def initialize
  	@board = [ [], [], [], [], [], [], [], [] ]
  end

  # # useful?
  # def [](row, col)
  # 	@board[row][col]
  # end

  # def []=(row, col, value)
  # 	@board[row][col] = value  	
  # end

  def create_initial_board
  	# populate underscores for blank spaces
  	(0..7).each do |row|
  	  (0..7).each do |col|
  	  	@board[row][col] = "___"
  	  end
  	end

  	# populate black pieces
  	black_start_coords = [ [0, 1], [0, 3], [0, 5], [0, 7], 
  						   [1, 0], [1, 2], [1, 4], [1, 6], 
  						   [2, 1], [2, 3], [2, 5], [2, 7] ]
    black_start_coords.each do |coord|
      @board[coord[0]] [coord[1]] = "B"
    end

  	# populate white pieces
  	white_start_coords = [ [5, 0], [5, 2], [5, 4], [5, 6], 
  						   [6, 1], [6, 3], [6, 5], [6, 7], 
  						   [7, 0], [7, 2], [7, 4], [7, 6] ]
    white_start_coords.each do |coord|
      @board[coord[0]] [coord[1]] = "W"
    end
  end

  def print_board
    puts "    0   1   2   3   4   5   6   7"
    puts "" #empty line
    @board.each_with_index do |row, i|
      output_row = row.map do |piece|
        if piece == "___"
          "___"
        else
          if piece == "W"
            " W "
          else
            " B "
          end
        end
      end
      puts "#{i}  #{output_row.join(" ")}"
      puts "" #empty line
    end
    nil
  end
end

class Player
  # pick a piece
  # move a piece
end