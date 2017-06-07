require_relative 'piece'
require 'singleton'

class NullPiece < Piece
  include Singleton

  def initialize; end

  def symbol
    nil
  end

  def color
    nil
  end

  def moves
    []
  end
end
