# Excutable that allows us to play Hanabi

require_relative '../lib/card'
require_relative '../lib/deck'
require_relative '../lib/player'
require_relative '../lib/helper'
include Helper

def get_players
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
  :cur_player => 0
}

deal_cards(game_state[:deck])
gameover = false

while !gameover
  cur_player = Player.all[game_state[:cur_player]]
  Helper.player_banner(cur_player)
  if cur_player.human
    Helper.inspect_other_hands(Player.all, game_state[:cur_player])
    Helper.inspect_my_hand(cur_player)
    m = Helper.select_move(game_state)
    puts m
    exit # TODO: ACTUAL GAMEPLAY
    if m == 'play'
    elsif m == 'clue'
    else
    end
  else
    move = Player.determine_next_move(game_state)
  end
  Player.all[game_state[:cur_player]].take_turn(game_state)

  # Determine if game is over, then move on.
  # Move on to the next player
  game_state[:cur_player] = (game_state[:cur_player] + 1) % Player.all.length
end
