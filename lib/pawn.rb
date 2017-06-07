require_relative 'slideable'
require_relative 'piece'

class Pawn < Piece

  def initialize(color, starting_pos, board)
    @at_start_row = true
    super
  end

  def moves
    poss_moves = []
    move_diffs.each.with_index do |diff,i|
      new_pos = [@current_pos[0] + diff[0], @current_pos[1] + diff[1]]
      next unless new_pos.all? { |coord| coord.between?(0,7) }
      if i == 0 && @board[new_pos].class == NullPiece
        poss_moves << new_pos
      elsif i == 1 && @board[new_pos].class == NullPiece && at_start_row? && @board[[(@current_pos[0] + move_diffs[0][0]),new_pos[1]]].class == NullPiece
        poss_moves << new_pos
      elsif i > 1 && @board[new_pos].color != self.color && @board[new_pos].class != NullPiece
        poss_moves << new_pos
      end
    end
    poss_moves.select { |move| move.all? { |coord| coord.between?(0,7) } }

  end

  protected

  def move_diffs
    case @color
    when :white
      [[-1, 0],[-2, 0],[-1,-1],[-1,1]]
    when :black
      [[1, 0],[2, 0],[1,-1],[1,1]]
    end
  end

  def at_start_row?
    case color
    when :white
      true if @current_pos[0] == 6
    when :black
      true if @current_pos[0] == 1
    else
      false
    end
  end

  def forward_dir
  end

  def forward_steps
  end

  def side_attacks
  end

end
