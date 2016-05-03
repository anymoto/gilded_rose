class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      type = case item.name
             when /Aged/i
                AgedItem
             when /Backstage/i
                BackstageItem
             when /Conjured/i
               ConjuredItem
             when /Sulfuras/i
               SulfurasItem
             else
               RegularItem
             end
      type.new(item).update
    end
  end
end

private

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

class ConjuredItem < BaseItem
  def update
    item.quality -= 2
    item.sell_in -= 1
    item.quality = 0 if item.quality < 0
  end
end

class SulfurasItem < BaseItem
  def update; end
end

class BackstageItem < BaseItem
  def update
    item.quality += 1 if item.sell_in > 10
    item.quality += 2 if item.sell_in.between?(6, 10)
    item.quality += 3 if item.sell_in.between?(1, 5)
    item.quality = 0 if item.sell_in == 0

    item.quality = 50 if item.quality > 50
    item.sell_in -= 1
  end
end

class AgedItem < BaseItem
  def update
    item.quality += 1 if item.quality < 50
    item.sell_in -= 1
  end
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
