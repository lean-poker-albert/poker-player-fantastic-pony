
class Player

  VERSION = 'Ludicrous poker player'

  def bet_request(game_state)
    hole_cards = game_state['players'][game_state['in_action']]['hole_cards']
    if hole_cards[0]['rank'] == hole_cards[1]['rank'] and [10,'J','Q','K','A'].include?(hole_cards[0]['rank'])
      return 10000
    elsif ['A','K'].include?(hole_cards[0]['rank']) and ['A','K'].include?(hole_cards[1]['rank']) and hole_cards[0]['suit'] == hole_cards[1]['suit']
      return 10000
    end
    0
  end

  def showdown(game_state)

  end
end
