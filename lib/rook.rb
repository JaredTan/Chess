require_relative 'slideable'
require_relative 'piece'

class Rook < Piece
  include Slideable

  protected

  def move_dirs
    HOR
  end
end
