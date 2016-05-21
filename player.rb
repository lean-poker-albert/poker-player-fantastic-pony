
require_relative 'ranking'

class Player

  VERSION = 'Ludicrous poker player'

  def bet_request(game_state)
    bet = handle_request(game_state)
    puts "Final bet: #{bet}"
    return bet
  rescue => e
    puts "ERROR: #{e}"
    return 0
  end

  def handle_request(game_state)
    puts game_state
    me = game_state['players'][game_state['in_action']]
    hole_cards = me['hole_cards']
    raise = game_state['current_buy_in'] + game_state['minimum_raise'] + 200

    if game_state['community_cards'].empty?
      if high_cards?(hole_cards) and game_state['current_buy_in'] < me['bet'] * 3
        return game_state['current_buy_in'] - me['bet']
      end
    else
      if Ranking.pair_with_our_card(hole_cards, game_state['community_cards'])
        puts "Pair with community card"
        return raise
      end
      if Ranking.three_of_a_kind_with_our_card(hole_cards, game_state['community_cards'])
        puts "Three of a kind"
        return raise
      end
    end

    if high_pair?(hole_cards)
      puts "high pair"
      return raise
    end

    if game_state['players'].select { |player| player['status'] != 'out' }.size == 2
      puts "heads up"

      if ak_suited(hole_cards)
        puts "ak suited"
        return game_state['current_buy_in'] - me['bet']
      end

      if pair?(hole_cards)
        return game_state['current_buy_in'] - me['bet']
      end

    end

    0
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

  def high_cards?(hole_cards)
    [10, 'J', 'Q', 'K', 'A'].include?(hole_cards[0]['rank']) and [10, 'J', 'Q', 'K', 'A'].include?(hole_cards[1]['rank'])
  end

  def pair?(hole_cards)
    hole_cards[0]['rank'] == hole_cards[1]['rank']
  end

  def showdown(game_state)

  end
end
