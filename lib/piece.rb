require_relative 'stepable'
require_relative 'slideable'
require 'colorize'

class Piece

  attr_reader :display_symbol, :color
  attr_accessor :board, :current_pos

  def initialize(color, starting_pos, board)
    @color = color
    @symbol = symbol
    @current_pos = starting_pos
    @board = board
  end

  def to_s
    SYMBOLS[@symbol].colorize( @color )#in specific piece
  end

  def empty?
    false
  end

  SYMBOLS = {Rook: " ♖ ",
    Knight: " ♘ ",
    Bishop: " ♗ ",
    Queen: " ♕ ",
    King: " ♔ ",
    Pawn: " ♙ "
  }

  def symbol
    self.class.to_s.to_sym
  end

  def valid_moves
    moves.reject do |move|
      move_into_check?(move)
    end
  end

  private

  def move_into_check?(to_pos)
    temp_board = @board.dup
    temp_board.move_piece!(@current_pos, to_pos)
    temp_board.in_check?(@color)
  end
end
