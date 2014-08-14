# Excutable that allows us to play Hanabi

require_relative '../lib/card'
require_relative '../lib/deck'
require_relative '../lib/player'
require_relative '../lib/helper'
include Helper

def get_players
  # Need to keep this out of the Helper module because
  # Dependencies on Player class.
  input = nil
  while input != 'q' and Player.all.length < 5
    cur = Player.all.length+1
    arg = cur-1
    if ARGV[arg]
      Helper.found_player(cur, ARGV[arg])
      Player.new(true, ARGV[arg])
    else
      Helper.get_player(cur)
      input = gets.chomp
      Player.new(true, input) unless input == 'q' # TODO: Ask if AI or Human
    end
  end
end

def deal_cards(deck)
  # Ditto
  Helper.deal
  number_of_cards = 5
  if Player.all.length > 3
    number_of_cards = 4
  end

  number_of_cards.times do
    Player.all.each do |player|
      player.draw(deck)
    end
  end
end

Helper.welcome_banner
get_players

game_state = {
  :deck => Deck.new,
  :clue_tokens => 8,
  :screw_ups_remaining => 3,
  :discard => [],
  :cur_player => 0,
  :turns_left = nil,
  :piles => {}
}

deal_cards(game_state[:deck])
gameover = false

while !gameover
  cur_player = Player.all[game_state[:cur_player]]
  Helper.player_banner(cur_player)
  if cur_player.human
    Helper.inspect_other_hands(Player.all, game_state[:cur_player])
    Helper.inspect_my_hand(cur_player)
    Helper.inspect_piles(game_state[:piles])
    Helper.inspect_discard(game_state[:discard])
    Helper.inspect_screw_ups(game_state[:screw_ups_remaining],
                             game_state[:clue_tokens],
                             game_state[:deck].cards.length)
    m = Helper.select_move(game_state)
    move = {:move => m, :current_player => cur_player}
  else
    # The AI will automatically determine the move without
    # all this silly helper business.
    m = nil
    move = Player.determine_next_move(game_state)
  end

  if m == 'play'
    move[:selection] = Helper.choose_card(cur_player)
  elsif m == 'clue'
    move[:player] = Helper.choose_player(Player.all)
    move[:selection] = Helper.choose_clue(move[:player])
  elsif m == 'discard'
    move[:selection] = Helper.choose_card(cur_player)
  end

  # announce_and_perform alters the game_state based on the move.
  # take_turn alters the player based on the move.
  # e.g. I announce that I play a card, and that gets added to the
  # appropriate pile - then I take my turn and remove it from my hand
  # as a result.
  Helper.announce_and_perform(move, game_state)
  Player.all[game_state[:cur_player]].take_turn(move)

  # Determine if game is over, then move on.
  # Move on to the next player
  game_state[:cur_player] = (game_state[:cur_player] + 1) % (Player.all.length - 1)
end
