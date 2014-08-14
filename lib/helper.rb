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
      n = 1
      cards.each do |card|
        puts "  #{n}) #{card.color_id_to_name} #{card.number}"
        n += 1
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
      if tags[card] == nil
        puts "mysterious card."
      else
        if tags[card][:color]
          print tags[card][:color] + ' '
        end
        if tags[card][:number]
          print tags[card][:number]
        end
        puts
      end
      n += 1
    end
    puts
  end

  def choose_card(player)
    # Give a prompt and grab the selected index from the given player.
    card = nil
    while card.nil?
      print "Which card? "
      i = STDIN.gets.chomp
      card = player.hand[i.to_i-1]
    end
    puts
    return card
  end

  def choose_player(players)
    # Let the player select a player from all available.
    p = nil
    while p.nil?
      print "Which player? "
      i = STDIN.gets.chomp
      players.each do |player|
        if i == player.name
          p = player
        end
      end
    end
    puts
    return p
  end

  def choose_clue(player)
    # Look at the cards in the players hand.
    # What clues are available to give?
    # Return a color or a number.
    # TODO: Refactor this
    clues = Hash.new
    player.hand.each do |card|
      clues[card.color_id_to_name] = true
      clues[card.number] = true
    end
    puts "You can give one of the following clues:"
    n = 1
    clues_array = []
    clues.each_key do |k|
      clues_array << k
      print "  #{n}) There are cards that show "
      if k.is_a? Integer
        puts "the number #{k}."
      else
        puts "the color #{k}."
      end
      n += 1
    end
    puts
    clue = nil
    while clue.nil?
      print "Which clue? "
      i = STDIN.gets.chomp
      clue = clues_array[i.to_i - 1]
    end
    return clue
  end

  def valid_play(card, game_state)
    # Is a card valid to play?
    pile = game_state[:piles][card.color_id_to_name]
    if card.number - 1 == pile
      return true
    elsif card.number == 1 and pile.nil?
      return true
    end
    return false
  end

  def inspect_piles(piles)
    if piles != {}
      puts "Team's Score:"
      piles.each do |k, v|
        puts "  * #{k}: #{v}"
      end
    else
      puts "Nothing has been played yet!"
    end
    puts
  end

  def inspect_screw_ups(screw_ups, clue_tokens, cards_remaining)
    puts "You have #{screw_ups} chances left, #{clue_tokens} clue tokens left, and #{cards_remaining} cards in the deck."
    puts
  end

  def inspect_discard(discard)
    if discard != []
      puts "In the discard there is:"
      discard.each do |card|
       puts "  * #{card.color_id_to_name} #{card.number}"
      end
    else
      puts "There is nothing in the discard!"
    end
    puts
  end

  def announce_and_perform(move, game_state)
    # Give a move, announce what the move is. Then perform
    # all of the actions on the GAME STATE.
    # It also handles drawing.
    # TODO: Refactor
    action = move[:move]
    selection = move[:selection]
    player = move[:current_player]
    string = "#{player.name} chose to "
    if action == 'play'
      string << "play their #{selection.color_id_to_name} #{selection.number}!"
      if valid_play(selection, game_state)
        game_state[:piles][selection.color_id_to_name] = selection.number
        string << " (VALID)"
      else
        string << " (INVALID)"
        game_state[:screw_ups_remaining] += -1
        game_state[:discard] << selection
      end
      player.draw(game_state[:deck])
    elsif action == 'clue'
      string << "give #{move[:player].name} a clue: they have #{selection}'s in their hand!"
      game_state[:clue_tokens] += -1
      player.give_a_clue(move[:player], selection)
    else # Discard
      string << "discard their #{selection.color_id_to_name} #{selection.number}!"
      game_state[:discard] << selection
      player.draw(game_state[:deck])
    end
    puts string.upcase
    puts
  end

  def game_over(game_state)
    # Determines if game is over.
    if game_state[:screw_ups_remaining] < 1
      return true
    elsif game_state[:deck].cards.length < 1
      if game_state[:last_player].nil?
        game_state[:last_player] = game_state[:cur_player]
        return false
      elsif game_state[:last_player] == game_state[:cur_player]
        return true
      end
    end
    return false
  end

  def end_game(game_state)
    # End the game!
    final_score = 0
    game_state[:piles].each do |color, value|
      final_score += value
    end
    puts "The team's final score was #{final_score}!"
    exit
  end
end
