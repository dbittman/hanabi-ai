class Player
  # This is the player class.
  # Human and AI players are represented through here.
  attr_reader :hand, :name, :human, :tags
  @@all = []

  def initialize(human=true, name="")
    # Creates a player.
    @name = name
    @human = human
    @hand = []
    @tags = {}
    @id = @@all.length
    @@all << self
  end

  def draw(deck)
    # Asks the deck to pop off a card and then send it our way.
    card = deck.draw
    if card # in case the deck is empty and we get nil
      @hand << card
    end
  end

  def take_turn(move)
    # Take your turn!
    # move: a hash that determines what action the player
    # has chosen to take.
    m = move[:move]
    if m == 'clue'
      give_a_clue(move[:player], move[:selection])
    else # discard or play
      use_a_card(@hand.find_index(move[:selection]))
    end
  end

  def use_a_card(card)
    # Remove a card from hand.
    @hand.delete_at(card)
  end

  def give_a_clue(player, selection)
    # Give a clue to a player - he'll figure out
    # what I mean.
    player.get_clue(selection)
  end

  def get_clue(selection)
    # Somebody gave me a clue!
    # I'm a computer, so just cheat, look at my cards
    # and then reveal to me which ones they were talking about
    # based on the selection.
    # Regardless, create @tags[@hand[card]] = Hash.new nil
    # TODO
  end

  def self.all
    @@all
  end
end
