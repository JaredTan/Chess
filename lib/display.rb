require 'colorize'
require_relative 'cursor'

class Display

  attr_reader :cursor, :board

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
  end

  def render
    pos = @cursor.cursor_pos
    no_color_grid = @board.grid.map do |row|
      row.map { |piece| (piece.is_a?(NullPiece) ? "   " : piece.to_s) }
    end
    no_color_grid.each.with_index do |row,i|
      row.map!.with_index do |col,j|
        if (i + j).even?
          no_color_grid[i][j].colorize( :background => :brown)
        else
          no_color_grid[i][j].colorize( :background => :cyan)
        end
      end
    end
    if @cursor.selected
      no_color_grid[pos[0]][pos[1]] = no_color_grid[pos[0]][pos[1]].blue.on_red.blink
    else
      no_color_grid[pos[0]][pos[1]] = no_color_grid[pos[0]][pos[1]].colorize(:red)
    end
    no_color_grid.each do |row|
      puts row.join
    end
  end


end
