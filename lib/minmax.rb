class MMTreenode
  include Enumerable
  attr_reader :children, :total_value, :value, :tags, :hands

  def initialize(value=0)
    @children = []
    @value = value
    @total_value = 0 # calculated
  end

  def add_child(ch)
    @children << ch
  end

  def each_child(&block)
    @children.each(&block)
  end
end

class Minmax
  # This tree has a large number of possible actions:
  #  * Play
  #    - Try playing each card, some of which may be safe, some may not
  #  * Give clue
  #    - Try giving a clue to each player, some of which may have actions, some may not
  #      + Evaluate each clue that can be given as a seperate move, with seperate sub-tree (that player will
  #        have different actions based on which clue we give them, and so will affect the minmax!!!
  #  * Discarding
  #    - Look into discarding each card, some of which we may not want to
  # This comes to (for 4 players, 5 cards) 5 + 4 * num_clues_per_hand + 5 possible moves. Only some of these
  # will result in a card being draw (the "opposing player"). The opposing player will either do nothing, or
  # will cause WEIGHT_DRAW_CARD to occur in the tree.

  WEIGHT_PLAY_CARD_SAFE        =  3 # When we know what a card is
  WEIGHT_PLAY_CARD_UNSAFE      =  2 # When we have some information on a card
  WEIGHT_PLAY_CARD_GUESS       = -1 # No information at all on a card
  WEIGHT_DISCARD_CARD_SAFE     =  1 # We know we don't want this card
  WEIGHT_DISCARD_CARD_UNSAFE   =  0
  WEIGHT_DISCARD_CARD_BAD      = -3 # Discarding a card we can play
  WEIGHT_DRAW_CARD             = -1 # Gets us closer to the end of the game
  WEIGHT_GIVE_CLUE             =  2 # Giving a clue to a player who doesn't have a move
  WEIGHT_GIVE_CLUE_SUPERFLUOUS =  0 # when hint is given to a player that has a move

  def initialize(game_state, depth=5)
    # We get the original game_state at time of initialization
    # Then we clone the relevant information and extrapolate additional information.
    # We leave out information that isn't necessary, but we clone everything
    # to prevent tampering.
    @game_state = {
      :clue_tokens = game_state[:clue_tokens].clone,
      :screw_ups_remaining = game_state[:screw_ups_remaining].clone,
      :discard = game_state[:discard].clone,
      :cur_player = game_state[:cur_player].clone,
      :last_player = game_state[:last_player].clone,
      :piles = game_state[:piles].clone,
      :tags = [],
      :hands = []
    }
    @players.each do |p|
      @game_state[:tags] << p.tags.clone
      @game_state[:hands] << p.hand.clone
    end
  end

  def enumerate_moves
    nodes = []
    hand = @game_state[:hands][@game_state[:cur_player]]
    tags = @game_state[:tags][@game_state[:cur_player]]
    (0...hand.length).each do |card_index|
      # We look at the hand for the current player (in this simulation)
      # and then we determine what moves are available for each card.
      # Returns an array of nodes.
      card = hand[card_index]
      tagged_as = tags[card_index]
      if tagged_as.nil?
        certainty = 0
      else
        certainty = tagged_as.length
      end

      if certainty == 0
        nodes << MMTreeNode.new(WEIGHT_DISCARD_CARD_UNSAFE)
        nodes << MMTreeNode.new(WEIGHT_PLAY_CARD_GUESS)
      elsif certainty == 1
        # Determine if either the color or the number is relevant
        # Then determine if either are playable.
      else
        # Does that exact card exist on board?
        # If so, discard for sure, else play.
      end
    end  
  end

  def build_tree
    @root = MMTreenode.new()
    # For a move, we calculate a value for that move, and give it a child: the value
    # for the opponent's move. That node then has, as children, the moves of the NEXT PLAYER.
    # We can do this by making a NEW MINMAX TREE for the next player based on the board state
    # after making the move that this tree comes from, and appending it to our current tree that
    # we're building. We need to, then, limit the depth of the tree during creation (depth
    # is reduced by one for every sub-tree we're making).
    #
    # As a note: All players should at least try to think Players.all.length moves ahead
    # (so that they can determine the best possible move for the next round.)
    #
    # This also allows a simple optimization later: reusing trees!

    # this adds all our moves to the tree
    enumerate_moves()

    if depth > 1
      @root.each do |node|
        # 'node' is a potential move for us
        opponent = node.children[0] # only one child, only one opponent move
        # a.push(a.shift) is some ruby magic to rotate the array
        mm = Minmax(node.tags.push(node.tags.shift), node.hands.push(node.hands.shift), deck - 1, discard, depth - 1)
		mm.build_tree
        opponent.add_child(mm.root)
      end
    end
  end

  def process_tree(treeroot)
    # Traverse the current tree for the optimal play.
    treeroot.each do |child|
      process_tree(child)
      treeroot.total_value += child.total_value
    end
    treeroot.total_value += treeroot.value
  end
end
