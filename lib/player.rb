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
    puts "You have:"
    @hand.each do |card|
      print "  * A "
      if @tags[card].nil?
        puts "mysterious card."
      else
        if @tags[card]['color']
          print @tags[card]['color'] + ' '
        end
        if @tags[card]['number']
          print @tags[card]['number']
        end
        puts
      end
    end
  end

  def get_clue(color=nil, number=nil, *cards)
    # Somebody gave me a clue!
    # If color is not nil, that means I was told that all the indexes in cards were a certain color.
    # If number is not nil, same but with the number
    # ex. get_clue(Card::YELLOW, nil, 1, 2, 3)
    # Regardless, create @tags[@hand[card]] = Hash.new nil
    # TODO
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
