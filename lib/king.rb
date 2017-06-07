require_relative 'piece'
require_relative 'stepable'

class King < Piece
  include Stepable

  protected

  def move_diffs
    [[1, 1], [-1, -1], [1, -1], [-1, 1], [0, 1], [0, -1], [1, 0], [-1, 0]]
  end
end
