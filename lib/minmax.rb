Class MMTreenode
  include Enumerable
  attr_reader :children :total_value :value :tags :hands

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

Class Minmax
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

  def initialize(tags=[], hands=[], deck, discard=nil, depth)
    # All the elements of tags and hands MUST BE CLONES of the player's tags and hands.
    # Game state is broken up into a couple of different pieces.
    # tags: an array of all the tags for each player, in order of each player (index 0 is current player).
    # hands: an array of every hand, in order of player (index 0 is current player).
    # deck: so we can do some basic analysis (how many cards left?)
    # discard: if the game is played with open discard.
    @hands = hands
    @tags = tags
    @deck = deck
    @discard = discard
    @depth = depth
  end

  def enumerate_moves
    @hands[0].each do |card|
      # each card, either play, or discard. we need to know the "tags" we have
      # to determine if it's SAFE, UNSAFE or a GUESS (or is BAD). We use what
      # we know to determine what we believe.
      #
      # We'll need to also record what kinda of move this is inside the
      # node, so that later we can read out the move from the node after
      # the tree is processed.
      # In addition, we record the new game state for AFTER move is made: modified tags, hands, and such.
    end  
    # all_players.each { |player| construct node for each hint we can give }
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

