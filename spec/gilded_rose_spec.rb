require_relative '../lib/gilded_rose'

describe "#update_quality" do

  ######### Regular item contexts

  context "with a single regular item" do
    let(:initial_sell_in) { 5 }
    let(:initial_quality) { 10 }
    let(:name) { "item" }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }

    before { update_quality([item]) }

    it 'decreases sell in date' do
      expect(item.sell_in).to eq(4)
    end

    it 'decreases quality' do
      expect(item.quality).to eq(9)
    end
  end

  context 'when the regular item sell by date has passed' do
    let(:initial_sell_in) { 0 }
    let(:initial_quality) { 10 }
    let(:name) { "item" }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }

    before { update_quality([item]) }

    it 'decreases quality twice as fast' do
      expect(item.quality).to eq(8)
    end
  end

  context 'when the quality is almost zero and sell by date has passed' do
    let(:initial_sell_in) { 0 }
    let(:initial_quality) { 1 }
    let(:name) { "item" }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }

    before { update_quality([item]) }

    it 'does not set a negative number to quality' do
      expect(item.quality).to eq(0)
    end
  end

  ########## Aged Brie context

  context 'with Aged Brie' do
    let(:item) { Item.new('Aged Brie', 3, 10) }

    before { update_quality([item]) }

    it 'decreases sell in date' do
      expect(item.sell_in).to eq(2)
    end

    it 'increases quality' do
      expect(item.quality).to eq(11)
    end
  end

  context 'when Aged Brie quality is 50' do
    let(:item) { Item.new('Aged Brie', 3, 50) }

    before { update_quality([item]) }

    it 'does not increases quality' do
      expect(item.quality).to eq(50)
    end
  end


  ######### Sulfuras contexts

  context 'with Sulfuras, Hand of Ragnaros' do
    let(:item) { Item.new('Sulfuras, Hand of Ragnaros', 0, 80) }

    before { update_quality([item]) }

    it 'does not change item values' do
      expect(item.sell_in).to eq(0)
      expect(item.quality).to eq(80)
    end
  end

  ######### Backstage Passes contexts

  context 'with Backstage Passes with more than 10 days left' do
    let(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 10) }

    it 'increases quality by 1' do
      expect{ update_quality([item]) }.to change{ item.quality }.by(1)
    end
  end

  context 'with Backstage Passes with 10 days or less left' do
    let(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 8, 10) }

    it 'increases quality by 2' do
      expect{ update_quality([item]) }.to change{ item.quality }.by(2)
    end
  end

  context 'with Backstage Passes with 5 days or less left' do
    let(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 10) }

    it 'increases quality by 3' do
      expect{ update_quality([item]) }.to change{ item.quality }.by(3)
    end
  end

  ######### Conjured contexts

  context 'with Conjured item' do
    let(:item) { Item.new('Conjured', 5, 15) }

    it 'decreases sell-in date' do
      expect{ update_quality([item]) }.to change{ item.sell_in }.from(5).to(4)
    end

    it 'decreases quality by 2' do
      expect{ update_quality([item]) }.to change{ item.quality }.from(15).to(13)
    end
  end

  ######### With multiple items

  context "with multiple items" do
    let(:items) {
      [
        Item.new("NORMAL ITEM", 5, 10),
        Item.new("Aged Brie", 3, 10),
      ]
    }

    before { update_quality(items) }

    it 'changes items quality' do
      expect(items.first.quality).to eq(9)
      expect(items.last.quality).to eq(11)
    end

    it 'decreases items sell-in date' do
      expect(items.first.sell_in).to eq(4)
      expect(items.last.sell_in).to eq(2)
    end
  end
end
