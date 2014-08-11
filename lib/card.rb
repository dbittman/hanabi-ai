class Card
  # This is the class for all cards in the game.
  # These are class-wide ids for each color we use.
  YELLOW = 0
  WHITE = 1
  RED = 2
  BLUE = 3
  GREEN = 4

  attr_reader :color
  attr_reader :number

  def initialize(color, number)
    # Create a card with a color and a number.
    @color = color
    @number = number
  end

  def color_id_to_name
    # Looks at the id number and translates it into
    # a human-identifiable string.
    if @color == YELLOW
      "Yellow"
    elsif @color == RED
      "Red"
    elsif @color == BLUE
      "Blue"
    elsif @color == GREEN
      "Green"
    elsif @color == WHITE
      "White"
    else
      "No Color"
    end
  end

  def inspect
    # Returns a small hash that contains some debugging information
    # in case everything goes tits-up.
    return {:color => color_id_to_name(), :color_id => @color,
            :number => @number}
  end
end
