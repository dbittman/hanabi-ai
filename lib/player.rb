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

  def take_turn(game_state)
    # Take your turn!
    # If human, displays.
    # If AI, does algorithm-y things.
    # game_state refers to a hash of information about the game
    # given by the core script.
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
      puts
      move = select_move(game_state)
      if move == 1 # Play a card
        play_a_card
      elsif move == 2 # Give a clue
        give_a_clue
      elsif move == 3 # Discard a card
        discard_a_card
      end
    end
  end

  def play_a_card
    # TODO
    # Asks which card to play.
    # returns a hash confirming that it is a play and the card being played.
    # Remove that card this player's hand.
    # Don't forget to draw!
  end

  def give_a_clue
    # TODO
    # Asks for what player they want to give a clue to.
    # Then for color/number.
    # Then lists possibilities.
    # Returns a hash of the clue, for the main script to
    # call get_clue on the receiver. (keeps the function
    # clearer that way).
  end

  def discard_a_card
    # TODO
    # Same as play_a_card, except it returns a hash confirming
    # that is a discard.
  end

  def select_move(game_state)
    puts "You can:"
    puts "  1) Play a card"
    if game_state[:clue_tokens] > 0
      puts "  2) Give a clue"
    else
      puts "  X) No clue tokens available"
    end
    puts "  3) Discard a card"
    puts
    derp = nil
    while derp.nil?
      print "Your move (q to quit): "
      derp = STDIN.gets.chomp # STDIN for rake's benefit.
      if derp == 'q'
        exit
      elsif derp == '1'
        1
      elsif derp == '2' and game_state[:clue_tokens] > 0
        2
      elsif derp == '3'
        3
      else
        puts "Sorry, I didn't catch that..."
        derp = nil
      end
    end
    exit # Just to catch stupid shit from happening.
  end

  def inspect_my_hand
    # Displays what you know about your hand given from clues.
    puts "You have:"
    n = 1
    @hand.each do |card|
      print "  #{n}) A "
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
      n += 1
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
