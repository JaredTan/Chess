require_relative 'slideable'
require_relative 'piece'

class Queen < Piece
  include Slideable

  protected

  def move_dirs
    DIAG + HOR
  end
end
