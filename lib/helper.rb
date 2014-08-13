module Helper
  # Generic helper functions that deal with all the bullshit.
  # Basically: I want my models to be clean and this is a garbage dump.

  def welcome_banner
    # Seen at game start
    puts "Welcome to Hanabi!"
    puts "=================="
    puts
  end

  def player_banner(player)
    # Seen at beginning of turn
    banner = "#{player.name}'s Turn!"
    puts banner
    puts '-'*banner.length
    puts
  end

  def deal
    puts "Dealing out cards..."
    puts
  end

  def found_player(n, name)
    puts "Player #{n} is #{name}!"
  end

  def get_player(cur)
    print "Who is Player #{cur}? "
    if cur > 2
      print "(type q to start the game) "
    end
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
        return 'play'
      elsif derp == '2' and game_state[:clue_tokens] > 0
        return 'clue'
      elsif derp == '3'
        return 'discard'
      else
        puts "Sorry, I didn't catch that..."
        derp = nil
      end
    end
    exit # Just to catch stupid shit from happening.
  end

  def inspect_other_hands(all_players, id)
    # Looks at other players hand and outputs it.
    cur = id+1 % all_players.length
    while cur != id
      cur_player = all_players[cur]
      cards = cur_player.hand
      puts "#{cur_player.name} has:"
      cards.each do |card|
        puts "  * #{card.color_id_to_name} #{card.number}"
      end
      cur = (cur + 1) % all_players.length
    end
    puts
  end

  def inspect_my_hand(player)
    hand = player.hand
    tags = player.tags
    puts "You have:"
    n = 1
    hand.each do |card|
      print "  #{n}) A "
      if tags[card].nil?
        puts "mysterious card."
      else
        if tags[card]['color']
          print tags[card]['color'] + ' '
        end
        if tags[card]['number']
          print tags[card]['number']
        end
        puts
      end
      n += 1
    end
    puts
  end

  def choose_card(player)
  end

  def choose_clue(player)
  end
end
