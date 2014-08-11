require_relative '../../lib/player'
require_relative '../../lib/deck'
require_relative '../../lib/card'

describe Player do
  describe '.new' do
    subject { Player.new(true, "Nick") }
    it { expect(subject.name).to eq("Nick") }
  end

  describe '.draw' do
    it 'should get a card from the deck' do
      deck = Deck.new
      old_length = deck.cards.length
      player = Player.new(true, "Nick")
      player.draw(deck)
      expect(old_length - deck.cards.length).to be(1)
      expect(player.hand.length).to be(1)
    end
  end
end
