class Player
  # This is the player class.
  # Human and AI players are represented through here.
  attr_reader :hand, :name
  @@all = []

  def initialize(human=true, name="")
    # Creates a player.
    @name = name
    @human = human
    @hand = []
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

  def take_turn
    # Take your turn!
    # If human, displays.
    # If AI, does algorithm-y things.
    # TODO: Add AI
    banner = "#{@name}'s Turn!"
    puts banner
    puts '-'*banner.length
    puts
    if @human
      cur = @id+1 % @@all.length
      while cur != @id
        @@all[cur].inspect_hand
        cur = (cur + 1) % @@all.length
      end
      puts
      inspect_my_hand
    end
  end

  def inspect_my_hand
    # Displays what you know about your hand given from clues.
    puts "You know nothing about your hand."
  end

  def inspect_hand
    # A way to display a player's hand to a human.
    puts "#{@name} has:"
    @hand.each do |card|
      puts "  * #{card.color_id_to_name} #{card.number}"
    end
  end

  def self.all
    @@all
  end
end
