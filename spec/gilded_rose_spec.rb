require_relative '../lib/gilded_rose'

describe GildedRose do

  describe '#new' do
    let(:item) { Item.new('item', 2, 6) }
    let(:subject) { GildedRose.new([item]) }

    it { should be_kind_of(GildedRose) }
  end

  describe '#update_quality' do
    ######### Regular item context

    context 'Single regular item' do
      let(:item) { Item.new('item', 5, 10) }
      let(:subject) { GildedRose.new([item]) }

      it 'decreases sell in date' do
        expect{ subject.update_quality }.to change{ item.sell_in }.from(5).to(4)
      end

      it 'decreases quality' do
        expect{ subject.update_quality }.to change{ item.quality }.from(10).to(9)
      end

      context 'when the sell by date has passed' do
        let(:item) { Item.new('item', 0, 10) }
        let(:subject) { GildedRose.new([item]) }

        it 'decreases quality twice as fast' do
          expect{ subject.update_quality }.to change{ item.quality }.from(10).to(8)
        end
      end

      context 'when the quality is zero and sell by date has passed' do
        let(:item) { Item.new('item', 0, 0) }
        let(:subject) { GildedRose.new([item]) }

        it 'does not decrease quality' do
          expect{ subject.update_quality }.to_not change{ item.quality }
        end
      end
    end

    ########## Aged Brie context

    context 'Aged Brie' do
      let(:item) { Item.new('Aged Brie', 3, 10) }
      let(:subject) { GildedRose.new([item]) }

      it 'decreases sell in date' do
        expect{ subject.update_quality }.to change{ item.sell_in }.from(3).to(2)
      end

      it 'increases quality' do
        expect{ subject.update_quality }.to change{ item.quality }.by(1)
      end

      context 'when quality is 50' do
        let(:item) { Item.new('Aged Brie', 3, 50) }
        let(:subject) { GildedRose.new([item]) }

        it 'does not increases quality' do
          expect{ subject.update_quality }.to_not change{ item.quality }
        end
      end
    end

    ######### Sulfuras contexts

    context 'Sulfuras, Hand of Ragnaros' do
      let(:item) { Item.new('Sulfuras, Hand of Ragnaros', 0, 80) }
      let(:subject) { GildedRose.new([item]) }

      before { subject.update_quality }

      it 'does not change item properties' do
        expect(item.sell_in).to eq(0)
        expect(item.quality).to eq(80)
      end
    end

    ######### Backstage Pass contexts

    context 'Backstage Pass' do
      context 'with more than 10 days left' do
        let(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 10) }
        let(:subject) { GildedRose.new([item]) }

        it 'increases quality by 1' do
          expect{ subject.update_quality }.to change{ item.quality }.by(1)
        end

        it 'decreases sell-in date' do
          expect{ subject.update_quality }.to change{ item.sell_in }.from(11).to(10)
        end
      end

      context 'with 10 days or less left' do
        let(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 8, 10) }
        let(:subject) { GildedRose.new([item]) }

        it 'increases quality by 2' do
          expect{ subject.update_quality }.to change{ item.quality }.by(2)
        end
      end

      context 'with 5 days or less left' do
        let(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 10) }
        let(:subject) { GildedRose.new([item]) }

        it 'increases quality by 3' do
          expect{ subject.update_quality }.to change{ item.quality }.by(3)
        end
      end

      context 'when sell in date has passed' do
        let(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10) }
        let(:subject) { GildedRose.new([item]) }

        it 'drops quality to 0' do
          expect{ subject.update_quality}.to change{ item.quality }.from(10).to(0)
        end
      end
    end


    ######### Conjured contexts

    context 'Conjured' do
      context 'with quality greater than 1' do
        let(:item) { Item.new('Conjured', 5, 8) }
        let(:subject) { GildedRose.new([item]) }

        it 'decreases sell-in date' do
          expect{ subject.update_quality }.to change{ item.sell_in }.from(5).to(4)
        end

        it 'decreases quality by 2' do
          expect{ subject.update_quality }.to change{ item.quality }.from(8).to(6)
        end
      end

      context 'with quality equals to zero' do
        let(:item) { Item.new('Conjured', 5, 0) }
        let(:subject) { GildedRose.new([item]) }

        it 'does not decrease quality' do
          expect{ subject.update_quality }.to_not change{ item.quality }
        end
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
      let(:subject) { GildedRose.new(items) }

      before { subject.update_quality }

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
end
