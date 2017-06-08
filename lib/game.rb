require_relative 'board'
require_relative 'display'
require_relative 'player'

class Game

  attr_reader :player_one, :player_two

  def initialize(p1, p2)
    @board = Board.new
    @display = Display.new(@board)
    @player_one = p1
    @player_two = p2
    @turn = -1
  end

  def play
    until won?
      switch_players
      take_turn
    end
    conclude
  end

  def conclude
    puts "Checkmate! #{current_player.name} wins!"
  end

  def take_turn
    @display.cursor.finished_move = false
    until finished_move?
      @display.render(current_player)
      @display.cursor.get_input(current_player.color)
    end
  end

  def finished_move?
    @display.cursor.finished_move
  end

  def switch_players
    @turn += 1
  end

  def current_player
    return @player_one if @turn.even?
    @player_two
  end

  def won?
    false
    # @board.checkmate?(@player_one.color) || @board.checkmate?(@player_two.color)
  end

end

if __FILE__ == $PROGRAM_NAME

p1 = Player.new('Jard', :white)
p2 = Player.new('P2', :black)
Game.new(p1, p2).play


end
