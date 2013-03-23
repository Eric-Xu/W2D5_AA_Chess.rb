class Checkers
  # interacts with the user
  # asks each user to make a move until someone wins
  # print out the board after each move
  attr_accessor :board

  def initialize
  	@board = Board.new
  	@white_player = Player.new(@board, :W)
  	@black_player = Player.new(@board, :B)
  end

  def play
  	game_over = false

  	
  	@board.print_board

  	until game_over
  	  puts "White's turn"
  	  while true
  	  	@white_player.move_to_coord
  	  	break
  	  end

  	  @board.print_board
   	  # if any player runs out of possible moves
  	  # then game is over
  	  if @board.has_won?(:W)
  	  	print_message("White wins!")
  	  	break
  	  end

  	  puts "Black's turn"
  	  while true
  	  	@black_player.move_to_coord
  	  	break
  	  end

  	  @board.print_board
  	  if @board.has_won?(:B)
  	  	print_message("Black wins!")
  	  	break
  	  end
  	end
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

  #was called make_move in chess.rb
  def move_to_coord
  	while true
	  start_coord, end_coord = get_user_input
	  chosen_piece = @board[ start_coord[0], start_coord[1] ]

	  if chosen_piece == "___"  
	  	puts "Please select a non-empty coordinate"
        next
	  end

	  if chosen_piece.color != @color
	  	puts "Please select a piece of the correct color"
        next
      elsif chosen_piece.valid_move?(end_coord) == false
	  	puts "Invalid move! Please try again."
        next
      end

	  chosen_piece.move([ end_coord[0], end_coord[1] ])
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
	@board[ coord[0], 	  coord[1]     ] = self
	@board[ @position[0], @position[1] ] = "___"
	@position = coord
  end

  # called in Player.move_to_coord
  def valid_move?(end_coord)
    valid_moves = find_valid_moves
    puts "all valid_moves: #{valid_moves} being called from Piece. valid_move?"
    valid_moves.include?(end_coord) ? true : false
  end

  #called in Piece.valid_move?
  def find_valid_moves
  	all_valid_moves = []
  	step_trans, jump_trans = initialize_trans

  	step_trans.each do |trans|
  	  new_coord = [ @position[0] + trans[0], @position[1] + trans[1] ]
  	  # if 
  	  # add to valid moves
  	  if !object_of_same_color?(new_coord)
		all_valid_moves << new_coord
	  # if adjacent move is open
  	  elsif within_bounds?(new_coord) && immediate_space_empty?(new_coord) 
   	  	all_valid_moves << new_coord
  	  end
  	end

  	all_valid_moves
  end

  # called in Piece.find_valid_moves
  def initialize_trans
  	if @color == :W
  	  step_trans = [ [-1, -1], [-1, 1] ]
  	  jump_trans = [ [-2, -2], [-2, 2] ]
  	else # if player color == :B
  	  step_trans = [ [ 1, -1], [ 1, 1] ]
  	  jump_trans = [ [ 2, -2], [ 2, 2] ]
  	end
  	[step_trans, jump_trans]
  end

  # called in Piece.find_valid_moves
  def object_of_same_color?(coord)
  	target_coord = @board[ coord[0], coord[1]]
    if target_coord == "___"
      return false
    else #there's a piece there
      if @color == target_coord.color
        return true
      else
        return false
      end
    end
  end

  # called in Piece.find_valid_moves
  def immediate_space_empty?(coord)
  	target_coord = @board[ coord[0], coord[1]]
  	target_coord == "___" ? true : false
  end

  # called in Piece.find_valid_moves
  def within_bounds?(coord)
    if (coord[0] < 0) or (coord[0] > 7) or
        (coord[1] < 0) or (coord[1] > 7)
      return false
    else
      return true
    end
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

    # # test pieces
    # @board[4] [3] = Piece.new(:W, [4, 3], self)
    # @board[2] [3] = Piece.new(:B, [2, 3], self)
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

  # called by Checkers.play
  def has_won?(color)
    opp_color = nil
    if color == :W
      opp_color = :B
    else
      opp_color = :W
    end

    if !any_pieces_left?(opp_color)
      return true
    else
      return false
    end
  end

  def any_pieces_left?(color)
    pieces = find_pieces(color)
    if !pieces.empty?
      true
    else
      false
    end
  end

  def find_pieces(color)
    all_pieces = []
    @board.flatten.each do |piece|
      if !piece.nil? and piece != "___"
        if piece.color == color
          all_pieces << piece
        end
      end
    end

    all_pieces
  end
end
