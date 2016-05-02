class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        item = AgedBrie.new(item)
        item.update
      when 'Backstage passes to a TAFKAL80ETC concert'
        item = BackstagePass.new(item)
        item.update
      when 'Sulfuras, Hand of Ragnaros'
        next
      when 'Conjured'
        item = Conjured.new(item)
        item.update
      else
        item = RegularItem.new(item)
        item.update
      end
    end
  end
end

class BaseItem
  attr_accessor :item

  def initialize(item)
    @item = item
  end
end

class RegularItem < BaseItem
  def update
    if item.sell_in > 0
      item.quality -= 1
    else
      item.quality -= 2
    end

    item.sell_in -= 1
    item.quality = 0 if item.quality < 0
  end
end

class Conjured < BaseItem
  def update
    item.quality -= 2

    item.sell_in -= 1
    item.quality = 0 if item.quality < 0
  end
end

class Sulfuras < BaseItem
end

class BackstagePass < BaseItem
  def update
    item.quality += 1 if item.sell_in > 10
    item.quality += 2 if item.sell_in.between?(6, 10)
    item.quality += 3 if item.sell_in.between?(1, 5)
    item.quality = 0 if item.sell_in == 0

    item.quality = 50 if item.quality > 50
  end
end

class AgedBrie < BaseItem
  def update
    item.quality += 1 if item.quality < 50
    item.sell_in -= 1
  end
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
