class Checkers
  # interacts with the user
  # asks each user to make a move until someone wins
  # print out the board after each move
  attr_accessor :board

  def initialize
  	@board = Board.new
  end

  def play
  	game_over = false
  	
  	player1 = Player.new(@board, :W)
  	player2 = Player.new(@board, :B)
  	
  	@board.print_board

  	until game_over
  	  puts "White's turn"

  	  while true
  	  	player1.make_move
  	  	break
  	  end

  	  @board.print_board
  	  puts "Black's turn"

  	  while true
  	  	player2.make_move
  	  	break
  	  end

  	  @board.print_board
  	  #test
  	  game_over = true
  	end

  	print_message("Game over")
  end

  def print_message(message)
	puts ""
	puts message
	puts ""  	
  end
end

class Player
  # pick a piece
  # move a piece
  attr_reader :color

  def initialize(board, color)
  	@board = board
  	@color = color
  end

  def make_move
  	while true
	  start_coord, end_coord = get_user_input

	  # REPLACED: piece = @board.board[ start_coord[0] ][ start_coord[1] ]
	  piece = @board[ start_coord[0], start_coord[1] ]
	  #test
	  puts "piece from inside Player.make_move: #{piece}"
	  
	  piece.move([ end_coord[0], end_coord[1] ])
	  #test
  	  break
  	end
  end

  # prompt player for starting and ending coordinates
  def get_user_input
    puts "Enter coord of piece to move:"
    start_coord = read_keyboard_input
    puts "Enter destination coord:"
    end_coord = read_keyboard_input

    return start_coord, end_coord
  end

  # format player input 
  def read_keyboard_input
    gets.chomp.split(" ").map! { |coord| coord.to_i }
  end
end

class Piece
  # know the valid squares where it can jump to 
  # know the boundaries of the board

  attr_reader :color, :board
  attr_accessor :position

  def initialize(color, position, board)
  	@position = position #[0, 0]
  	@color = color
  	@board = board
  end
  
  #was called make_move in chess.rb
  def move(coord)
  	#test
	puts "printing #{coord} from the Piece.move method"
	@board[ coord[0], 	  coord[1]     ] = self
	@board[ @position[0], @position[1] ] = "___"
	@position = coord
  end

end

class Board
  # build the board
  # populate the board with pieces
  # show the board
  # check after each move if all pieces have been removed; aka someone wins
 
  def [](row, col)
  	@board[row][col]
  end

  def []=(row, col, value)
  	@board[row][col] = value  	
  end

  def initialize
  	@board = [ [], [], [], [], [], [], [], [] ]
  	create_initial_board
  end

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
      @board[coord[0]] [coord[1]] = Piece.new(:B, coord, self)
    end

  	# populate white pieces
  	white_start_coords = [ [5, 0], [5, 2], [5, 4], [5, 6], 
  						   [6, 1], [6, 3], [6, 5], [6, 7], 
  						   [7, 0], [7, 2], [7, 4], [7, 6] ]
    white_start_coords.each do |coord|
      @board[coord[0]] [coord[1]] = Piece.new(:W, coord, self)
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
          if piece.color == :W
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
