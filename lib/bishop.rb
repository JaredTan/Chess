require_relative 'slideable'
require_relative 'piece'

class Bishop < Piece
  include Slideable

  protected

  def move_dirs
    DIAG
  end
end
