module Slideable
  DIAG = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
  HOR = [[0, 1], [0, -1], [1, 0], [-1, 0]]

  def moves
    move_dirs.map{ |dir| grow_unblocked_moves_in_dir(@current_pos, dir) }.flatten(1)
  end

  private

  def move_dirs
    #definted by instance of class
  end

  def grow_unblocked_moves_in_dir(start_pos, dir)
    new_pos = [start_pos[0] + dir[0], start_pos[1] + dir[1]]
    return [] unless new_pos.all? { |coord| coord.between?(0,7)}
    return [] if board[new_pos].color == self.color
    return [new_pos] if board[new_pos].class != NullPiece && board[new_pos].color != self.color
    [new_pos] + grow_unblocked_moves_in_dir(new_pos, dir)
  end
end
