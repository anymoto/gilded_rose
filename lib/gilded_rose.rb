class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        item.quality < 50 && item.quality += 1
        item.sell_in -= 1
      when 'Backstage passes to a TAFKAL80ETC concert'
        item.sell_in > 10 && item.quality < 50 && item.quality += 1
        item.sell_in > 6 && item.sell_in <= 10 && item.quality < 50 && item.quality += 2
        item.sell_in < 6 && item.sell_in > 0 && item.quality < 50 && item.quality += 3
        item.sell_in == 0 && item.quality = 0
      when 'Sulfuras, Hand of Ragnaros'
        next
      when 'Conjured'
        item.quality > 1 && item.quality -= 2
        item.quality < 2 && item.quality = 0
        item.sell_in -= 1
      else
        item.sell_in > 0 && item.quality > 0 && item.quality -= 1
        item.sell_in < 1 && item.quality > 1 && item.quality -= 2
        item.sell_in < 1 && item.quality < 2 && item.quality = 0
        item.sell_in -= 1
      end
    end
  end
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
