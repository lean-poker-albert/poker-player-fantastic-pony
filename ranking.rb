class Ranking
  def three_of_a_kind_with_our_card(hole_cards, community_cards)
    three_of_a_kind_with(hole_cards[0], community_cards) or three_of_a_kind_with(hole_cards[1],community_cards)
  end

  def three_of_a_kind_with(hole_card, community_cards)
    community_cards.select { |card| card['rank'] == hole_card['rank'] }.size
  end

end