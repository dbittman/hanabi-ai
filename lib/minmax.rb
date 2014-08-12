# eh, whatever

Class MMTreenode
	include Enumerable

	def initialize(value=nil)
		@children = []
		@value = value
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

	def initialize(game_state_or_some_shit)

	end

	def build_tree
		@root = MMTreenode.new()
		
	end

	def process_tree

	end

end

