class Card
  # This is the class for all cards in the game.
  # These are class-wide ids for each color we use.
  @@YELLOW = 0
  @@WHITE = 1
  @@RED = 2
  @@BLUE = 3
  @@GREEN = 4

  def self.make_deck
    # Program that automatically makes a Hanabi deck.
    deck = []
    (1..5).each do |i|
      # Most cards are repeated twice, except for ones
      # and fives.
      repeat = 2
      if i == 1
        repeat = 3
      elsif i == 5
        repeat = 1
      end

      # Each color has the same amount of numbered cards.
      # Just create that number for each color.
      repeat.times do
        deck << Card.new(@@YELLOW, i)
        deck << Card.new(@@WHITE, i)
        deck << Card.new(@@RED, i)
        deck << Card.new(@@BLUE, i)
        deck << Card.new(@@GREEN, i)
      end
    end

    # Shuffle and return the deck.
    deck.shuffle
  end

  def self.deck_inspect
    # Returns some numbers about the deck - good for debugging, but can be used in
    # handling decision trees.
    deck = self.make_deck()
    # TODO: Numbers of each kind of card.
    {:length => deck.length}
  end

  def initialize(color, number)
    # Create a card with a color and a number.
    @color = color
    @number = number
  end

  def color_id_to_name
    # Looks at the id number and translates it into
    # a human-identifiable string.
    if @color == @@YELLOW
      "Yellow"
    elsif @color == @@RED
      "Red"
    elsif @color == @@BLUE
      "Blue"
    elsif @color == @@GREEN
      "Green"
    elsif @color == @@WHITE
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
