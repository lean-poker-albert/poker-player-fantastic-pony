
class Player

  VERSION = 'Ludicrous poker player'

  def bet_request(game_state)
    hole_cards = game_state['players'][game_state['in_action']]['hole_cards']
    if hole_cards[0]['rank'] == hole_cards[1]['rank']
      return 10000
    end
    0
  end

  def showdown(game_state)

  end
end
