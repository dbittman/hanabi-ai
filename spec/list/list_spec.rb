require 'list'

describe List do
  describe '.new' do
    game = List.new('Danny', 'Nick', 'Jeannie', 'Eli', 'Tim')
    let(:list) { game }
    let(:node) { list.root }
    let(:state) { node.gameState }
    let(:hands_lengths) { state[:players].map {|p| p[:hand].length} }
    let(:cards_in_hands) { state[:players].map {|p| p[:hand] }.flatten }
    let(:all_cards) { state[:deck]  + cards_in_hands }
    let(:all_numbers) { all_cards.map { |c| c[:number] } }
    let(:all_colors) { all_cards.map { |c| c[:color] } }
    let(:children) { node.children }
    let(:hand) { state[:players][state[:currentPlayer]][:hand] }

    it { expect(list.last).to be node }
    it { expect(node.children).to be_empty }
    it { expect(node.parent).to be_nil }
    it { expect(node.move).to be
         {:id => 0, :players => ['Danny', 'Nick', 'Jeannie', 'Eli', 'Tim']} }
    it { expect(node.canon).to be true }
    it { expect(node.points).to eq(0) }
    it { expect(node.next).to be_nil }
    it 'has a base game state' do
      expect(state[:discard]).to be_empty
      expect(state[:players].length).to eq(5)
      expect(state[:currentPlayer]).to eq(0)
      expect(state[:tries]).to eq(3)
      expect(state[:clues]).to eq(8)
      expect(hands_lengths.count(4)).to eq(5)
      expect(state[:deck].length).to eq(30)
      expect(all_numbers.count(1)).to eq(15)
      expect(all_numbers.count(2)).to eq(10)
      expect(all_numbers.count(3)).to eq(10)
      expect(all_numbers.count(4)).to eq(10)
      expect(all_numbers.count(5)).to eq(5)
      expect(all_colors.count(0)).to eq(10)
      expect(all_colors.count(1)).to eq(10)
      expect(all_colors.count(2)).to eq(10)
      expect(all_colors.count(3)).to eq(10)
      expect(all_colors.count(4)).to eq(10)
    end
  end

  describe '.enumerateMoves' do
    game = List.new('Danny', 'Nick', 'Jeannie', 'Eli', 'Tim')
    total_moves = 0
    let(:list) { game }
    let(:node) { list.root }
    let(:state) { node.gameState }
    let(:me) { state[:currentPlayer] }
    let(:my_hand) { state[:players][me][:hand] } # TODO
    let(:moves) { node.enumerateMoves }
    let(:hands) { state[:players].map {|p| p[:hand] } }
    let(:colors) { hands.map {|h| h.map {|c| c[:color]}.uniq } }
    let(:numbers) { hands.map {|h| h.map {|c| c[:number]}.uniq } }

    it 'creates discard and play options for my hand' do
      (0...4).each do |c|
        expect(moves.include?({:id => 1, :card => c})).to be true
        expect(moves.include?({:id => 3, :card => c})).to be true
        total_moves += 2
      end
    end

    it 'creates clues for all the other players' do
      (0...hands.length).each do |p|
        if p != me
          colors[p].each do |c|
            expect(moves.include?({:id => 2, :targetHand => p, :color => c, :number => nil})).to be true
            total_moves += 1
          end
          numbers[p].each do |n|
            expect(moves.include?({:id => 2, :targetHand => p, :color => nil, :number => n})).to be true
            total_moves += 1
          end
        end
      end
    end

    it{ expect(total_moves).to eq(moves.length) } # no excess moves
  end

  describe '.makeChildren' do
    game = List.new('Danny', 'Nick', 'Jeannie', 'Eli', 'Tim')
    game.root.makeChildren()
    let(:list) { game }
    let(:node) { list.root }
    let(:moves) { node.enumerateMoves }
    let(:children) { node.children }

    it { expect(children.length).to eq(moves.length) }
    it 'is connected to its parent' do
      children.each do |child|
        expect(child.parent).to be(node)
      end
    end
  end
end
