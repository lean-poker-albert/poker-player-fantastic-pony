class Ranking
  class << self
    def pair_with_our_card(hole_cards, community_cards)
      (pair_with(hole_cards[0], community_cards) && high?(hole_cards[0])) or 
      (pair_with(hole_cards[1], community_cards) && high?(hole_cards[1]))
    end

    def pair_with(hole_card, community_cards)
      community_cards.select { |card| card['rank'] == hole_card['rank'] }.size >= 1
    end

    def three_of_a_kind_with_our_card(hole_cards, community_cards)
      three_of_a_kind_with(hole_cards[0], community_cards) or three_of_a_kind_with(hole_cards[1],community_cards)
    end

    def three_of_a_kind_with(hole_card, community_cards)
      community_cards.select { |card| card['rank'] == hole_card['rank'] }.size == 2
    end

    def two_pair_with_our_cards(hole_cards, community_cards)
      pair_with(hole_cards[0], community_cards) && pair_with(hole_cards[1],community_cards)
    end

    def two_pair_with_one_of_mine(hole_cards, community_cards)
      (pair_with(hole_cards[0], community_cards) or pair_with(hole_cards[1],community_cards)) && pair_on_table(community_cards)
    end

    def pair_on_table(community_cards)
      community_cards.select { |card| community_cards.count(card) > 1 }.size >= 1
    end

    def high?(card)
      [8, 9, 10, 'J', 'Q', 'K', 'A'].include?(card['rank'])
    end

    def my_flush(hole_cards, community_cards)
      most_cards_from_any_suit(hole_cards + community_cards) > 4
    end

    def open_flush_on_table(community_cards)
      most_cards_from_any_suit(community_cards) > 2
    end

    def most_cards_from_any_suit(cards)
      ['diamonds','spades','hearts','clubs'].map { |suit| cards_from_suit(cards, suit) }.max
    end

    def cards_from_suit(cards, suit)
      cards.select { |card| card['rank'] == suit }.size
    end
  end
end