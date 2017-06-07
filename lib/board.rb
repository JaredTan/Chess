require_relative 'piece'
require_relative 'nullpiece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'

class Board
  attr_accessor :grid

  def initialize(grid=Array.new(8) {Array.new(8)})
    @grid = grid
    @null_piece = NullPiece.send :new
    make_starting_grid if grid == Array.new(8) {Array.new(8)}
  end

  ROW = %w(Rook Knight Bishop Queen King Bishop Knight Rook)

  def make_starting_grid
    (0..7).each do |row|
      (0..7).each do |col|
        if row == 1
          @grid[row][col] = Pawn.new(:black,[row,col], self)
        elsif row == 6
          @grid[row][col] = Pawn.new(:white,[row,col], self)
        elsif row == 0
          @grid[row][col] = eval(ROW[col]).new(:black,[row,col], self)
        elsif row == 7
          @grid[row][col] = eval(ROW[col]).new(:white,[row,col], self)
        else
          @grid[row][col] = @null_piece
        end
      end
    end
  end

  def [] pos
    x, y = pos
    @grid[x][y]
  end

  def []= pos, piece
    x, y = pos
    @grid[x][y] = piece
  end

  def dup
    duped_grid = dup_grid(@grid)
    new_board = Board.new(duped_grid)
    new_board.grid.each do |row|
      row.each do |piece|
        piece.board = new_board
      end
    end
    new_board
  end

  def dup_grid(grid)
    duped_grid = []
    #return grid unless grid.is_a? Array
    grid.each do |el|
      if is_a? Array
        duped_grid << dup_grid(el)
      else
        duped_grid << el.dup
      end
    end
    duped_grid
  end

  def move_piece(color, from_pos, to_pos)
    raise "null" if self[from_pos].class == NullPiece
    raise "color" unless self[from_pos].color == color
    piece = self[from_pos]
    moves = piece.valid_moves
    raise "invalid move" unless moves.include?(to_pos)
    move_piece!(from_pos, to_pos)
  end

  def move_piece!(from_pos, to_pos)
    self[to_pos] = self[from_pos]
    self[from_pos] = @null_piece
    self[to_pos].current_pos = to_pos
  end

  def in_bounds?(pos)
    pos.all? { |coord| (0..7).cover?(coord) }
  end

  def in_check?(color)
    enemy_moves = []
    @grid.each do |row|
      row.each do |piece|
        if piece.color != color && piece.color != nil
          enemy_moves += piece.moves
        end
      end
    end
    return true if enemy_moves.include?(find_king(color))
    false
  end

  def checkmate?(color)
    all_valid_moves = []
    @grid.each do |row|
      row.each do |piece|
        if piece.color == color
          all_valid_moves += piece.valid_moves
        end
      end
    end
    return true if in_check?(color) && all_valid_moves.empty?
    false
  end

  def stalemate?(color)
    all_valid_moves = []
    @grid.each do |row|
      row.each do |piece|
        if piece.color == color
          all_valid_moves += piece.valid_moves
        end
      end
    end
    return true if !in_check?(color) && all_valid_moves.empty?
    false
  end

  def find_king(color)
    @grid.each do |row|
      row.each do |piece|
        return piece.current_pos if piece.color == color && piece.class == King
      end
    end
    nil
  end
end
