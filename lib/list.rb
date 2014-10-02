class List
  # "Multiversal Linked List"
  attr_accessor :root

  def initialize(*players)
    # Create a game.
    # players: an array of player names.
    @root = Node.new({:id => Node::MOVE_START_GAME, :players => players}, nil)
    @root.choose
    startTurn
  end

  def last
    # Returns the last node of the current game state.
    # next() only gets the next canon node.
    results = nil
    l = @root
    while !l.nil?
      results = l
      l = l.next
    end
    return results
  end

  # Hanabi-specific function
  def startTurn
    # Makes sure that everyone has drawn up to five, etc.
    node = last
    hands = node.gameState[:players].map { |p| p[:hand].length }
    deck = node.gameState[:deck]
    turns = node.gameState[:turnsLeft]
    (0...hands.length).each do |h|
      cardsNeeded = Node::MAX_HAND_SIZE - hands[h]
      if hands[h] < Node::MAX_HAND_SIZE and deck.length >= cardsNeeded
        node.gameState[:players][h][:hand] += deck.pop(cardsNeeded)
      else
        node.gameState[:players][h][:hand] += deck.pop(deck.length)
        if turns == true
          node.gameState[:turnsLeft] = hands.length
        end
      end
    end
  end
end

class Node
  # Constants, I need lots of them...
  MOVE_START_GAME = 0
  MOVE_PLAY = 1
  MOVE_GIVE_CLUE = 2
  MOVE_DISCARD = 3

  MAX_CLUE_TOKENS = 8
  MAX_TRIES = 3
  MAX_HAND_SIZE = 4 # for 4-5 player games, it's 5 for 2-3.

  COLOR_YELLOW = 0
  COLOR_RED = 1
  COLOR_BLUE = 2
  COLOR_WHITE = 3
  COLOR_GREEN = 4
  COLOR_RAINBOW = 5 # TODO

  SCORE_GOOD_PLAY = 5
  SCORE_BAD_PLAY = -5
  SCORE_MAYBE_PLAY = 0
  SCORE_UNSURE_PLAY = 0
  SCORE_GOOD_DISCARD = 3
  SCORE_BAD_DISCARD = -3
  SCORE_MAYBE_DISCARD = 0
  SCORE_UNSURE_DISCARD = 0
  SCORE_GIVE_CLUE = 4

  attr_accessor :children, :parent, :move, :canon, :gameState, :points
  def initialize(move, parent)
    @children = []
    @parent = parent
    @move = move
    if @parent.nil?
      @gameState = isNewGame()
      @points = 0
      @canon = true # this is the root node, it is by definition canon.
    else
      @gameState = Marshal.load(Marshal.dump(@parent.gameState))
      updateState()
      @points = getScore() + @parent.points
      @canon = false
    end
  end

  def next
    i = @children.find_index {|child| child.canon}
    if i.nil?
      return nil
    else
      return @children[i]
    end
  end

  def choose
    @canon = true
  end

  def prune
    # Remove all nodes from children that are not canon.
    @children.delete_if {|child| !child.canon}
  end

  def makeChildren
    # Enumerates all possible moves, then creates children from them.
    moves = enumerateMoves()
    moves.each do |m|
      @children << Node.new(m, self)
    end
  end

  def gameover?
    turnsLeft = @gameState[:turnsLeft]
    if turnsLeft == true
      return lost?
    else
      return (lost? or (@gameState[:turnsLeft] > 0))
    end
  end

  def lost?
    return @gameState[:tries] < 1
  end

  # Hanabi-Specific Functions
  def enumerateMoves
    # Use the game state to enumerate the moves available to you.
    # Possible Moves:
    # * Could play or discard any of my cards.
    # * Can give clues to each person based on...
    # * * Each color present in their hand or...
    # * * Each number present in their hand.
    # Play: {:id => MOVE_ID, :card => index in hand}
    # Discard: {:id => MOVE_ID, :card => index in hand}
    # Give Clue: {:id => MOVE_ID, :targetHand => index in players,
    # :color => i or nil, :number => i or nil}
    if gameover?
      return []
    end
    moves = []
    me = @gameState[:currentPlayer]
    (0...@gameState[:players].length).each do |p|
      hand = @gameState[:players][p][:hand]
      if p != me and @gameState[:clues] > 0
        numbers = hand.map {|c| c[:number]}.uniq
        numbers.each do |n|
          moves << {:id => MOVE_GIVE_CLUE, :targetHand => p, :color => nil, :number => n}
        end
        colors = hand.map {|c| c[:color]}.uniq
        colors.each do |c|
          moves << {:id => MOVE_GIVE_CLUE, :targetHand => p, :color => c, :number => nil}
        end
      else
        (0...hand.length).each do |c|
          moves << {:id => MOVE_PLAY, :card => c}
          moves << {:id => MOVE_DISCARD, :card => c}
        end
      end
    end
    return moves
  end

  private
  def isNewGame()
    # If this is the root node, it sets up the game state appropriately.
    state = {
      :deck => [],
      :discard => [],
      :players => [],
      :successes => {COLOR_YELLOW => 0, COLOR_BLUE => 0, COLOR_RED => 0, COLOR_WHITE => 0, COLOR_GREEN => 0},
      :clues => MAX_CLUE_TOKENS,
      :tries => MAX_TRIES,
      :currentPlayer => 0,
      :turnsLeft => true
    }
    [1, 1, 1, 2, 2, 3, 3, 4, 4, 5].each do |n|
      [COLOR_YELLOW, COLOR_RED, COLOR_BLUE, COLOR_WHITE, COLOR_GREEN].each do |c|
        state[:deck] << {:color => c, :number => n, :color_known? => false, :number_known? => false}
      end
    end
    state[:deck].shuffle!
    @move[:players].each do |name|
      state[:players] << {:name => name, :hand => []}
    end
    return state
  end

  def updateState
    # Updates the node's gamestate on the move it was given.
    move = @move[:id]
    player = @gameState[:players][@gameState[:currentPlayer]]
    if move == MOVE_PLAY
      card = player[:hand].delete_at(@move[:card]) 
      if card[:number] - @gameState[:successes][card[:color]] == 1 # Is the next card in the lineup
        @gameState[:successes][card[:color]] += 1 # played a success
      else
        @gameState[:discard] << card
        @gameState[:tries] -= 1
      end
    elsif move == MOVE_GIVE_CLUE
      targetHand = @gameState[:players][@move[:targetHand]][:hand]
      color = @move[:color]
      number = @move[:number]
      targetHand.each do |c|
        if c[:color] == color
          c[:color_known?] = true
        elsif c[:number] == number
          c[:number_known?] = true
        end
      end
      @gameState[:clues] -= 1
    else # discard
      card = player[:hand].delete_at(@move[:card])
      @gameState[:discard] << card
      @gameState[:clues] += 1 unless @gameState[:clues] == MAX_CLUE_TOKENS
    end
    @gameState[:currentPlayer] = (@gameState[:currentPlayer] + 1) % @gameState[:players].length # next player's turn.
    if @gameState[:turnsLeft] != true
      @gameState[:turnsLeft] -= 1
    end
  end

  def getScore
    # Calculates the score of this node.
    if lost?
      return -9999999
    end
    move = @move[:id]
    player = @gameState[:players][@gameState[:currentPlayer]]
    if move == MOVE_GIVE_CLUE
      return SCORE_GIVE_CLUE
    else # discard or play
      card = player[:hand][@move[:card]]
      number_playable = @gameState[:successes].values.count {|i| card[:number] - i == 1} > 1
      color_playable = @gameState[:successes][card[:color]] < 5
      playable = number_playable and color_playable
      known_for_certain = [card[:color_known?], card[:number_known?]].count {|c| c} == 2
      if known_for_certain and playable
        if move == MOVE_PLAY then return SCORE_GOOD_PLAY else return SCORE_BAD_DISCARD end
      elsif card[:color_known?] and !color_playable
        if move == MOVE_PLAY then return SCORE_BAD_PLAY else return SCORE_GOOD_DISCARD end
      elsif card[:number_known?] and !number_playable
        if move == MOVE_PLAY then return SCORE_BAD_PLAY else return SCORE_GOOD_DISCARD end
      elsif card[:color_known?] and color_playable
        if move == MOVE_PLAY then return SCORE_MAYBE_PLAY else return SCORE_MAYBE_DISCARD end
      elsif card[:number_known?] and number_playable
        if move == MOVE_PLAY then return SCORE_MAYBE_PLAY else return SCORE_MAYBE_DISCARD end
      else
        if move == MOVE_PLAY then return SCORE_UNSURE_PLAY else return SCORE_UNSURE_DISCARD end
      end
    end
  end
end
