require "io/console"

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board, :selected
  attr_accessor :finished_move

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @selected = false
    @finished_move = false
  end

  def get_input(color)
    key = KEYMAP[read_char]
    # # if @selected
    # #   until key == :return || key == :space
    # #     puts "Please hit 'return' or 'space' to untoggle 'selected'."
    # #     key = KEYMAP[read_char]
    # #   end
    # end
    handle_key(key, color)
  end

  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end

  def handle_key(key, color)
    case key
    when :left, :right, :up, :down
      update_pos(MOVES[key])
      nil
    when :return, :space
      if @board[@cursor_pos].class == NullPiece && !@selected
        nil
      elsif @cursor_pos == @from_pos && @selected
        @from_pos = nil
        @selected = false
      else
        @to_pos = @cursor_pos if @selected
        @from_pos = @cursor_pos unless @selected
        @selected = !@selected
      end
    when :ctrl_c
      Process.exit(0)
    end
    if @from_pos && @to_pos
      @board.move_piece(color, @from_pos, @to_pos)
      @to_pos = nil
      @from_pos = nil
      @selected = false
      @finished_move = true
    end
  end

  def update_pos(diff)
    maybe_new_pos = [@cursor_pos[0] + diff[0], @cursor_pos[1] + diff[1]]
    if @board.in_bounds?(maybe_new_pos)
      @cursor_pos = maybe_new_pos
    end
  end


end
