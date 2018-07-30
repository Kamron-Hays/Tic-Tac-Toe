# Models a tic-tac-toe "board" with the following positions:
#
#   1 | 2 | 3
#  ---+---+---
#   4 | 5 | 6
#  ---+---+---
#   7 | 8 | 9
#
class Board
  attr_accessor :cells

  @@Size = 9
  @@Winning_Combos = [ [0,1,2], [3,4,5], [6,7,8],
                       [0,3,6], [1,4,7], [2,5,8],
                       [0,4,8], [2,4,6] ]

  def initialize
    @cells = Array.new(@@Size)
  end

  # Returns true if the specified position is a legal move. Otherwise
  # false is returned.
  def legal_move?(position)
    position.between?(1, @@Size) && @cells[position-1].nil?
  end

  # Returns the value of the specified board position (1-9).
  def get(position)
    value = nil
    if position.between?(1, @@Size)
      value = @cells[position-1]
    end
    value
  end

  # Returns true if there are any empty cells on the board; otherwise false
  # is returned.
  def moves_left?
    @cells.any? { |cell| cell.nil? }
  end

  # Checks this board for a winning combination. Returns the letter of the
  # winner, or nil if no winner.
  def check_winner
    winner = nil
    @@Winning_Combos.each do |combo|
      ix1, ix2, ix3 = combo
      if !@cells[ix1].nil? &&
         @cells[ix1] == @cells[ix2] &&
         @cells[ix1] == @cells[ix3]
        winner = @cells[ix1]
        break
      end
    end
    winner
  end

  # Places the specified letter at the specified position on this board.
  # Returns true on success, otherwise false is returned.
  def mark(position, letter)
    status = false
    if legal_move?(position)
      @cells[position-1] = letter
      status = true
    end
    status
  end
end

if __FILE__ == $0
  # this will only run if the script is the main, not load'd or require'd

  board = Board.new
  p board
  p board.get(0)
end
