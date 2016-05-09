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
      item.extend(type)
      item.update
    end
  end
end

########## DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)

private

module RegularItem
  def update
    if self.sell_in > 0
      self.quality -= 1
    else
      self.quality -= 2
    end

    self.sell_in -= 1
    self.quality = 0 if self.quality < 0
  end
end

module ConjuredItem
  def update
    self.quality -= 2
    self.sell_in -= 1
    self.quality = 0 if self.quality < 0
  end
end

module SulfurasItem
  def update; end
end

module BackstageItem
  def update
    self.quality += 1 if self.sell_in > 10
    self.quality += 2 if self.sell_in.between?(6, 10)
    self.quality += 3 if self.sell_in.between?(1, 5)
    self.quality = 0 if self.sell_in == 0

    self.quality = 50 if self.quality > 50
    self.sell_in -= 1
  end
end

module AgedItem
  def update
    self.quality += 1 if self.quality < 50
    self.sell_in -= 1
  end
end

