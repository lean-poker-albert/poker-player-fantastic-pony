
require_relative 'ranking'

class Player

  VERSION = 'Ludicrous poker player'

  def bet_request(game_state)
    bet = handle_request(game_state)
    puts "Final bet: #{bet}"
    if bet < 0
      puts "ERROR: negative bet #{bet}"
      return 0
    end
    return bet
  rescue => e
    puts "ERROR: #{e}"
    return 0
  end

  def handle_request(game_state)
    puts game_state
    me = game_state['players'][game_state['in_action']]
    hole_cards = me['hole_cards']
    my_bet = me['bet'].to_i
    call = game_state['current_buy_in'].to_i - my_bet
    raise_amount = get_raise_amount_by_number_of_players(call, game_state)

    community_cards = game_state['community_cards']
    if Ranking.my_flush(hole_cards, community_cards)
      return 10000
    end
    if Ranking.open_flush_on_table(community_cards) and game_state['current_buy_in'].to_i > my_bet * 2
      return 0
    end

    if community_cards.empty?
      if high_cards?(hole_cards) and game_state['current_buy_in'].to_i < my_bet * 3
        return call
      end
    else

      if Ranking.three_of_a_kind_with_our_card(hole_cards, community_cards)
        puts "Three of a kind"
        if community_cards.size == 3
          return 10000
        else
          return raise_amount
        end

      end
      
      if Ranking.two_pair_with_our_cards(hole_cards, community_cards)
        puts "Two pair"
        return raise_amount
      end

       if Ranking.two_pair_with_one_of_mine(hole_cards, community_cards)
        puts "Two pair only one of mine"
        return raise_amount
      end

      if Ranking.pair_with_our_card(hole_cards, community_cards)
        puts "Pair with community card"
        return raise_amount
      end
    end

    if high_pair?(hole_cards)
      puts "high pair"
      return raise_amount
    end

    if middle_pair?(hole_cards)
      puts "middle pair"
      return call
    end

    if headsup(game_state)
      puts "heads up"

      if ak_suited(hole_cards)
        puts "ak suited"
        return call
      end

      if pair?(hole_cards)
        return call
      end

    end

    0
  end

  def get_raise_amount_by_number_of_players(call, game_state)
    raise_amount = call + game_state['minimum_raise'].to_i
    if everyone_plays(game_state)
      raise_amount = call
    end
    unless headsup(game_state)
      raise_amount = raise_amount + 200
    end
    raise_amount
  end

  def headsup(game_state)
    active_players(game_state) == 2
  end

  def everyone_plays(game_state)
    active_players(game_state) == 4
  end

  def active_players(game_state)
    game_state['players'].select { |player| player['status'] != 'out' }.size
  end

  def small_pot(game_state)
    game_state['pot'] < game_state['small_blind'] * 4 * 4
  end


  def ak_suited(hole_cards)
    ['A', 'K'].include?(hole_cards[0]['rank']) and ['A', 'K'].include?(hole_cards[1]['rank']) and hole_cards[0]['suit'] == hole_cards[1]['suit']
  end

  def high_pair?(hole_cards)
    pair?(hole_cards) and [10, 'J', 'Q', 'K', 'A'].include?(hole_cards[0]['rank'])
  end

  def middle_pair?(hole_cards)
    pair?(hole_cards) and [8, 9, 10, 'J', 'Q', 'K', 'A'].include?(hole_cards[0]['rank'])
  end

  def high_cards?(hole_cards)
    [10, 'J', 'Q', 'K', 'A'].include?(hole_cards[0]['rank']) and [10, 'J', 'Q', 'K', 'A'].include?(hole_cards[1]['rank'])
  end

  def pair?(hole_cards)
    hole_cards[0]['rank'] == hole_cards[1]['rank']
  end

  def showdown(game_state)

  end
end
