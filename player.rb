
class Player

  VERSION = 'Ludicrous poker player'

  def bet_request(game_state)
    hole_cards = game_state['players'][game_state['in_action']]['hole_cards']
    if high_pair?(hole_cards)
      return 10000
    end

    if game_state['players'].filter { |player| player['status'] == 'active' }.size == 2
      if ak_suited(hole_cards)
        return 1000
      end

      if game_state['dealer'] == game_state['in_action'] and small_pot(game_state)
        return game_state['small_blind'] * 4 * 4 * 10
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
    hole_cards[0]['rank'] == hole_cards[1]['rank'] and [10, 'J', 'Q', 'K', 'A'].include?(hole_cards[0]['rank'])
  end

  def showdown(game_state)

  end
end
