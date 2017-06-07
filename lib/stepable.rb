module Stepable

  def moves
    poss_moves = []
    self.move_diffs.each { |diff| poss_moves << [@current_pos[0] + diff[0], @current_pos[1] + diff[1]] }
    poss_moves.select! do |move|
      next false unless move.all? { |coord| coord.between?(0,7) }
      next false if board[move].color == self.color
      true
    end
    poss_moves
  end

  private

  def move_diffs
    #Defined in Piece
  end
end
