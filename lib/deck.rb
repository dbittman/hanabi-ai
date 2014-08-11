class Deck
  # Changed my mind, we should have another class for Decks.

  attr_reader :cards

  def initialize
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
        deck << Card.new(Card::YELLOW, i)
        deck << Card.new(Card::WHITE, i)
        deck << Card.new(Card::RED, i)
        deck << Card.new(Card::BLUE, i)
        deck << Card.new(Card::GREEN, i)
      end
    end

    # Shuffle and return the deck.
    @cards = deck.shuffle
  end

  def test
    # Returns some numbers about the deck - good for debugging, but can be used in
    # handling decision trees.
    deck = Deck.new()
    cards_in_each_color = {
      Card::YELLOW => [],
      Card::WHITE => [],
      Card::RED => [],
      Card::BLUE => [],
      Card::GREEN => []
    }
    deck.cards.each do |c|
      cards_in_each_color[c.color] << c.number
    end
    {
     :length => deck.cards.length,
     :yellow_cards => cards_in_each_color[Card::YELLOW],
     :white_cards => cards_in_each_color[Card::WHITE],
     :red_cards => cards_in_each_color[Card::RED],
     :blue_cards => cards_in_each_color[Card::BLUE],
     :green_cards => cards_in_each_color[Card::GREEN]
    }
  end
end
