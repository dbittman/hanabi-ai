require_relative '../../lib/deck'
require_relative '../../lib/card'

describe Deck do
  describe '.new' do
    it 'should have the right number of cards' do
      d = Deck.new.test
      expect(d[:length]).to eq(50)
      expect(d[:yellow_cards].length).to eq(10)
      expect(d[:white_cards].length).to eq(10)
      expect(d[:red_cards].length).to eq(10)
      expect(d[:blue_cards].length).to eq(10)
      expect(d[:green_cards].length).to eq(10)
      expect(d[:yellow_cards].count(1)).to eq(3)
      expect(d[:yellow_cards].count(2)).to eq(2)
      expect(d[:yellow_cards].count(3)).to eq(2)
      expect(d[:yellow_cards].count(4)).to eq(2)
      expect(d[:yellow_cards].count(5)).to eq(1)
      expect(d[:white_cards].count(1)).to eq(3)
      expect(d[:white_cards].count(2)).to eq(2)
      expect(d[:white_cards].count(3)).to eq(2)
      expect(d[:white_cards].count(4)).to eq(2)
      expect(d[:white_cards].count(5)).to eq(1)
      expect(d[:red_cards].count(1)).to eq(3)
      expect(d[:red_cards].count(2)).to eq(2)
      expect(d[:red_cards].count(3)).to eq(2)
      expect(d[:red_cards].count(4)).to eq(2)
      expect(d[:red_cards].count(5)).to eq(1)
      expect(d[:blue_cards].count(1)).to eq(3)
      expect(d[:blue_cards].count(2)).to eq(2)
      expect(d[:blue_cards].count(3)).to eq(2)
      expect(d[:blue_cards].count(4)).to eq(2)
      expect(d[:blue_cards].count(5)).to eq(1)
      expect(d[:green_cards].count(1)).to eq(3)
      expect(d[:green_cards].count(2)).to eq(2)
      expect(d[:green_cards].count(3)).to eq(2)
      expect(d[:green_cards].count(4)).to eq(2)
      expect(d[:green_cards].count(5)).to eq(1)
    end
  end
end
