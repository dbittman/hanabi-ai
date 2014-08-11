# Excutable that allows us to play Hanabi

require_relative '../lib/card'
require_relative '../lib/deck'
require_relative '../lib/player'

def welcome_banner
  puts "Welcome to Hanabi!"
  puts "=================="
  puts
end

def get_players
  input = nil
  while input != 'q' and Player.all.length < 5
    cur = Player.all.length+1
    arg = cur-1
    if ARGV[arg]
      puts "Player #{cur} is #{ARGV[arg]}!"
      Player.new(true, ARGV[arg])
    else
      print "Who is Player #{cur}? "
      if cur > 2
        print "(type q to start the game) "
      end
      input = gets.chomp
      Player.new(true, input) unless input == 'q' # TODO: Ask if AI or Human
    end
  end
end

def deal_cards(deck)
  puts
  puts "Dealing out cards..."
  puts

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

welcome_banner
get_players
DECK = Deck.new
deal_cards(DECK)
cur_player = 0
Player.all[cur_player].take_turn
